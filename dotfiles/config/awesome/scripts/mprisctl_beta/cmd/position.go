package main

import (
	"fmt"
	mprisctl "mprisctl/internal"
	"strconv"

	godbus "github.com/godbus/dbus/v5"
)

func Position(player string, args []string) {
	switch len(args) {
	case 0:
		dbus := mprisctl.NewDBus()
		variant, err := dbus.GetProperty(mprisctl.MprisPlayerIdentifier+player, mprisctl.MprisPath, mprisctl.PropertyPosition)
		if err == nil {
			fmt.Println(variant.Value())
			return
		}
		return
	case 1:
		position, err := strconv.ParseInt(args[0], 10, 64)
		if err == nil {
			dest := mprisctl.MprisPlayerIdentifier + player

			dbus := mprisctl.NewDBus()

			var values map[string]interface{}
			dbus.CallMethod(dbus.Connection.Object(dest, mprisctl.MprisPath), mprisctl.MethodGetAll, mprisctl.MprisInterface).Store(&values)

			trackInfo, ok := mprisctl.ExtractMetadata(values["Metadata"])
			if ok {
				busObj := dbus.Connection.Object(mprisctl.MprisPlayerIdentifier+player, mprisctl.MprisPath)
				dbus.CallMethod(busObj, mprisctl.MethodSetPosition, godbus.ObjectPath(trackInfo.TrackId), position)
			}
		}
	}
}
