package mprisctl

import (
	"fmt"
	"strings"

	"github.com/godbus/dbus/v5"
)

func ConvertToDuration[T uint64 | int64](position T) (string, T, T, T) {
	ts := position / 1000000
	seconds := ts % 60
	minutes := (ts / 60) % 60
	hours := ts / 60 / 60

	if hours != 0 {
		return fmt.Sprintf("%02d:%02d:%02d", hours, minutes, seconds), hours, minutes, seconds
	} else {
		return fmt.Sprintf("%02d:%02d", minutes, seconds), hours, minutes, seconds
	}
}

func ConvertToString(value interface{}) (string, bool) {
	if value == nil {
		return "", false
	}
	switch value.(type) {
	case dbus.ObjectPath:
		return string(value.(dbus.ObjectPath)), true
	case string:
		return value.(string), true
	case []string:
		return strings.Join(value.([]string), ","), true
	default:
		return "", false
	}
}

func ConvertToUint64(value interface{}) (uint64, bool) {
	switch value.(type) {
	case int64:
		return uint64(value.(int64)), true
	case uint64:
		return value.(uint64), true
	default:
		return 0, false
	}
}

func ConvertToBool(value interface{}) (bool, bool) {
	switch value.(type) {
	case bool:
		return value.(bool), true
	default:
		return false, false
	}
}

func ConvertToFloat64(value interface{}) (float64, bool) {
	switch value.(type) {
	case float64:
		return value.(float64), true
	default:
		return 0, false
	}
}
