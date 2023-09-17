package mprisctl

type Player struct {
	Name  string
	Owner string
	Id    string
	Info  *PlayerInfo
}

type PlayerInfo struct {
	CanControl     bool
	CanGoNext      bool
	CanGoPrevious  bool
	CanPause       bool
	CanPlay        bool
	CanSeek        bool
	LoopStatus     string
	MaximumRate    float64
	Metadata       *Metadata
	MinimumRate    float64
	PlaybackStatus string
	Position       uint64
	Rate           float64
	Shuffle        bool
	Volume         float64
}

type Metadata struct {
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
	FieldCanControl     = "CanControl"
	FieldCanGoNext      = "CanGoNext"
	FieldCanGoPrevious  = "CanGoPrevious"
	FieldCanPause       = "CanPause"
	FieldCanPlay        = "CanPlay"
	FieldCanSeek        = "CanSeek"
	FieldLoopStatus     = "LoopStatus"
	FieldMaximumRate    = "MaximumRate"
	FieldMetadata       = "Metadata"
	FieldMinimumRate    = "MinimumRate"
	FieldPlaybackStatus = "PlaybackStatus"
	FieldPosition       = "Position"
	FieldRate           = "Rate"
	FieldShuffle        = "Shuffle"
	FieldVolume         = "Volume"
)

const (
	PlaybackPlaying = "Playing"
	PlaybackPaused  = "Paused"
	PlaybackStopped = "Stopped"

	LoopSatusNone     = "None"
	LoopSatusTrack    = "Track"
	LoopSatusPlaylist = "Playlist"
)

type Setter func(player *Player, value interface{}) bool

var fielSsetters = map[string]Setter{
	FieldLoopStatus:     loopStatus,
	FieldMetadata:       metadata,
	FieldPlaybackStatus: playbackStatus,
	FieldPosition:       position,
	FieldShuffle:        shuffle,
}

func metadata(p *Player, value interface{}) bool {
	metadata, isNil := ExtractMetadata(value)
	if isNil == true || p.Info.Metadata.TrackId != metadata.TrackId {
		p.Info.Metadata = metadata
		return true
	}
	return false
}

func playbackStatus(p *Player, value interface{}) bool {
	playbackStatus, isNil := ExtractValue[string](value)
	if isNil == true || p.Info.PlaybackStatus != playbackStatus {
		p.Info.PlaybackStatus = playbackStatus
		return true
	}
	return false
}

func shuffle(p *Player, value interface{}) bool {
	shuffleStatus, isNil := ExtractValue[bool](value)
	if isNil == true || p.Info.Shuffle != shuffleStatus {
		p.Info.Shuffle = shuffleStatus
		return true
	}
	return false
}

func loopStatus(p *Player, value interface{}) bool {
	loopStatus, isNil := ExtractValue[string](value)
	if isNil == true || p.Info.LoopStatus != loopStatus {
		p.Info.LoopStatus = loopStatus
		return true
	}
	return false
}

func position(p *Player, value interface{}) bool {
	position, ok := ConvertToUint64(value)
	if ok == false || p.Info.Position != position {
		p.Info.Position = position
		return true
	}
	return false
}

func NewPlayer(name string, owner string, id string) *Player {
	return &Player{
		Name:  name,
		Owner: owner,
		Id:    id,
		Info:  &PlayerInfo{},
	}
}

func (p *Player) UpdateInfo(info map[string]interface{}, postUpdate func(p Player, updateKey string)) {
	for key, value := range info {
		setter, supported := fielSsetters[key]
		if supported == false {
			continue
		}
		if setter(p, value) && postUpdate != nil {
			postUpdate(*p, key)
		}
	}
}

func ExtractMetadata(source interface{}) (*Metadata, bool) {
	_metadata := &Metadata{}

	if source == nil {
		return _metadata, false
	}
	metadata := source.(map[string]interface{})

	_metadata.Artist, _ = ConvertToString(metadata["xesam:artist"])
	_metadata.Title, _ = ConvertToString(metadata["xesam:title"])
	_metadata.Album, _ = ConvertToString(metadata["xesam:album"])
	_metadata.TrackId, _ = ConvertToString(metadata["mpris:trackid"])
	_metadata.Length, _ = ConvertToUint64(metadata["mpris:length"])
	_metadata.Url, _ = ConvertToString(metadata["xesam:url"])
	_metadata.ArtUrl, _ = ConvertToString(metadata["mpris:artUrl"])
	_metadata.Duration, _, _, _ = ConvertToDuration(_metadata.Length)

	return _metadata, true
}

func ExtractValue[T any](source interface{}) (T, bool) {
	if source == nil {
		return Zero[T](), false
	}
	return source.(T), true
}
