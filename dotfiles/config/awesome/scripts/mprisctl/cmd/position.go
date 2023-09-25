package cmd

import (
	"fmt"
	mprisctl "mprisctl/internal"

	"github.com/spf13/cobra"
)

func init() {
	var playerName string
	var setValue int64
	var setFlagName = "set"

	var cmd = &cobra.Command{
		Use:   "position",
		Short: "Get or set position",
		Args:  cobra.NoArgs,
		Run: func(cmd *cobra.Command, args []string) {
			if cmd.Flags().Changed(setFlagName) {
				setPosition(playerName, setValue)
			} else {
				printPosition(playerName)
			}
		},
	}

	WithRequiredPlayer(cmd, &playerName)
	cmd.Flags().Int64Var(&setValue, setFlagName, 0, "set position")

	rootCmd.AddCommand(cmd)
}

func printPosition(player string) {
	mpris := mprisctl.NewMpris()
	if position, ok := mpris.Position(mprisctl.GetPlayerId(player)); ok {
		fmt.Println(position)
	}
}

func setPosition(playerName string, value int64) {
	mpris := mprisctl.NewMpris()
	mpris.SetPosition(mprisctl.GetPlayerId(playerName), value)
}
