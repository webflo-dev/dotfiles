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

type mpris struct {
	dbus *dbusWrapper
}

func NewMpris() *mpris {
	return &mpris{
		dbus: newDBus(),
	}
}

func (m mpris) getPlayerList() chan *Player {
	var playerIds []string
	m.dbus.callMethodWithBusObject(methodListNames).Store(&playerIds)
	channel := make(chan *Player)
	go func() {
		for _, playerId := range playerIds {
			if playerId == "org.mpris.MediaPlayer2.playerctld" {
				continue
			}

			playerName, isMprisPlayer := m.getPlayerName(playerId)
			if isMprisPlayer == false {
				continue
			}

			// if m.HasOwner(playerId) == false {
			// 	continue
			// }
			owner := m.getOwner(playerId)
			channel <- newPlayer(playerName, owner, playerId)
		}
		close(channel)
	}()
	return channel
}

func GetPlayerId(playerName string) string {
	return MprisPlayerIdentifier + playerName
}

func (m mpris) getPlayerName(playerId string) (string, bool) {
	if _, playerName, ok := strings.Cut(playerId, MprisPlayerIdentifier); ok {
		return playerName, true
	}
	return "", false
}

func (m mpris) getOwner(playerId string) string {
	var owner string
	m.dbus.callMethodWithBusObject(methodGetOwner, playerId).Store(&owner)
	return owner
}

func (m mpris) getAll(playerId string) map[string]interface{} {
	var values map[string]interface{}
	m.dbus.callMethod(m.dbus.connection.Object(playerId, MprisPath), MethodGetAll, MprisInterface).Store(&values)
	return values
}

func (m mpris) hasOwner(playerId string) bool {
	started := false
	m.dbus.callMethodWithBusObject(methodNameHasOwner, playerId).Store(&started)
	return started
}

func (m *mpris) addMatchSignal(playerId string) {
	m.dbus.connection.AddMatchSignal(
		dbus.WithMatchObjectPath(MprisPath),
		dbus.WithMatchSender(playerId),
	)
}

func (m *mpris) removeMatchSignal(playerId string) {
	m.dbus.connection.RemoveMatchSignal(
		dbus.WithMatchObjectPath(MprisPath),
		dbus.WithMatchSender(playerId),
	)
}

func getProperty[T any](dbus *dbusWrapper, playerId string, property string, converter func(interface{}) (T, bool)) (T, bool) {
	variant, err := dbus.getProperty(playerId, MprisPath, property)
	if err != nil {
		return zeroValue[T](), false
	}
	return converter(variant.Value())
}

func (m mpris) callMethod(playerId string, method string, args ...interface{}) {
	busObj := m.dbus.connection.Object(playerId, MprisPath)
	m.dbus.callMethod(busObj, method, args...)
}

func (m mpris) Play(playerId string) {
	m.callMethod(playerId, MethodPlay)
}
func (m mpris) Pause(playerId string) {
	m.callMethod(playerId, MethodPause)
}
func (m mpris) PlayPause(playerId string) {
	m.callMethod(playerId, MethodPlayPause)
}
func (m mpris) Next(playerId string) {
	m.callMethod(playerId, MethodNext)
}
func (m mpris) Previous(playerId string) {
	m.callMethod(playerId, MethodPrevious)
}
func (m mpris) Stop(playerId string) {
	m.callMethod(playerId, MethodStop)
}

func (m mpris) Position(playerId string) (uint64, bool) {
	return getProperty(m.dbus, playerId, PropertyPosition, convertToUint64)
}

func (m mpris) SetPosition(playerId string, position int64) {
	values := m.getAll(playerId)
	rawTrackId := getMetadataValueFromRawValues(values, MetadataTrackId)
	trackId, _ := convertToString(rawTrackId)
	m.callMethod(playerId, MethodSetPosition, dbus.ObjectPath(trackId), position)
}

func (m mpris) CanControl(playerId string) (bool, bool) {
	return getProperty(m.dbus, playerId, PropertyCanControl, convertToBool)
}

func (m mpris) CanGoNext(playerId string) (bool, bool) {
	return getProperty(m.dbus, playerId, PropertyCanGoNext, convertToBool)
}

func (m mpris) CanGoPrevious(playerId string) (bool, bool) {
	return getProperty(m.dbus, playerId, PropertyCanGoPrevious, convertToBool)
}

func (m mpris) CanPause(playerId string) (bool, bool) {
	return getProperty(m.dbus, playerId, PropertyCanPause, convertToBool)
}

func (m mpris) CanPlay(playerId string) (bool, bool) {
	return getProperty(m.dbus, playerId, PropertyCanPlay, convertToBool)
}

func (m mpris) CanSeek(playerId string) (bool, bool) {
	return getProperty(m.dbus, playerId, PropertyCanSeek, convertToBool)
}

func (m mpris) LoopStatus(playerId string) (string, bool) {
	return getProperty(m.dbus, playerId, PropertyLoopStatus, convertToString)
}
func (m mpris) SetLoopStatus(playerId string, value string) {
	m.dbus.setProperty(playerId, MprisPath, PropertyLoopStatus, value)
}

func (m mpris) MaximumRate(playerId string) (float64, bool) {
	return getProperty(m.dbus, playerId, PropertyMaximumRate, convertToFloat64)
}

func (m mpris) Metadata(playerId string) (map[string]dbus.Variant, bool) {
	return getProperty(m.dbus, playerId, PropertyMetadata, func(value interface{}) (map[string]dbus.Variant, bool) {
		return value.(map[string]dbus.Variant), true
	})
}

func (m mpris) MinimumRate(playerId string) (float64, bool) {
	return getProperty(m.dbus, playerId, PropertyMinimumRate, convertToFloat64)
}

func (m mpris) PlaybackStatus(playerId string) (string, bool) {
	return getProperty(m.dbus, playerId, PropertyPlaybackStatus, convertToString)
}

func (m mpris) Rate(playerId string) (float64, bool) {
	return getProperty(m.dbus, playerId, PropertyRate, convertToFloat64)
}

func (m mpris) Shuffle(playerId string) (bool, bool) {
	return getProperty(m.dbus, playerId, PropertyShuffle, convertToBool)
}
func (m mpris) SetShuffle(playerId string, value bool) {
	m.dbus.setProperty(playerId, MprisPath, PropertyShuffle, value)
}

func (m mpris) Volume(playerId string) (float64, bool) {
	return getProperty(m.dbus, playerId, PropertyVolume, convertToFloat64)
}
