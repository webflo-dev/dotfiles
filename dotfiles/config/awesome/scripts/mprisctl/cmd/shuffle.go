package main

import (
	"fmt"
	mprisctl "mprisctl/internal"
	"strconv"
)

func Shuffle(player string, args []string) {
	switch len(args) {
	case 0:
		mpris := mprisctl.NewMpris()
		if value, ok := mpris.Shuffle(mpris.GetPlayerId(player)); ok {
			fmt.Println(value)
		} else {
			fmt.Println("Error: Shuffle")
		}
		return
	case 1:
		shuffle, err := strconv.ParseBool(args[0])
		if err != nil {
			fmt.Println("Usage: mpris shuffle [true|false|0|1]")
			return
		}
		mpris := mprisctl.NewMpris()
		mpris.SetShuffle(mpris.GetPlayerId(player), shuffle)
	default:
		fmt.Println("Usage: mpris shuffle [true|false|0|1]")
	}
}
