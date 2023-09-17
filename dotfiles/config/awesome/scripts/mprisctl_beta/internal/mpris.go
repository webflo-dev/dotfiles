package mprisctl

import (
	"strings"
	"time"

	"github.com/godbus/dbus/v5"
)

const (
	MprisPlayerIdentifier = "org.mpris.MediaPlayer2."
	MprisPath             = "/org/mpris/MediaPlayer2"
	MprisInterface        = "org.mpris.MediaPlayer2.Player"
)

const (
	PropertyPosition = MprisInterface + ".Position"
	PropertyShuffle  = MprisInterface + ".Shuffle"

	MethodPlayPause   = MprisInterface + ".PlayPause"
	MethodPlay        = MprisInterface + ".Play"
	MethodPause       = MprisInterface + ".Pause"
	MethodStop        = MprisInterface + ".Stop"
	MethodNext        = MprisInterface + ".Next"
	MethodPrevious    = MprisInterface + ".Previous"
	MethodSetPosition = MprisInterface + ".SetPosition"
)

const (
	MethodListNames    = "org.freedesktop.DBus.ListNames"
	MethodGetOwner     = "org.freedesktop.DBus.GetNameOwner"
	MethodGetAll       = "org.freedesktop.DBus.Properties.GetAll"
	MethodNameHasOwner = "org.freedesktop.DBus.NameHasOwner"
)

const (
	SignalNameOwnerChanged  = "org.freedesktop.DBus.NameOwnerChanged"
	SignalPropertiesChanged = "org.freedesktop.DBus.Properties.PropertiesChanged"
	SignalSeeked            = MprisInterface + ".Seeked"
)

type Mpris struct {
	dbus    *DBus
	players map[string]*Player
	tickers map[string]*ResumableTicker
}

func NewMpris() *Mpris {
	return &Mpris{
		dbus:    NewDBus(),
		players: make(map[string]*Player),
		tickers: make(map[string]*ResumableTicker),
	}
}

func (m *Mpris) GetPlayerList() []*Player {
	var names []string
	m.dbus.CallMethodWithBusObject(MethodListNames).Store(&names)

	players := make([]*Player, 0)
	for _, playerId := range names {

		if playerId == "org.mpris.MediaPlayer2.playerctld" {
			continue
		}

		_, playerName, isMprisPlayer := strings.Cut(playerId, MprisPlayerIdentifier)
		if isMprisPlayer == false {
			continue
		}

		if m.IsPlayerConnected(playerId) == false {
			continue
		}

		var owner string
		m.dbus.CallMethodWithBusObject(MethodGetOwner, playerId).Store(&owner)

		player := NewPlayer(playerName, owner, playerId)

		var values map[string]interface{}

		m.dbus.CallMethod(m.dbus.Connection.Object(playerId, MprisPath), MethodGetAll, MprisInterface).Store(&values)

		player.UpdateInfo(values)

		m.players[owner] = player
		players = append(players, player)
	}
	return players
}

func (m Mpris) StartMonitoring() chan *dbus.Signal {
	m.dbus.Connection.AddMatchSignal(
		dbus.WithMatchObjectPath("/org/freedesktop/DBus"),
		dbus.WithMatchInterface("org.freedesktop.DBus"),
		dbus.WithMatchSender("org.freedesktop.DBus"),
	)
	return m.dbus.WatchSignal()
}

func (m *Mpris) PlayerFromSignal(signal *dbus.Signal) (*Player, bool) {
	id := signal.Body[0].(string)
	owner := signal.Body[2].(string)
	_, playerName, isMprisPlayer := strings.Cut(id, MprisPlayerIdentifier)

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

func (m Mpris) GetFromSignal(signal *dbus.Signal) (*Player, map[string]interface{}, bool) {
	player, found := m.players[signal.Sender]
	signalValue := Store[map[string]interface{}](signal.Body)
	return player, signalValue, found
}

func (m Mpris) IsPlayerConnected(playerId string) bool {
	started := false
	m.dbus.CallMethodWithBusObject(MethodNameHasOwner, playerId).Store(&started)
	return started
}

func (m *Mpris) RegisterPlayer(player *Player) {

	m.players[player.Owner] = player

	m.dbus.Connection.AddMatchSignal(
		dbus.WithMatchObjectPath(MprisPath),
		dbus.WithMatchSender(player.Id),
	)

	m.AddTicker(player, PrintPosition)
}

func (m *Mpris) UnregisterPlayer(player Player) {
	m.dbus.Connection.RemoveMatchSignal(
		dbus.WithMatchObjectPath(MprisPath),
		dbus.WithMatchSender(player.Id),
	)
	delete(m.players, player.Owner)
	m.RemoveTicker(player.Owner)
}

func (m *Mpris) AddTicker(player *Player, callback func(uint64, string, uint64)) {
	tickCallback := func() {
		if variant, err := m.dbus.GetProperty(player.Id, MprisPath, PropertyPosition); err == nil {
			position := ConvertToUint64(variant.Value())
			player := m.players[player.Owner]
			callback(position, player.Name, player.Info.TrackInfo.Length-position)
		}
	}

	ticker := NewTicker(1*time.Second, tickCallback)
	m.tickers[player.Id] = ticker
}

func (m *Mpris) RemoveTicker(playerId string) {
	if ticker, ok := m.tickers[playerId]; ok {
		ticker.Stop()
		delete(m.tickers, playerId)
	}
}

func (m *Mpris) UpdateTicker(playerId string, playbackStatus string) {
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
func (m *Mpris) RestartTicker(playerId string) {
	if ticker, ok := m.tickers[playerId]; ok {
		ticker.Stop()
		ticker.Start()
	}
}
