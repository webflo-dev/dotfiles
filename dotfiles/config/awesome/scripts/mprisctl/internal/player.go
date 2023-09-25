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
)

const (
	LoopStatusNone     = "None"
	LoopStatusTrack    = "Track"
	LoopStatusPlaylist = "Playlist"
)

type converter func(value interface{}, source any) (interface{}, bool)

var fieldConfigs = map[string]converter{
	FieldCanControl:     convertToBoolAny,
	FieldCanGoNext:      convertToBoolAny,
	FieldCanGoPrevious:  convertToBoolAny,
	FieldCanPause:       convertToBoolAny,
	FieldCanPlay:        convertToBoolAny,
	FieldCanSeek:        convertToBoolAny,
	FieldMaximumRate:    convertToFloat64Any,
	FieldMinimumRate:    convertToFloat64Any,
	FieldRate:           convertToFloat64Any,
	FieldVolume:         convertToFloat64Any,
	FieldLoopStatus:     convertLoopStatusAny,
	FieldPlaybackStatus: convertToStringAny,
	FieldShuffle:        convertToBoolAny,
	FieldPosition:       convertToUint64Any,
	FieldMetadata:       convertToMetadata,
}

var metadataConfigs = map[string]converter{
	MetadataArtist:  convertToStringAny,
	MetadataTitle:   convertToStringAny,
	MetadataAlbum:   convertToStringAny,
	MetadataTrackId: convertToStringAny,
	MetadataLength:  convertToUint64Any,
	MetadataUrl:     convertToStringAny,
	MetadataArtUrl:  convertToStringAny,
}

func newPlayer(name string, owner string, id string) *Player {
	player := &Player{
		Name:  name,
		Owner: owner,
		Id:    id,
	}

	player.Info = make(map[string]interface{}, 20)
	for key, converter := range fieldConfigs {
		player.Info[key], _ = converter(nil, player)
	}

	metadata := player.Info[FieldMetadata].(map[string]interface{})
	for key, converter := range metadataConfigs {
		metadata[key], _ = converter(nil, metadata)
	}

	return player
}

func getMetadataValueFromRawValues(values interface{}, key string) interface{} {
	metadata := values.(map[string]interface{})[FieldMetadata].(map[string]interface{})
	return metadata[key]
}

func (p *Player) updateProperties(values map[string]interface{}, postUpdate func(p *Player, updateKey string)) {
	for key, value := range values {
		converter, supported := fieldConfigs[key]
		if supported == false {
			continue
		}

		if value == nil {
			p.Info[key], _ = converter(nil, p)
		} else {
			if convertedValue, converted := converter(value, p); converted {
				p.Info[key] = convertedValue
				if postUpdate != nil {
					postUpdate(p, key)
				}
			}
		}
	}
}

func convertLoopStatusAny(value interface{}, source any) (interface{}, bool) {
	if convertedValue, ok := convertToStringAny(value, source); ok {
		return convertedValue, true
	} else {
		return LoopStatusNone, true
	}
}

func convertToDurationAny(value interface{}, source any) (interface{}, bool) {
	metadata := source.(map[string]interface{})
	if length, ok := metadata[MetadataLength]; ok {
		lengthNum, _ := convertToUint64(length)
		duration, _, _, _ := convertToDuration(lengthNum)
		return duration, true
	} else {
		return "--:--", true
	}
}

func convertToMetadata(value interface{}, source any) (interface{}, bool) {
	var metadata map[string]interface{}
	if value == nil {
		metadata = make(map[string]interface{}, 10)
	} else {
		player := source.(*Player)
		metadata = player.Info[FieldMetadata].(map[string]interface{})

		for key, newValue := range value.(map[string]interface{}) {
			converter, supported := metadataConfigs[key]
			if supported == false {
				continue
			}

			if newValue == nil {
				metadata[key], _ = converter(nil, metadata)
			} else {
				convertedValue, _ := converter(newValue, metadata)
				metadata[key] = convertedValue
			}
		}
	}

	postMetadataExtraction(metadata)
	return metadata, true
}

func postMetadataExtraction(metadata map[string]interface{}) {
	if length, initialized := metadata[MetadataLength]; initialized {
		lengthNum, _ := length.(uint64)
		metadata[MetadataDuration], _, _, _ = convertToDuration(lengthNum)
	} else {
		metadata[MetadataDuration] = ""
	}
}
