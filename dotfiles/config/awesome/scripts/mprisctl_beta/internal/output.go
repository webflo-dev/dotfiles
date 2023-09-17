package mprisctl

import (
	"fmt"
)

func PrintTrackInfo(player Player) {
	fmt.Println(fmt.Sprintf("METADATA::%s artist=\"%s\" title=\"%s\" album=\"%s\" track_id=\"%s\" length=%d duration=%s url=%s art_url=%s",
		player.Name,
		player.Info.TrackInfo.Artist,
		player.Info.TrackInfo.Title,
		player.Info.TrackInfo.Album,
		player.Info.TrackInfo.TrackId,
		player.Info.TrackInfo.Length,
		player.Info.TrackInfo.Duration,
		player.Info.TrackInfo.Url,
		player.Info.TrackInfo.ArtUrl,
	))
}

func PrintPlaybackStatus(player Player) {
	fmt.Println(fmt.Sprintf("PLAYBACK_STATUS::%s %s", player.Name, player.Info.PlaybackStatus))
}

func PrintPosition(position uint64, playerName string, remaining_raw uint64) {
	elapsed, _, _, _ := ConvertToDuration(position)
	remaining, _, _, _ := ConvertToDuration(remaining_raw)
	fmt.Println(fmt.Sprintf("POSITION::%s elapsed=%s elasped_raw=%d remaining=%s remaining_raw=%d", playerName, elapsed, position, remaining, remaining_raw))
}

func PrintConnectionStatus(player Player, connected bool) {
	var status string
	if connected {
		status = "connected"
	} else {
		status = "disconnected"
	}
	fmt.Println(fmt.Sprintf("PLAYER::%s player_name=%s", status, player.Name))
}

func PrintShuffleStatus(player Player) {
	fmt.Println(fmt.Sprintf("SHUFFLE::%s %t", player.Name, player.Info.Shuffle))
}

func PrintLoopStatus(player Player) {
	fmt.Println(fmt.Sprintf("LOOP::%s %s", player.Name, player.Info.LoopStatus))
}
