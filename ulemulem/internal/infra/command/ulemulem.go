package ulemulem_command

import (
	"fmt"

	"github.com/fikrirnurhidayat/ulemulem/internal/infra/config"
	http_server "github.com/fikrirnurhidayat/ulemulem/internal/infra/http/server"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var ServeCmd = &cobra.Command{
	Use:   "serve",
	Short: "Run ulemulem server.",
	Long:  `Run ulemulem server.`,
	Run: func(cmd *cobra.Command, args []string) {
		config.Init()

		srv, err := http_server.New()
		if err != nil {
			panic(err.Error())
		}

		if err := srv.Echo.Start(fmt.Sprintf(":%s", viper.GetString("server.port"))); err != nil {
			panic(err.Error())
		}
	},
}
