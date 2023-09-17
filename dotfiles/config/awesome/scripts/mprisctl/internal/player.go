package mprisctl

import "fmt"

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

type Converter func(value interface{}, source any) (interface{}, bool)

var fieldConfigs = map[string]Converter{
	FieldCanControl:     ConvertToBoolAny,
	FieldCanGoNext:      ConvertToBoolAny,
	FieldCanGoPrevious:  ConvertToBoolAny,
	FieldCanPause:       ConvertToBoolAny,
	FieldCanPlay:        ConvertToBoolAny,
	FieldCanSeek:        ConvertToBoolAny,
	FieldMaximumRate:    ConvertToFloat64Any,
	FieldMinimumRate:    ConvertToFloat64Any,
	FieldRate:           ConvertToFloat64Any,
	FieldVolume:         ConvertToFloat64Any,
	FieldLoopStatus:     ConvertLoopStatusAny,
	FieldPlaybackStatus: ConvertToStringAny,
	FieldShuffle:        ConvertToBoolAny,
	FieldPosition:       ConvertToUint64Any,
	FieldMetadata:       ConvertToMetadata,
}

var metadataConfigs = map[string]Converter{
	MetadataArtist:   ConvertToStringAny,
	MetadataTitle:    ConvertToStringAny,
	MetadataAlbum:    ConvertToStringAny,
	MetadataTrackId:  ConvertToStringAny,
	MetadataLength:   ConvertToUint64Any,
	MetadataUrl:      ConvertToStringAny,
	MetadataArtUrl:   ConvertToStringAny,
	MetadataDuration: ConvertToDurationAny,
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

	// for key, converter := range fieldConfigs {
	// 	value := values[key]
	//
	// 	if value == nil {
	// 		if existingValue, exists := p.Info[key]; exists {
	// 			if existingValue == nil {
	// 				p.Info[key], _ = converter(nil)
	// 			}
	// 		}
	// 	} else {
	// 		if convertedValue, converted := converter(value); converted {
	// 			p.Info[key] = convertedValue
	// 			if postUpdate != nil {
	// 				postUpdate(p, key)
	// 			}
	// 		}
	// 	}
	// }
}

// func assignMetadata(source map[string]interface{}, key string, value interface{}) bool {
// 	metadata, _ := ExtractMetadata(value)
// 	postMetadataExtraction(metadata)
// 	currentMetadata, hasMetadata := source[FieldMetadata]
// 	if hasMetadata == false || metadata[MetadataTrackId] != currentMetadata.(map[string]interface{})[MetadataTrackId] {
// 		source[FieldMetadata] = metadata
// 		return true
// 	}
// 	return false
// }

func ConvertLoopStatusAny(value interface{}, source any) (interface{}, bool) {
	if convertedValue, ok := ConvertToStringAny(value, source); ok {
		return convertedValue, true
	} else {
		return LoopStatusNone, true
	}
}

func ConvertToDurationAny(value interface{}, source any) (interface{}, bool) {
	metadata := source.(map[string]interface{})
	if length, ok := metadata[MetadataLength]; ok {
		lengthNum, _ := ConvertToUint64(length)
		duration, _, _, _ := ConvertToDuration(lengthNum)
		return duration, true
	} else {
		return "00:00", true
	}
}

func ConvertToMetadata(value interface{}, source any) (interface{}, bool) {
	player := source.(*Player)

	fmt.Println("ConvertToMetadata", value, source)

	if player.Info[FieldMetadata] == nil {
		metadata := make(map[string]interface{}, 10)
		player.Info[FieldMetadata] = metadata
		fmt.Println("no existing metadata => initialize new map")
		for key, converter := range metadataConfigs {
			metadata[key], _ = converter(nil, metadata)
		}
	}

	metadata := player.Info[FieldMetadata].(map[string]interface{})

	for key, newValue := range value.(map[string]interface{}) {
		fmt.Println("processing value => ", key, newValue)
		converter, supported := metadataConfigs[key]
		if supported == false {
			fmt.Println("unsupported key => ", key)
			continue
		}

		if newValue == nil {
			fmt.Println("nil value => ", key, newValue)
			metadata[key], _ = converter(nil, metadata)
			fmt.Println("converted value => ", metadata[key])
		} else {
			convertedValue, _ := converter(newValue, metadata)
			metadata[key] = convertedValue
			fmt.Println("converted value => ", metadata, convertedValue)
		}
	}
	return metadata, true
}

// func ExtractMetadata(source interface{}) (map[string]interface{}, bool) {
// 	metadata := make(map[string]interface{}, 10)
//
// 	_source := make(map[string]interface{}, 1)
// 	if source != nil {
// 		_source = source.(map[string]interface{})
// 	}
//
// 	for key, config := range metadataConfigs {
// 		convertedValue := _source[key]
// 		if config.convert != nil {
// 			_convertedValue, converted := config.convert(convertedValue)
// 			if converted == false {
// 				continue
// 			}
// 			convertedValue = _convertedValue
// 		}
// 		config.run(metadata, key, convertedValue)
// 	}
// 	return metadata, true
// }

func postMetadataExtraction(metadata map[string]interface{}) {
	if length, initialized := metadata[MetadataLength]; initialized {
		lengthNum, _ := ConvertToUint64(length)
		metadata[MetadataDuration], _, _, _ = ConvertToDuration(lengthNum)
	} else {
		metadata[MetadataDuration] = ""
	}
}
