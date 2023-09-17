package main

import (
	"mprisctl/internal"
)

func Action(name string) func(string, []string) {
	return func(player string, args []string) {
		callAction(player, name)
	}
}

func callAction(player string, action string, actionArgs ...interface{}) {
	dbus := mprisctl.NewDBus()

	busObj := dbus.Connection.Object(mprisctl.MprisPlayerIdentifier+player, mprisctl.MprisPath)
	dbus.CallMethod(busObj, action, actionArgs...)
}
