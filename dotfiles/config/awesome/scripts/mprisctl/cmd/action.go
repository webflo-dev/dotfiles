package cmd

import (
	"mprisctl/internal"

	"github.com/spf13/cobra"
)

func init() {

	ActionCmd("play", "Play", mprisctl.NewMpris().Play)
	ActionCmd("pause", "Pause", mprisctl.NewMpris().Pause)
	ActionCmd("play-pause", "Toggle play/pause", mprisctl.NewMpris().PlayPause)
	ActionCmd("stop", "Stop", mprisctl.NewMpris().Stop)
	ActionCmd("next", "Next track", mprisctl.NewMpris().Next)
	ActionCmd("previous", "Previous track", mprisctl.NewMpris().Previous)
}

func ActionCmd(name string, short string, callback func(string)) {
	var playerName string

	var cmd = &cobra.Command{
		Use:   name,
		Short: short,
		Args:  cobra.NoArgs,
		Run: func(cmd *cobra.Command, args []string) {
			callback(mprisctl.GetPlayerId(playerName))
		},
	}

	WithRequiredPlayer(cmd, &playerName)
	rootCmd.AddCommand(cmd)
}
