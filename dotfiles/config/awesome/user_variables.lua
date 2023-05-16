local home = os.getenv("HOME")

local local_bin = home .. "/.local/bin/"

return {
	-- terminal = "kitty",
	-- floating_terminal = "kitty --class float-terminal",
	editor = "nvim",
	code_editor = "code",
	file_manager = "thunar",
	web_browser = "microsoft-edge-stable",
	music_player = "spotify",
	theme = "spring",
	cmd = {
		terminal = local_bin .. "terminal",
		terminal_float = local_bin .. "terminal --float",
		menu_launcher = local_bin .. "launcher",
		brightness_up = local_bin .. "backlight --up",
		brightness_down = local_bin .. "backlight --down",
		volume_up = local_bin .. "volume --up",
		volume_down = local_bin .. "volume --down",
		volume_mute = local_bin .. "volume --toggle",
		menu_screenshot = local_bin .. "screenshot --area",
		menu_window = local_bin .. "menu --window",
	},
}
