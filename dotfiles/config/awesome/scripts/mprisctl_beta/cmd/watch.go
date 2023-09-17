package main

import mprisctl "mprisctl/internal"

func watch(player string, args []string) {
	mprisctl.Watch(player)
}
