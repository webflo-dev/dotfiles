package cmd

import (
	"os"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "mprisctl",
	Short: "A command line tool to control MPRIS enabled media players",
}

func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

func WithRequiredPlayer(cmd *cobra.Command, target *string) {
	cmd.Flags().StringVarP(target, "player", "p", "", "name of the player")
	cmd.MarkFlagRequired("player")
}
