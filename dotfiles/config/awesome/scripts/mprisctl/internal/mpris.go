package mprisctl

import (
	"strings"

	"github.com/godbus/dbus/v5"
)

const (
	MprisPlayerIdentifier = "org.mpris.MediaPlayer2."
	MprisPath             = "/org/mpris/MediaPlayer2"
	MprisInterface        = "org.mpris.MediaPlayer2.Player"

	MethodGetAll       = "org.freedesktop.DBus.Properties.GetAll"
	methodGetOwner     = "org.freedesktop.DBus.GetNameOwner"
	methodListNames    = "org.freedesktop.DBus.ListNames"
	methodNameHasOwner = "org.freedesktop.DBus.NameHasOwner"

	PropertyCanControl     = MprisInterface + "." + FieldCanControl
	PropertyCanGoNext      = MprisInterface + "." + FieldCanGoNext
	PropertyCanGoPrevious  = MprisInterface + "." + FieldCanGoPrevious
	PropertyCanPause       = MprisInterface + "." + FieldCanPause
	PropertyCanPlay        = MprisInterface + "." + FieldCanPlay
	PropertyCanSeek        = MprisInterface + "." + FieldCanSeek
	PropertyLoopStatus     = MprisInterface + "." + FieldLoopStatus
	PropertyMaximumRate    = MprisInterface + "." + FieldMaximumRate
	PropertyMetadata       = MprisInterface + "." + FieldMetadata
	PropertyMinimumRate    = MprisInterface + "." + FieldMinimumRate
	PropertyPlaybackStatus = MprisInterface + "." + FieldPlaybackStatus
	PropertyPosition       = MprisInterface + "." + FieldPosition
	PropertyRate           = MprisInterface + "." + FieldRate
	PropertyShuffle        = MprisInterface + "." + FieldShuffle
	PropertyVolume         = MprisInterface + "." + FieldVolume

	SignalSeeked = MprisInterface + ".Seeked"

	MethodNext        = MprisInterface + ".Next"
	MethodOpenUri     = MprisInterface + ".OpenUri"
	MethodPause       = MprisInterface + ".Pause"
	MethodPlay        = MprisInterface + ".Play"
	MethodPlayPause   = MprisInterface + ".PlayPause"
	MethodPrevious    = MprisInterface + ".Previous"
	MethodSeek        = MprisInterface + ".Seek"
	MethodSetPosition = MprisInterface + ".SetPosition"
	MethodStop        = MprisInterface + ".Stop"
)

type Mpris struct {
	dbus *DBus
}

func NewMpris() *Mpris {
	return &Mpris{
		dbus: NewDBus(),
	}
}

func (m Mpris) GetPlayerList() chan *Player {
	var playerIds []string
	m.dbus.CallMethodWithBusObject(methodListNames).Store(&playerIds)
	channel := make(chan *Player)
	go func() {
		for _, playerId := range playerIds {
			if playerId == "org.mpris.MediaPlayer2.playerctld" {
				continue
			}

			playerName, isMprisPlayer := m.GetPlayerName(playerId)
			if isMprisPlayer == false {
				continue
			}

			// if m.HasOwner(playerId) == false {
			// 	continue
			// }
			owner := m.GetOwner(playerId)
			channel <- NewPlayer(playerName, owner, playerId)
		}
		close(channel)
	}()
	return channel
}

func (m Mpris) GetPlayerId(playerName string) string {
	return MprisPlayerIdentifier + playerName
}
func (m Mpris) GetPlayerName(playerId string) (string, bool) {
	if _, playerName, ok := strings.Cut(playerId, MprisPlayerIdentifier); ok {
		return playerName, true
	}
	return "", false
}

func (m Mpris) GetOwner(playerId string) string {
	var owner string
	m.dbus.CallMethodWithBusObject(methodGetOwner, playerId).Store(&owner)
	return owner
}

func (m Mpris) GetAll(playerId string) map[string]interface{} {
	var values map[string]interface{}
	m.dbus.CallMethod(m.dbus.Connection.Object(playerId, MprisPath), MethodGetAll, MprisInterface).Store(&values)
	return values
}

func (m Mpris) HasOwner(playerId string) bool {
	started := false
	m.dbus.CallMethodWithBusObject(methodNameHasOwner, playerId).Store(&started)
	return started
}

func (m *Mpris) AddMatchSignal(playerId string) {
	m.dbus.Connection.AddMatchSignal(
		dbus.WithMatchObjectPath(MprisPath),
		dbus.WithMatchSender(playerId),
	)
}

func (m *Mpris) RemoveMatchSignal(playerId string) {
	m.dbus.Connection.RemoveMatchSignal(
		dbus.WithMatchObjectPath(MprisPath),
		dbus.WithMatchSender(playerId),
	)
}

func getProperty[T any](dbus *DBus, playerId string, property string, converter func(interface{}) (T, bool)) (T, bool) {
	variant, err := dbus.GetProperty(playerId, MprisPath, property)
	if err != nil {
		return Zero[T](), false
	}
	return converter(variant.Value())
}

func (m Mpris) callMethod(playerId string, method string, args ...interface{}) {
	busObj := m.dbus.Connection.Object(playerId, MprisPath)
	m.dbus.CallMethod(busObj, method, args...)
}

func (m Mpris) Play(playerId string) {
	m.callMethod(playerId, MethodPlay)
}
func (m Mpris) Pause(playerId string) {
	m.callMethod(playerId, MethodPause)
}
func (m Mpris) PlayPause(playerId string) {
	m.callMethod(playerId, MethodPlayPause)
}
func (m Mpris) Next(playerId string) {
	m.callMethod(playerId, MethodNext)
}
func (m Mpris) Previous(playerId string) {
	m.callMethod(playerId, MethodPrevious)
}
func (m Mpris) Stop(playerId string) {
	m.callMethod(playerId, MethodStop)
}

func (m Mpris) Position(playerId string) (uint64, bool) {
	return getProperty(m.dbus, playerId, PropertyPosition, ConvertToUint64)
}

func (m Mpris) SetPosition(playerId string, position int64) {
	values := m.GetAll(playerId)
	if metadata, ok := ConvertToMetadata(values, nil); ok {
		m.callMethod(playerId, MethodSetPosition, dbus.ObjectPath(metadata.(map[string]any)[MetadataTrackId].(string)), position)
	}
}

func (m Mpris) CanControl(playerId string) (bool, bool) {
	return getProperty(m.dbus, playerId, PropertyCanControl, ConvertToBool)
}

func (m Mpris) CanGoNext(playerId string) (bool, bool) {
	return getProperty(m.dbus, playerId, PropertyCanGoNext, ConvertToBool)
}

func (m Mpris) CanGoPrevious(playerId string) (bool, bool) {
	return getProperty(m.dbus, playerId, PropertyCanGoPrevious, ConvertToBool)
}

func (m Mpris) CanPause(playerId string) (bool, bool) {
	return getProperty(m.dbus, playerId, PropertyCanPause, ConvertToBool)
}

func (m Mpris) CanPlay(playerId string) (bool, bool) {
	return getProperty(m.dbus, playerId, PropertyCanPlay, ConvertToBool)
}

func (m Mpris) CanSeek(playerId string) (bool, bool) {
	return getProperty(m.dbus, playerId, PropertyCanSeek, ConvertToBool)
}

func (m Mpris) LoopStatus(playerId string) (string, bool) {
	return getProperty(m.dbus, playerId, PropertyLoopStatus, ConvertToString)
}
func (m Mpris) SetLoopStatus(playerId string, value string) {
	m.dbus.SetProperty(playerId, MprisPath, PropertyLoopStatus, value)
}

func (m Mpris) MaximumRate(playerId string) (float64, bool) {
	return getProperty(m.dbus, playerId, PropertyMaximumRate, ConvertToFloat64)
}

func (m Mpris) Metadata(playerId string) (map[string]dbus.Variant, bool) {
	return getProperty(m.dbus, playerId, PropertyMetadata, func(value interface{}) (map[string]dbus.Variant, bool) {
		return value.(map[string]dbus.Variant), true
	})
}

func (m Mpris) MinimumRate(playerId string) (float64, bool) {
	return getProperty(m.dbus, playerId, PropertyMinimumRate, ConvertToFloat64)
}

func (m Mpris) PlaybackStatus(playerId string) (string, bool) {
	return getProperty(m.dbus, playerId, PropertyPlaybackStatus, ConvertToString)
}

func (m Mpris) Rate(playerId string) (float64, bool) {
	return getProperty(m.dbus, playerId, PropertyRate, ConvertToFloat64)
}

func (m Mpris) Shuffle(playerId string) (bool, bool) {
	return getProperty(m.dbus, playerId, PropertyShuffle, ConvertToBool)
}
func (m Mpris) SetShuffle(playerId string, value bool) {
	m.dbus.SetProperty(playerId, MprisPath, PropertyShuffle, value)
}

func (m Mpris) Volume(playerId string) (float64, bool) {
	return getProperty(m.dbus, playerId, PropertyVolume, ConvertToFloat64)
}
