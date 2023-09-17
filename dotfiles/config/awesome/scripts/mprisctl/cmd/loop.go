package main

import (
	"fmt"
	mprisctl "mprisctl/internal"
	"strings"
)

func Loop(player string, args []string) {
	if len(args) != 1 {
		fmt.Println("Usage: mpris loop [none|track|playlist]")
		return
	}

	statuses := map[string]string{
		"none":     "None",
		"track":    "Track",
		"playlist": "Playlist",
	}

	status, found := statuses[strings.ToLower(args[0])]
	if found == false {
		fmt.Println("Usage: mpris loop [none|track|playlist]")
		return
	}

	mpris := mprisctl.NewMpris()
	mpris.SetLoopStatus(mpris.GetPlayerId(player), status)
}
