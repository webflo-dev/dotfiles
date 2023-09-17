package mprisctl

type Player struct {
	Name  string
	Owner string
	Id    string
	Info  *PlayerInfo
}

type PlayerInfo struct {
	TrackInfo      *TrackInfo
	PlaybackStatus string
	// CanGoNext      bool
	// CanGoPrevious  bool
	// CanPlay        bool
	// CanPause       bool
	// CanControl     bool
	// CanSeek        bool
	Shuffle    bool
	LoopStatus string
}

type TrackInfo struct {
	Artist   string
	Title    string
	Album    string
	TrackId  string
	Length   uint64
	Duration string
	Url      string
	ArtUrl   string
}

const (
	PlaybackPlaying string = "Playing"
	PlaybackPaused         = "Paused"
	PlaybackStopped        = "Stopped"

	LoopSatusNone     string = "None"
	LoopSatusTrack           = "Track"
	LoopSatusPlaylist        = "Playlist"
)

const (
	InfoTypeNone Byte = 1 << iota
	InfoTypeMetadata
	InfoTypePlaybackStatus
	InfoTypeShuffle
	InfoTypeLoopStatus
)

func NewPlayer(name string, owner string, id string) *Player {
	return &Player{
		Name:  name,
		Owner: owner,
		Id:    id,
		Info:  &PlayerInfo{},
	}
}

func (p *Player) UpdateInfo(info map[string]interface{}) Byte {
	infoType := InfoTypeNone
	for key, value := range info {
		switch key {
		case "Metadata":
			metadata, isNil := ExtractMetadata(value)
			if isNil == true || p.Info.TrackInfo.TrackId != metadata.TrackId {
				p.Info.TrackInfo = metadata
				infoType.Set(InfoTypeMetadata)
			}
		case "PlaybackStatus":
			playbackStatus, isNil := ExtractString(value)
			if isNil == true || p.Info.PlaybackStatus != playbackStatus {
				p.Info.PlaybackStatus = playbackStatus
				infoType.Set(InfoTypePlaybackStatus)
			}
		case "Shuffle":
			shuffleStatus, isNil := ExtractBool(value)
			if isNil == true || p.Info.Shuffle != shuffleStatus {
				p.Info.Shuffle = shuffleStatus
				infoType.Set(InfoTypePlaybackStatus)
			}
		case "LoopStatus":
			loopStatus, isNil := ExtractString(value)
			p.Info.LoopStatus = loopStatus
			if isNil == true || p.Info.LoopStatus != loopStatus {
				infoType.Set(InfoTypeLoopStatus)
			}
		}
	}
	return infoType
}

func ExtractMetadata(source interface{}) (*TrackInfo, bool) {
	_metadata := &TrackInfo{}

	if source == nil {
		return _metadata, false
	}
	metadata := source.(map[string]interface{})

	_metadata.Artist = ConvertToString(metadata["xesam:artist"])
	_metadata.Title = ConvertToString(metadata["xesam:title"])
	_metadata.Album = ConvertToString(metadata["xesam:album"])
	_metadata.TrackId = ConvertToString(metadata["mpris:trackid"])
	_metadata.Length = ConvertToUint64(metadata["mpris:length"])
	_metadata.Url = ConvertToString(metadata["xesam:url"])
	_metadata.ArtUrl = ConvertToString(metadata["mpris:artUrl"])
	_metadata.Duration, _, _, _ = ConvertToDuration(_metadata.Length)

	return _metadata, true
}

func ExtractString(source interface{}) (string, bool) {
	if source == nil {
		return "", false
	}
	return source.(string), true
}

func ExtractBool(source interface{}) (bool, bool) {
	if source == nil {
		return false, false
	}
	return source.(bool), true
}

func ExtractInt(source interface{}) (int64, bool) {
	if source == nil {
		return 0, false
	}
	return source.(int64), true
}
