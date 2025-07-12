package main

import (
	"os"

	ulemulem_command "github.com/fikrirnurhidayat/ulemulem/internal/infra/command"
	"github.com/spf13/cobra"
)

var ulemulemCmd = &cobra.Command{
	Use:   "ulemulem",
	Short: "Invitation",
	Long:  "Invitation",
	Run: func(cmd *cobra.Command, args []string) {
		cmd.Help()
	},
}

func main() {
	err := ulemulemCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

func init() {
	ulemulemCmd.AddCommand(ulemulem_command.ServeCmd)
}
