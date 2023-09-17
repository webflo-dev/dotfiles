package mprisctl

import (
	"fmt"
)

func PrintMetadata(player *Player) {
	metadata := player.Info[FieldMetadata].(map[string]interface{})
	fmt.Println(fmt.Sprintf("METADATA::%s owner=\"%s\" artist=\"%s\" title=\"%s\" album=\"%s\" track_id=\"%s\" length=%d duration=%s url=%s art_url=%s",
		player.Name,
		player.Owner,
		metadata[MetadataArtist],
		metadata[MetadataTitle],
		metadata[MetadataAlbum],
		metadata[MetadataTrackId],
		metadata[MetadataLength],
		metadata[MetadataDuration],
		metadata[MetadataUrl],
		metadata[MetadataArtUrl],
	))
}

func PrintPlaybackStatus(player *Player) {
	fmt.Println(fmt.Sprintf("PLAYBACK_STATUS::%s %s", player.Name, player.Info[FieldPlaybackStatus]))
}

func PrintPosition(position uint64, playerName string, remaining_raw uint64) {
	elapsed, _, _, _ := ConvertToDuration(position)
	remaining, _, _, _ := ConvertToDuration(remaining_raw)
	fmt.Println(fmt.Sprintf("POSITION::%s elapsed=%s elasped_raw=%d remaining=%s remaining_raw=%d", playerName, elapsed, position, remaining, remaining_raw))
}

func PrintConnectionStatus(player *Player, connected bool) {
	var status string
	if connected {
		status = "connected"
	} else {
		status = "disconnected"
	}
	fmt.Println(fmt.Sprintf("PLAYER::%s player_name=%s", status, player.Name))
}

func PrintShuffleStatus(player *Player) {
	fmt.Println(fmt.Sprintf("SHUFFLE::%s %t", player.Name, player.Info[FieldShuffle]))
}

func PrintLoopStatus(player *Player) {
	fmt.Println(fmt.Sprintf("LOOP::%s %s", player.Name, player.Info[FieldLoopStatus]))
}
