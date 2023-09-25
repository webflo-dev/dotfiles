package cmd

import (
	"fmt"
	mprisctl "mprisctl/internal"

	"github.com/spf13/cobra"
)

func init() {
	var playerName string
	var setValue bool
	var setFlagName = "set"

	var cmd = &cobra.Command{
		Use:   "shuffle",
		Short: "Get or set shuffle",
		Args:  cobra.NoArgs,
		Run: func(cmd *cobra.Command, args []string) {
			if cmd.Flags().Changed(setFlagName) {
				setShuffle(playerName, setValue)
			} else {
				printShuffle(playerName)
			}
		},
	}

	WithRequiredPlayer(cmd, &playerName)
	cmd.Flags().BoolVar(&setValue, setFlagName, false, "set shuffle on or off")

	rootCmd.AddCommand(cmd)
}

func printShuffle(playerName string) {
	mpris := mprisctl.NewMpris()
	if value, ok := mpris.Shuffle(mprisctl.GetPlayerId(playerName)); ok {
		fmt.Println(value)
	}
}

func setShuffle(playerName string, value bool) {
	mpris := mprisctl.NewMpris()
	mpris.SetShuffle(mprisctl.GetPlayerId(playerName), value)
}
