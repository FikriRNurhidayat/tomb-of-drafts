package config

import (
	"strings"

	"github.com/spf13/viper"
)

func Init() {
	viper.SetEnvPrefix("ULEMULEM")
	viper.SetConfigName("config")
	viper.SetConfigType("yaml")
	viper.AddConfigPath("$HOME/.config/ulemulem/")
	viper.AutomaticEnv()
	viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))
	viper.ReadInConfig()
}
