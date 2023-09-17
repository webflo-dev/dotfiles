package main

import (
	"fmt"
	mprisctl "mprisctl/internal"
	"strconv"
)

func Shuffle(player string, args []string) {
	if len(args) != 1 {
		fmt.Println("Usage: mpris shuffle [true|false|0|1]")
		return
	}
	shuffle, err := strconv.ParseBool(args[0])
	if err != nil {
		fmt.Println("Usage: mpris shuffle [true|false|0|1]")
		return
	}

	dbus := mprisctl.NewDBus()
	dbus.SetProperty(mprisctl.MprisPlayerIdentifier+player, mprisctl.MprisPath, mprisctl.PropertyShuffle, shuffle)
}
