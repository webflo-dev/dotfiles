package mprisctl

import (
	"time"

	"github.com/davecgh/go-spew/spew"
	"github.com/godbus/dbus/v5"
)

const (
	SignalNameOwnerChanged  = "org.freedesktop.DBus.NameOwnerChanged"
	SignalPropertiesChanged = "org.freedesktop.DBus.Properties.PropertiesChanged"
)

type MprisMonitor struct {
	mpris   *Mpris
	players map[string]*Player
	tickers map[string]*ResumableTicker
}

func NewMprisMonitor() *MprisMonitor {
	return &MprisMonitor{
		mpris:   NewMpris(),
		players: make(map[string]*Player),
		tickers: make(map[string]*ResumableTicker),
	}
}

var printMapping = map[string]func(player Player){
	FieldMetadata:       PrintMetadata,
	FieldPlaybackStatus: PrintPlaybackStatus,
	FieldShuffle:        PrintShuffleStatus,
	FieldLoopStatus:     PrintLoopStatus,
}

var signalMapping = map[string]func(monitor *MprisMonitor, signal *dbus.Signal){
	SignalNameOwnerChanged:  onNameOwnerChanged,
	SignalPropertiesChanged: onPropertiesChanged,
	SignalSeeked:            onSeeked,
}

func onNameOwnerChanged(monitor *MprisMonitor, signal *dbus.Signal) {
	player, isMprisPlayer := monitor.PlayerFromSignal(signal)
	if isMprisPlayer == false {
		return
	}
	if monitor.mpris.HasOwner(player.Id) {
		PrintConnectionStatus(*player, true)
		monitor.RegisterPlayer(player)
	} else {
		PrintConnectionStatus(*player, false)
		monitor.UnregisterPlayer(*player)
	}
}

func onPropertiesChanged(monitor *MprisMonitor, signal *dbus.Signal) {
	player, values, found := monitor.GetMapFromSignal(signal)
	if found == false {
		return
	}
	player.UpdateInfo(values, func(p Player, updateKey string) {
		if printer, printable := printMapping[updateKey]; printable {
			printer(p)
		}
		if updateKey == FieldPlaybackStatus {
			monitor.UpdateTicker(player.Id, player.Info.PlaybackStatus)
		}
	})
}

func onSeeked(monitor *MprisMonitor, signal *dbus.Signal) {
	if player, _, found := monitor.GetMapFromSignal(signal); found {
		position, _ := ConvertToUint64(signal.Body[0])
		spew.Dump("position => ", position)
		spew.Dump("player => ", player)

		// elapsed := position % 1000000
		// remaining := 1000000 - elapsed
		// monitor.StopTicker(player.Id)
		// monitor.StartTicker(player.Id, remaining)
	}
}

func Watch() {

	mprisMonitor := NewMprisMonitor()

	for _, player := range mprisMonitor.GetPlayerList() {
		mprisMonitor.RegisterPlayer(player)

		mprisMonitor.UpdateTicker(player.Id, player.Info.PlaybackStatus)

		PrintConnectionStatus(*player, true)
		PrintMetadata(*player)
		PrintPlaybackStatus(*player)
	}

	for signal := range mprisMonitor.WatchSignal() {
		if handler, supported := signalMapping[signal.Name]; supported {
			handler(mprisMonitor, signal)
		}
	}
}

func (m MprisMonitor) WatchSignal() chan *dbus.Signal {
	m.mpris.dbus.Connection.AddMatchSignal(
		dbus.WithMatchObjectPath("/org/freedesktop/DBus"),
		dbus.WithMatchInterface("org.freedesktop.DBus"),
		dbus.WithMatchSender("org.freedesktop.DBus"),
	)
	return m.mpris.dbus.WatchSignal()
}

func (m *MprisMonitor) GetPlayerList() []*Player {

	players := make([]*Player, 0)
	for player := range m.mpris.GetPlayerList() {

		values := m.mpris.GetAll(player.Id)
		spew.Dump("values => ", values)
		player.UpdateInfo(values, nil)

		m.players[player.Owner] = player
		players = append(players, player)
	}
	return players
}

func (m *MprisMonitor) PlayerFromSignal(signal *dbus.Signal) (*Player, bool) {
	id := signal.Body[0].(string)
	owner := signal.Body[2].(string)

	playerName, isMprisPlayer := m.mpris.GetPlayerName(id)
	if isMprisPlayer == false {
		return nil, false
	}

	if existingPlayer, found := m.players[owner]; found == false {
		player := NewPlayer(playerName, owner, id)
		m.players[owner] = player
		return player, true
	} else {
		return existingPlayer, true
	}
}

func (m MprisMonitor) GetMapFromSignal(signal *dbus.Signal) (*Player, map[string]interface{}, bool) {
	if player, found := m.players[signal.Sender]; found {
		signalValue := Store[map[string]interface{}](signal.Body)
		return player, signalValue, true
	} else {
		return nil, nil, false
	}

}

func (m *MprisMonitor) RegisterPlayer(player *Player) {
	m.players[player.Owner] = player
	m.mpris.AddMatchSignal(player.Id)
	m.AddTicker(player, PrintPosition)
}

func (m *MprisMonitor) UnregisterPlayer(player Player) {
	m.mpris.RemoveMatchSignal(player.Id)
	delete(m.players, player.Owner)
	m.RemoveTicker(player.Owner)
}

func (m *MprisMonitor) AddTicker(player *Player, callback func(uint64, string, uint64)) {
	tickCallback := func() {
		if position, ok := m.mpris.Position(player.Id); ok {
			player := m.players[player.Owner]
			player.Info.Position = position
			callback(position, player.Name, player.Info.Metadata.Length-position)
		}
	}

	ticker := NewTicker(1*time.Second, tickCallback)
	m.tickers[player.Id] = ticker
}

func (m *MprisMonitor) RemoveTicker(playerId string) {
	if ticker, ok := m.tickers[playerId]; ok {
		ticker.Stop()
		delete(m.tickers, playerId)
	}
}

func (m *MprisMonitor) UpdateTicker(playerId string, playbackStatus string) {
	if ticker, ok := m.tickers[playerId]; ok {
		switch playbackStatus {
		case PlaybackPaused:
			ticker.Pause()
		case PlaybackPlaying:
			ticker.ResumeOrStart()
		case PlaybackStopped:
			ticker.Stop()
		}
	}
}
