package main

import (
	"fmt"
	mprisctl "mprisctl/internal"
	"strconv"
)

func Position(player string, args []string) {
	switch len(args) {
	case 0:
		mpris := mprisctl.NewMpris()
		if position, ok := mpris.Position(mpris.GetPlayerId(player)); ok {
			fmt.Println(position)
		}
	case 1:
		position, err := strconv.ParseInt(args[0], 10, 64)
		if err == nil {
			mpris := mprisctl.NewMpris()
			mpris.SetPosition(mpris.GetPlayerId(player), position)
		}
	}
}
