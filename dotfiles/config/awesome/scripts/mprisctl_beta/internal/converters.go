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

func ConvertToString(value interface{}) string {
	if value == nil {
		return ""
	}
	switch value.(type) {
	case dbus.ObjectPath:
		return string(value.(dbus.ObjectPath))
	case string:
		return value.(string)
	case []string:
		return strings.Join(value.([]string), ",")
	default:
		return ""
	}
}

func ConvertToUint64(value interface{}) uint64 {
	switch value.(type) {
	case int64:
		return uint64(value.(int64))
	case uint64:
		return value.(uint64)
	default:
		return 0
	}
}
