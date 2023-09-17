package mprisctl

import (
	"fmt"
	"strings"

	"github.com/godbus/dbus/v5"
)

func ConvertToDuration(position uint64) (string, uint64, uint64, uint64) {
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
		return "", true
	}
}
func ConvertToStringAny(value interface{}, source any) (interface{}, bool) {
	return ConvertToString(value)
}

func ConvertToUint64(value interface{}) (uint64, bool) {
	if value == nil {
		return 0, false
	}

	switch value.(type) {
	case int64:
		return uint64(value.(int64)), true
	case uint64:
		return value.(uint64), true
	default:
		return 0, true
	}
}

func ConvertToUint64Any(value interface{}, source any) (interface{}, bool) {
	return ConvertToUint64(value)
}

func ConvertToBool(value interface{}) (bool, bool) {
	if value == nil {
		return false, false
	}
	switch value.(type) {
	case bool:
		return value.(bool), true
	default:
		return false, true
	}
}
func ConvertToBoolAny(value interface{}, source any) (interface{}, bool) {
	return ConvertToBool(value)
}

func ConvertToFloat64(value interface{}) (float64, bool) {
	if value == nil {
		return 0, false
	}

	switch value.(type) {
	case float64:
		return value.(float64), true
	default:
		return 0, true
	}
}
func ConvertToFloat64Any(value interface{}, source any) (interface{}, bool) {
	return ConvertToFloat64(value)
}
