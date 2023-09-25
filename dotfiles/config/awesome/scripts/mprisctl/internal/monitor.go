package mprisctl

import (
	"time"

	"github.com/godbus/dbus/v5"
)

const (
	SignalNameOwnerChanged  = "org.freedesktop.DBus.NameOwnerChanged"
	SignalPropertiesChanged = "org.freedesktop.DBus.Properties.PropertiesChanged"
)

type mprisMonitor struct {
	mpris   *mpris
	players map[string]*Player
	tickers map[string]*resumableTicker
}

func newMprisMonitor() *mprisMonitor {
	return &mprisMonitor{
		mpris:   NewMpris(),
		players: make(map[string]*Player),
		tickers: make(map[string]*resumableTicker),
	}
}

var printMapping = map[string]func(player *Player){
	FieldMetadata:       printMetadata,
	FieldPlaybackStatus: printPlaybackStatus,
	FieldShuffle:        printShuffleStatus,
	FieldLoopStatus:     printLoopStatus,
}

var signalMapping = map[string]func(monitor *mprisMonitor, signal *dbus.Signal){
	SignalNameOwnerChanged:  onNameOwnerChanged,
	SignalPropertiesChanged: onPropertiesChanged,
	SignalSeeked:            onSeeked,
}

func onNameOwnerChanged(monitor *mprisMonitor, signal *dbus.Signal) {
	player, isMprisPlayer := monitor.playerFromSignal(signal)
	if isMprisPlayer == false {
		return
	}
	if monitor.mpris.hasOwner(player.Id) {
		monitor.registerPlayer(player)
		printConnectionStatus(player, true)
	} else {
		monitor.unregisterPlayer(*player)
		printConnectionStatus(player, false)
	}
}

func onPropertiesChanged(monitor *mprisMonitor, signal *dbus.Signal) {
	player, values, found := monitor.getMapFromSignal(signal)
	if found == false {
		return
	}
	shouldUpdateTicker := false
	printCapabilites := false
	player.updateProperties(values, func(p *Player, updateKey string) {
		if printer, printable := printMapping[updateKey]; printable {
			printer(p)
		}
		if updateKey == FieldPosition || updateKey == FieldPlaybackStatus {
			shouldUpdateTicker = true
		}
		switch updateKey {
		case FieldCanControl:
		case FieldCanGoNext:
		case FieldCanGoPrevious:
		case FieldCanPause:
		case FieldCanPlay:
		case FieldCanSeek:
			printCapabilites = true
		}
	})
	if shouldUpdateTicker {
		monitor.updateTicker(player.Id, player.Info[FieldPlaybackStatus].(string), time.Duration(player.Info[FieldPosition].(uint64)))
	}

	if printCapabilites {
		printCapabilities(player)
	}
}

func onSeeked(monitor *mprisMonitor, signal *dbus.Signal) {
	if player, _, found := monitor.getMapFromSignal(signal); found {
		position, _ := convertToUint64(signal.Body[0])
		player.Info[FieldPosition] = position
		elapsed := position % 1000000
		remaining := 1000000 - elapsed
		monitor.updateTicker(player.Id, player.Info[FieldPlaybackStatus].(string), time.Duration(remaining))
	}
}

func Watch() {

	monitor := newMprisMonitor()

	for _, player := range monitor.getPlayerList() {
		monitor.registerPlayer(player)

		printConnectionStatus(player, true)

		monitor.updateTicker(player.Id, player.Info[FieldPlaybackStatus].(string), time.Duration(player.Info[FieldPosition].(uint64)))

		// printCapabilities(player)
		// printMetadata(player)
		// printPlaybackStatus(player)
	}

	for signal := range monitor.watchSignal() {
		// spew.Dump("signal => ", signal)
		if handler, supported := signalMapping[signal.Name]; supported {
			handler(monitor, signal)
		}
	}
}

func (m mprisMonitor) watchSignal() chan *dbus.Signal {
	m.mpris.dbus.connection.AddMatchSignal(
		dbus.WithMatchObjectPath("/org/freedesktop/DBus"),
		dbus.WithMatchInterface("org.freedesktop.DBus"),
		dbus.WithMatchSender("org.freedesktop.DBus"),
	)
	return m.mpris.dbus.watchSignal()
}

func (m *mprisMonitor) getPlayerList() []*Player {

	players := make([]*Player, 0)
	for player := range m.mpris.getPlayerList() {
		values := m.mpris.getAll(player.Id)
		player.updateProperties(values, nil)
		m.players[player.Owner] = player
		players = append(players, player)
	}
	return players
}

func (m *mprisMonitor) playerFromSignal(signal *dbus.Signal) (*Player, bool) {
	id := signal.Body[0].(string)
	owner := signal.Body[2].(string)

	playerName, isMprisPlayer := m.mpris.getPlayerName(id)
	if isMprisPlayer == false {
		return nil, false
	}

	if existingPlayer, found := m.players[owner]; found == false {
		player := newPlayer(playerName, owner, id)
		m.players[owner] = player
		return player, true
	} else {
		return existingPlayer, true
	}
}

func (m mprisMonitor) getMapFromSignal(signal *dbus.Signal) (*Player, map[string]interface{}, bool) {
	if player, found := m.players[signal.Sender]; found {
		signalValue := store[map[string]interface{}](signal.Body)
		return player, signalValue, true
	} else {
		return nil, nil, false
	}

}

func (m *mprisMonitor) registerPlayer(player *Player) {
	m.players[player.Owner] = player
	m.mpris.addMatchSignal(player.Id)
	m.addTicker(player, printPosition)
}

func (m *mprisMonitor) unregisterPlayer(player Player) {
	m.mpris.removeMatchSignal(player.Id)
	delete(m.players, player.Owner)
	m.removeTicker(player.Owner)
}

func (m *mprisMonitor) addTicker(player *Player, callback func(uint64, string, uint64)) {
	tickCallback := func() {
		if position, ok := m.mpris.Position(player.Id); ok {
			player := m.players[player.Owner]
			player.Info[FieldPosition] = position
			callback(position, player.Name, player.Info[FieldMetadata].(map[string]interface{})[MetadataLength].(uint64)-position)
		}
	}

	ticker := newTicker(1*time.Second, tickCallback)
	m.tickers[player.Id] = ticker
}

func (m *mprisMonitor) removeTicker(playerId string) {
	if ticker, ok := m.tickers[playerId]; ok {
		ticker.stop()
		delete(m.tickers, playerId)
	}
}

func (m *mprisMonitor) updateTicker(playerId string, playbackStatus string, delay time.Duration) {
	if ticker, ok := m.tickers[playerId]; ok {
		switch playbackStatus {
		case PlaybackPaused:
			ticker.pause()
		case PlaybackPlaying:
			ticker.resumeOrStartAfter(delay)
		case PlaybackStopped:
			ticker.stop()
		}
	}
}
