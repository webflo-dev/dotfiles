package mprisctl

import (
	"fmt"
)

func printMetadataValues(player *Player) string {
	metadata := player.Info[FieldMetadata].(map[string]interface{})
	return fmt.Sprintf("owner=\"%s\" artist=\"%s\" title=\"%s\" album=\"%s\" track_id=\"%s\" length=%d duration=%s url=%s art_url=%s",
		player.Owner,
		metadata[MetadataArtist],
		metadata[MetadataTitle],
		metadata[MetadataAlbum],
		metadata[MetadataTrackId],
		metadata[MetadataLength],
		metadata[MetadataDuration],
		metadata[MetadataUrl],
		metadata[MetadataArtUrl],
	)
}

func printCapabilitiesValues(player *Player) string {
	return fmt.Sprintf("can_control=%t can_go_next=%t can_go_previous=%t can_pause=%t can_play=%t can_seek=%t",
		player.Info[FieldCanControl],
		player.Info[FieldCanGoNext],
		player.Info[FieldCanGoPrevious],
		player.Info[FieldCanPause],
		player.Info[FieldCanPlay],
		player.Info[FieldCanSeek],
	)
}

func printShuffleStatusValues(player *Player) string {
	return fmt.Sprintf("shuffle=%t", player.Info[FieldShuffle])
}

func printLoopStatusValues(player *Player) string {
	return fmt.Sprintf("loop_status=%s", player.Info[FieldLoopStatus])
}

func printPlaybackStatusValues(player *Player) string {
	return fmt.Sprintf("playback_status=%s", player.Info[FieldPlaybackStatus])
}

func printMetadata(player *Player) {
	fmt.Println(fmt.Sprintf("METADATA::%s %s", player.Name, printMetadataValues(player)))
}

func printCapabilities(player *Player) {
	fmt.Println(fmt.Sprintf("CAPABILITIES::%s %s", player.Name, printCapabilitiesValues(player)))
}

func printPlaybackStatus(player *Player) {
	fmt.Println(fmt.Sprintf("PLAYBACK_STATUS::%s %s", player.Name, printPlaybackStatusValues(player)))
}

func printPosition(position uint64, playerName string, remaining_raw uint64) {
	elapsed, _, _, _ := convertToDuration(position)
	remaining, _, _, _ := convertToDuration(remaining_raw)
	fmt.Println(fmt.Sprintf("POSITION::%s elapsed=%s elasped_raw=%d remaining=%s remaining_raw=%d", playerName, elapsed, position, remaining, remaining_raw))
}

func printConnectionStatus(player *Player, connected bool) {
	var status string
	if connected {
		status = "connected"
	} else {
		status = "disconnected"
	}
	fmt.Println(fmt.Sprintf("PLAYER::%s player_name=%s %s %s %s %s %s",
		status,
		player.Name,
		printMetadataValues(player),
		printCapabilitiesValues(player),
		printPlaybackStatusValues(player),
		printShuffleStatusValues(player),
		printLoopStatusValues(player),
	))
}

func printShuffleStatus(player *Player) {
	fmt.Println(fmt.Sprintf("SHUFFLE::%s %s", player.Name, printShuffleStatusValues(player)))
}

func printLoopStatus(player *Player) {
	fmt.Println(fmt.Sprintf("LOOP::%s %s", player.Name, printLoopStatusValues(player)))
}
