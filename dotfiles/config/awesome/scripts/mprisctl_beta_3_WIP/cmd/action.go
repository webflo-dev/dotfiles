package main

import (
	"mprisctl/internal"
)

func Action(name string) func(string, []string) {
	mpris := mprisctl.NewMpris()

	mapping := map[string]func(string){
		"play":       mpris.Play,
		"pause":      mpris.Pause,
		"play-pause": mpris.PlayPause,
		"stop":       mpris.Stop,
		"next":       mpris.Next,
		"previous":   mpris.Previous,
	}

	action := mapping[name]
	return func(player string, args []string) {
		action(mpris.GetPlayerId(player))
	}
}
