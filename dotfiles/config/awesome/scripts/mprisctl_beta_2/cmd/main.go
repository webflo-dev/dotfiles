package main

import (
	"flag"
	"fmt"
	"os"
)

var commands = map[string]func(string, []string){
	"watch":      watch,
	"play":       Action("play"),
	"pause":      Action("pause"),
	"play-pause": Action("play-pause"),
	"stop":       Action("stop"),
	"next":       Action("next"),
	"previous":   Action("previous"),
	"shuffle":    Shuffle,
	"loop":       Loop,
	"position":   Position,
}

func main() {
	player := flag.String("player", "", "name of player")
	flag.StringVar(player, "p", "", "name of player")

	flag.Parse()

	subcommand := flag.Args()

	if len(subcommand) == 0 {
		printUsage()
		os.Exit(1)
	}

	cmd, ok := commands[subcommand[0]]
	if !ok {
		printUsage()
		os.Exit(1)
	}

	// cmd(*player, subcommand)
	cmd(*player, subcommand[1:])

}

func printUsage() {
	fmt.Print("Usage: mpris [global options] [command] [options]\n\n")
	fmt.Println("Available commands:")
	s := ""
	for k := range commands {
		s += " - " + k + "\n"
	}
	fmt.Println(s)
	fmt.Println("Global options:")
	flag.PrintDefaults()
}
