package mprisctl

func Watch(player string) {

	mprisService := NewMpris()

	players := mprisService.GetPlayerList()
	for _, player := range players {
		mprisService.RegisterPlayer(player)

		mprisService.UpdateTicker(player.Id, player.Info.PlaybackStatus)

		PrintConnectionStatus(*player, true)
		PrintTrackInfo(*player)
		PrintPlaybackStatus(*player)
	}

	for signal := range mprisService.StartMonitoring() {
		// fmt.Println("signal => ", signal)

		switch signal.Name {
		case SignalNameOwnerChanged:

			player, isMprisPlayer := mprisService.PlayerFromSignal(signal)
			if isMprisPlayer == false {
				continue
			}
			isConnected := mprisService.IsPlayerConnected(player.Id)
			if isConnected {
				PrintConnectionStatus(*player, true)
				mprisService.RegisterPlayer(player)
			} else {
				PrintConnectionStatus(*player, false)
				mprisService.UnregisterPlayer(*player)
			}
		case SignalPropertiesChanged:
			player, values, found := mprisService.GetFromSignal(signal)
			if found == false {
				continue
			}
			updateType := player.UpdateInfo(values)
			if updateType.HasOneOf(InfoTypeMetadata) {
				PrintTrackInfo(*player)
			}
			if updateType.HasOneOf(InfoTypePlaybackStatus) {
				PrintPlaybackStatus(*player)
				mprisService.UpdateTicker(player.Id, player.Info.PlaybackStatus)
			}
			if updateType.HasOneOf(InfoTypeShuffle) {
				PrintShuffleStatus(*player)
			}
			if updateType.HasOneOf(InfoTypeLoopStatus) {
				PrintLoopStatus(*player)
			}
		case SignalSeeked:
			player, _, found := mprisService.GetFromSignal(signal)
			if found == false {
				continue
			}
			mprisService.RestartTicker(player.Id)
		}
	}
}
