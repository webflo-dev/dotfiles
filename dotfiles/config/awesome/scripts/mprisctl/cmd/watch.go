package cmd

import (
	mprisctl "mprisctl/internal"

	"github.com/spf13/cobra"
)

func init() {
	var watchCmd = &cobra.Command{
		Use:   "watch",
		Short: "Watch for changes",
		Args:  cobra.NoArgs,
		Run: func(cmd *cobra.Command, args []string) {
			mprisctl.Watch()
		},
	}

	rootCmd.AddCommand(watchCmd)
}
