package mprisctl

type Player struct {
	Name  string
	Owner string
	Id    string
	Info  map[string]interface{}
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
	MetadataArtist   = "xesam:artist"
	MetadataTitle    = "xesam:title"
	MetadataAlbum    = "xesam:album"
	MetadataTrackId  = "mpris:trackid"
	MetadataLength   = "mpris:length"
	MetadataDuration = "custom:duration"
	MetadataUrl      = "xesam:url"
	MetadataArtUrl   = "mpris:artUrl"
)

const (
	PlaybackPlaying = "Playing"
	PlaybackPaused  = "Paused"
	PlaybackStopped = "Stopped"

	LoopStatusNone     = "None"
	LoopStatusTrack    = "Track"
	LoopStatusPlaylist = "Playlist"
)

// type FieldConfig struct {
// 	run     func(source map[string]interface{}, key string, value interface{}) bool
// 	convert func(value interface{}) (interface{}, bool)
// }

var fieldConfigs = map[string]{
	FieldCanControl:     {run: assignValue, convert: ConvertToBoolAny},
	FieldCanGoNext:      {run: assignValue, convert: ConvertToBoolAny},
	FieldCanGoPrevious:  {run: assignValue, convert: ConvertToBoolAny},
	FieldCanPause:       {run: assignValue, convert: ConvertToBoolAny},
	FieldCanPlay:        {run: assignValue, convert: ConvertToBoolAny},
	FieldCanSeek:        {run: assignValue, convert: ConvertToBoolAny},
	FieldMaximumRate:    {run: assignValue, convert: nil},
	FieldMinimumRate:    {run: assignValue, convert: nil},
	FieldRate:           {run: assignValue, convert: nil},
	FieldVolume:         {run: assignValue, convert: nil},
	FieldLoopStatus:     {run: assignValue, convert: ConvertLoopStatusAny},
	FieldPlaybackStatus: {run: assignValue, convert: ConvertToStringAny},
	FieldShuffle:        {run: assignValue, convert: ConvertToBoolAny},
	FieldPosition:       {run: assignValue, convert: ConvertToUint64Any},
	FieldMetadata:       {run: assignMetadata, convert: nil},
}

var metadataConfigs = map[string]FieldConfig{
	MetadataArtist:  {run: assignValue, convert: ConvertToStringAny},
	MetadataTitle:   {run: assignValue, convert: ConvertToStringAny},
	MetadataAlbum:   {run: assignValue, convert: ConvertToStringAny},
	MetadataTrackId: {run: assignValue, convert: ConvertToStringAny},
	MetadataLength:  {run: assignValue, convert: ConvertToUint64Any},
	MetadataUrl:     {run: assignValue, convert: ConvertToStringAny},
	MetadataArtUrl:  {run: assignValue, convert: ConvertToStringAny},
}

func NewPlayer(name string, owner string, id string) *Player {
	return &Player{
		Name:  name,
		Owner: owner,
		Id:    id,
		Info:  make(map[string]interface{}, 20),
	}
}

func (p *Player) UpdateInfo(values map[string]interface{}, postUpdate func(p *Player, updateKey string)) {
	for key, config := range fieldConfigs {
		convertedValue := values[key]

		if value == nil {

		}

		if config.convert != nil {
			_convertedValue, converted := config.convert(convertedValue)
			if converted == false {
				continue
			}
			convertedValue = _convertedValue
		}

		if config.run(p.Info, key, convertedValue) && postUpdate != nil {
			postUpdate(p, key)
		}
	}
}

func assignValue(source map[string]interface{}, key string, value interface{}) bool {
	if /*value == nil ||*/ source[key] != value {
		source[key] = value
		return true
	}
	return false
}

func assignMetadata(source map[string]interface{}, key string, value interface{}) bool {
	metadata, _ := ExtractMetadata(value)
	postMetadataExtraction(metadata)
	currentMetadata, hasMetadata := source[FieldMetadata]
	if hasMetadata == false || metadata[MetadataTrackId] != currentMetadata.(map[string]interface{})[MetadataTrackId] {
		source[FieldMetadata] = metadata
		return true
	}
	return false
}

func ConvertLoopStatusAny(value interface{}) (interface{}, bool) {
	if convertedValue, ok := ConvertToStringAny(value); ok {
		return convertedValue, true
	} else {
		return LoopStatusNone, true
	}
}

func ExtractMetadata(source interface{}) (map[string]interface{}, bool) {
	metadata := make(map[string]interface{}, 10)

	_source := make(map[string]interface{}, 1)
	if source != nil {
		_source = source.(map[string]interface{})
	}

	for key, config := range metadataConfigs {
		convertedValue := _source[key]
		if config.convert != nil {
			_convertedValue, converted := config.convert(convertedValue)
			if converted == false {
				continue
			}
			convertedValue = _convertedValue
		}
		config.run(metadata, key, convertedValue)
	}
	return metadata, true
}

func postMetadataExtraction(metadata map[string]interface{}) {
	if length, initialized := metadata[MetadataLength]; initialized {
		lengthNum, _ := ConvertToUint64(length)
		metadata[MetadataDuration], _, _, _ = ConvertToDuration(lengthNum)
	} else {
		metadata[MetadataDuration] = ""
	}
}
