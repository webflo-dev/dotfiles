local gtable = require("gears.table")
local gfilesystem = require("gears.filesystem")
local gshape = require("gears.shape")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local theme_dir = gfilesystem.get_configuration_dir() .. "theme/"
local svg_dir = theme_dir .. "svg/"

local user_theme = {
	fonts = {
		system = "system-ui",
		monospace = "monospace",
	},
	colors = {
		red = "#CF3746",
		orange = "#DF7C2C",
		yellow = "#ECBD10",
		lime = "#7CBD27",
		green = "#41A36F",
		sky = "#32B5C7",
		blue = "#277AB6",
		purple = "#AD4ED2",
		white = "#FFFFFF",

		dark = "#292A2B",
		darker = "#1D1D1D",
		gray = "#626861",
		light = "#D8E2E1",
		light_gray = "#AEB7B6",
	},
	svg = {
		gpu = svg_dir .. "gpu.svg",
		cpu = svg_dir .. "cpu.svg",
		memory = svg_dir .. "memory.svg",

		ethernet = {
			connected = svg_dir .. "ethernet-connected.svg",
			disconnected = svg_dir .. "ethernet-disconnected.svg",
			connecting = svg_dir .. "ethernet-connecting.svg",
		},

		microphone = svg_dir .. "microphone.svg",
		microphone_mute = svg_dir .. "microphone-mute.svg",
		volume = svg_dir .. "volume.svg",
		volume_mute = svg_dir .. "volume-mute.svg",

		clock = svg_dir .. "clock.svg",
		calendar = svg_dir .. "calendar.svg",

		-- wifi = svg_dir .. "wifi.svg",
		-- wifi_disconnected = svg_dir .. "wifi-disconnected.svg",
		-- wifi_connecting = svg_dir .. "wifi-connecting.svg",

		circle_1 = svg_dir .. "circle-1-solid.svg",
		circle_2 = svg_dir .. "circle-2-solid.svg",
		circle_3 = svg_dir .. "circle-3-solid.svg",
		circle_4 = svg_dir .. "circle-4-solid.svg",
		circle_5 = svg_dir .. "circle-5-solid.svg",

		-- app launcher
		search = svg_dir .. "search.svg",

		-- playerctl
		music = svg_dir .. "music.svg",
		stop = svg_dir .. "stop.svg",
		forward = svg_dir .. "forward.svg",
		backward = svg_dir .. "backward.svg",
		play = svg_dir .. "play.svg",
		pause = svg_dir .. "pause.svg",

		-- screenrecord and screenshot
		video = svg_dir .. "video.svg",
		camera = svg_dir .. "camera.svg",

		-- overmind
		rocket = svg_dir .. "rocket.svg",
		check = svg_dir .. "check.svg",
		xmark = svg_dir .. "xmark.svg",
		question = svg_dir .. "question.svg",
		spinner = svg_dir .. "spinner-duotone.svg",
		file = svg_dir .. "file-lines.svg",
	},
	radius = dpi(8),
}
user_theme.accent_color = user_theme.colors.yellow
user_theme.bg_opaque = user_theme.colors.dark

-- AWESOME THEME
local awesome_theme = {
	-- awesome variables
	useless_gap = dpi(10),
	border_width = dpi(3),
	border_normal = user_theme.colors.dark .. "00",
	border_focus = user_theme.colors.dark .. "00",
	border_color_normal = user_theme.colors.dark,
	border_color_active = user_theme.accent_color,
	border_color_marked = "#91231c",

	-- beautiful variables
	font = user_theme.fonts.system,
	bg_normal = user_theme.bg_opaque .. "da",
	bg_focus = user_theme.bg_opaque .. "ea",
	bg_urgent = user_theme.colors.red,
	bg_minimize = user_theme.bg_opaque .. "66",
	fg_normal = user_theme.colors.light,
	fg_focus = user_theme.colors.white,
	fg_urgent = user_theme.colors.white,
	fg_minimize = user_theme.colors.white,
	wallpaper = theme_dir .. "wallpapers/wallpaper-3840x2160.jpg",

	-- layout icons
	layout_tile = theme_dir .. "icons/layouts/tile.svg",
	layout_tilebottom = theme_dir .. "icons/layouts/tilebottom.svg",
	layout_magnifier = theme_dir .. "icons/layouts/magnifier.svg",
	layout_max = theme_dir .. "icons/layouts/max.svg",
	layout_horizontal = theme_dir .. "icons/layouts/horizontal.svg",
	layout_spiral = theme_dir .. "icons/layouts/spiral.svg",
	layout_mstab = theme_dir .. "icons/layouts/mstab.svg",
	layout_deck = theme_dir .. "icons/layouts/deck.svg",
	layout_floating = theme_dir .. "icons/layouts/floating.svg",

	-- naughty
	notification_border_width = dpi(3),
	notification_border_color = user_theme.colors.lime,
	notification_font = user_theme.fonts.system,
	notification_padding = dpi(10),
	notification_min_width = dpi(300),

	-- tooltip
	tooltip_font = user_theme.fonts.system,
	tooltip_gaps = dpi(5),
	tooltip_border_width = dpi(3),
	tooltip_border_color = user_theme.colors.lime,
	tooltip_shape = gshape.rounded_rect,
}

local theme = {}
gtable.crush(theme, user_theme)
gtable.crush(theme, awesome_theme)
return theme
