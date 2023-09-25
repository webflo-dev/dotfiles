package cmd

import (
	"errors"
	"fmt"
	mprisctl "mprisctl/internal"

	"github.com/spf13/cobra"
)

func init() {
	var loopStatusValue LoopStatus
	var playerName string
	var setFlagName = "set"

	var cmd = &cobra.Command{
		Use:   "loop",
		Short: "Get or set loop status",
		Run: func(cmd *cobra.Command, args []string) {
			if cmd.Flags().Changed(setFlagName) {
				SetLoopStatus(playerName, string(loopStatusValue))
			} else {
				printLoopStatus(playerName)
			}
		},
	}

	WithRequiredPlayer(cmd, &playerName)
	cmd.Flags().Var(&loopStatusValue, setFlagName, "set loop status")
	cmd.RegisterFlagCompletionFunc(setFlagName, loopStatusCompletion)

	rootCmd.AddCommand(cmd)
}

func printLoopStatus(playerName string) {
	mpris := mprisctl.NewMpris()
	if loopStatus, ok := mpris.LoopStatus(mprisctl.GetPlayerId(playerName)); ok {
		fmt.Println(loopStatus)
	}
}

func SetLoopStatus(playerName string, status string) {
	mpris := mprisctl.NewMpris()
	mpris.SetLoopStatus(mprisctl.GetPlayerId(playerName), status)
}

type LoopStatus string

// String is used both by fmt.Print and by Cobra in help text
func (l *LoopStatus) String() string {
	return string(*l)
}

// Set must have pointer receiver so it doesn't change the value of a copy
func (e *LoopStatus) Set(v string) error {
	switch v {
	case string(mprisctl.LoopStatusNone), string(mprisctl.LoopStatusPlaylist), string(mprisctl.LoopStatusTrack):
		*e = LoopStatus(v)
		return nil
	default:
		return errors.New(fmt.Sprintf(`must be one of "%s", "%s", or "%s"`, mprisctl.LoopStatusNone, mprisctl.LoopStatusPlaylist, mprisctl.LoopStatusTrack))
	}
}

// Type is only used in help text
func (e *LoopStatus) Type() string {
	return "LoopStatus"
}

func loopStatusCompletion(cmd *cobra.Command, args []string, toComplete string) ([]string, cobra.ShellCompDirective) {
	return []string{
		mprisctl.LoopStatusNone,
		mprisctl.LoopStatusPlaylist,
		mprisctl.LoopStatusTrack,
	}, cobra.ShellCompDirectiveDefault
}
