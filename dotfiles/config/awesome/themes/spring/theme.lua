local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local theme = {}

-- theme.wallpaper           = "wallpaper-island.jpg"

theme.theme_dir = gears.filesystem.get_configuration_dir() .. "themes/spring/"

theme.font_size = 12
theme.font_size_pango = theme.font_size .. "pt"

theme.fonts = {
	system = "system-ui",
	monospace = "monospace",
	bootstrap = "bootstrap-icons",
	fontawesome = "Font Awesome 6 Pro Solid",
	fontawesome_brands = "Font Awesome 6 Brands",
	fontawesome_duotone = "Font Awesome 6 Duotone",
	fontawesome_sharp = "Font Awesome 6 Sharp",
}

-- Palette
theme.colors = {
	red = "#CF3746",
	orange = "#DF7C2C",
	yellow = "#ECBD10",
	lime = "#7CBD27",
	green = "#41A36F",
	sky = "#32B5C7",
	blue = "#277AB6",
	purple = "#AD4ED2",

	dark = "#292A2B",
	darker = "#1D1D1D",
	gray = "#626861",
	light = "#D8E2E1",
	light_gray = "#AEB7B6",
}

theme.svg = {
	clock = theme.theme_dir .. "svg/clock.svg",
	gpu = theme.theme_dir .. "svg/gpu.svg",
	calendar = theme.theme_dir .. "svg/calendar.svg",
	cpu = theme.theme_dir .. "svg/cpu.svg",
	ethernet = theme.theme_dir .. "svg/ethernet.svg",
	ethernet_disconnected = theme.theme_dir .. "svg/ethernet-disconnected.svg",
	ethernet_connecting = theme.theme_dir .. "svg/ethernet-connecting.svg",
	wifi = theme.theme_dir .. "svg/wifi.svg",
	wifi_disconnected = theme.theme_dir .. "svg/wifi-disconnected.svg",
	wifi_connecting = theme.theme_dir .. "svg/wifi-connecting.svg",
	memory = theme.theme_dir .. "svg/memory.svg",
	microphone = theme.theme_dir .. "svg/microphone.svg",
	microphone_mute = theme.theme_dir .. "svg/microphone-mute.svg",
	volume = theme.theme_dir .. "svg/volume.svg",
	volume_mute = theme.theme_dir .. "svg/volume-mute.svg",
	circle = function(number)
		return theme.theme_dir .. "svg/circle-" .. number .. "-solid.svg"
	end,
}

theme.accent_color = theme.colors.yellow

theme.radius = 8

theme.bg = theme.colors.dark
theme.bg_normal = theme.bg .. "da"
theme.bg_focus = theme.bg .. "ea"
-- theme.bg_normal           = theme.bg .. "66"
-- theme.bg_focus            = theme.bg .. "bf"
theme.bg_urgent = theme.colors.red
theme.bg_minimize = theme.colors.darker .. "66"
theme.bg_systray = theme.bg_normal

-- theme.fg_normal           = "#aaaaaa"
theme.fg_normal = theme.colors.light
theme.fg_focus = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.useless_gap = dpi(10)
theme.border_width = dpi(3)
theme.border_normal = theme.bg .. "00"
theme.border_focus = theme.bg .. "00"
theme.border_color_normal = theme.bg
theme.border_color_active = theme.accent_color
theme.border_color_marked = "#91231c"

-- naughty
theme.notification_border_width = theme.border_width
theme.notification_border_color = theme.colors.lime
theme.notification_font = theme.fonts.system .. " " .. theme.font_size
theme.notification_padding = dpi(10)
theme.notification_min_width = dpi(300)

-- layoutlist
-- theme.layoutlist_fg_selected = theme.fg_focus --string or pattern	The selected layout foreground (text) color.
-- theme.layoutlist_bg_selected = theme.bg_focus --string or pattern	The selected layout background color.
-- theme.layoutlist_shape_selected = require("gears").shape.rounded_rect --gears.shape	The selected layout shape.
-- theme.layoutlist_shape_border_width_selected = dpi(1) --number	The selected layout border width.
-- theme.layoutlist_shape_border_color_selected = theme.colors.light -- string or color	The selected layout border color.

-- Define the image to load
-- theme.titlebar_close_button_normal              = theme_dir .. "icons/titlebar/close_normal.png"
-- theme.titlebar_close_button_focus               = theme_dir .. "icons/titlebar/close_focus.png"
-- theme.titlebar_minimize_button_normal           = theme_dir .. "icons/titlebar/minimize_normal.png"
-- theme.titlebar_minimize_button_focus            = theme_dir .. "icons/titlebar/minimize_focus.png"
-- theme.titlebar_ontop_button_normal_inactive     = theme_dir .. "icons/titlebar/ontop_normal_inactive.png"
-- theme.titlebar_ontop_button_focus_inactive      = theme_dir .. "icons/titlebar/ontop_focus_inactive.png"
-- theme.titlebar_ontop_button_normal_active       = theme_dir .. "icons/titlebar/ontop_normal_active.png"
-- theme.titlebar_ontop_button_focus_active        = theme_dir .. "icons/titlebar/ontop_focus_active.png"
-- theme.titlebar_sticky_button_normal_inactive    = theme_dir .. "icons/titlebar/sticky_normal_inactive.png"
-- theme.titlebar_sticky_button_focus_inactive     = theme_dir .. "icons/titlebar/sticky_focus_inactive.png"
-- theme.titlebar_sticky_button_normal_active      = theme_dir .. "icons/titlebar/sticky_normal_active.png"
-- theme.titlebar_sticky_button_focus_active       = theme_dir .. "icons/titlebar/sticky_focus_active.png"
-- theme.titlebar_floating_button_normal_inactive  = theme_dir .. "icons/titlebar/floating_normal_inactive.png"
-- theme.titlebar_floating_button_focus_inactive   = theme_dir .. "icons/titlebar/floating_focus_inactive.png"
-- theme.titlebar_floating_button_normal_active    = theme_dir .. "icons/titlebar/floating_normal_active.png"
-- theme.titlebar_floating_button_focus_active     = theme_dir .. "icons/titlebar/floating_focus_active.png"
-- theme.titlebar_maximized_button_normal_inactive = theme_dir .. "icons/titlebar/maximized_normal_inactive.png"
-- theme.titlebar_maximized_button_focus_inactive  = theme_dir .. "icons/titlebar/maximized_focus_inactive.png"
-- theme.titlebar_maximized_button_normal_active   = theme_dir .. "icons/titlebar/maximized_normal_active.png"
-- theme.titlebar_maximized_button_focus_active    = theme_dir .. "icons/titlebar/maximized_focus_active.png"

theme.layout_tile = theme.theme_dir .. "icons/layouts/tile.svg"
theme.layout_tilebottom = theme.theme_dir .. "icons/layouts/tilebottom.svg"
theme.layout_magnifier = theme.theme_dir .. "icons/layouts/magnifier.svg"
theme.layout_max = theme.theme_dir .. "icons/layouts/max.svg"
theme.layout_horizontal = theme.theme_dir .. "icons/layouts/horizontal.svg"
theme.layout_spiral = theme.theme_dir .. "icons/layouts/spiral.svg"
theme.layout_mstab = theme.theme_dir .. "icons/layouts/mstab.svg"
theme.layout_deck = theme.theme_dir .. "icons/layouts/deck.svg"
theme.layout_floating = theme.theme_dir .. "icons/layouts/floating.svg"

-- You can use your own layout icons like this:
-- theme.layout_fairh       = gears.color.recolor_image(theme_dir .. "icons/layouts/fairhw.png", theme.gray)
-- theme.layout_fairv       = gears.color.recolor_image(theme_dir .. "icons/layouts/fairvw.png", theme.gray)
-- theme.layout_floating    = gears.color.recolor_image(theme_dir .. "icons/layouts/floatingw.png", theme.gray)
-- theme.layout_magnifier   = gears.color.recolor_image(theme_dir .. "icons/layouts/magnifierw.png", theme.gray)
-- theme.layout_max         = gears.color.recolor_image(theme_dir .. "icons/layouts/maxw.png", theme.gray)
-- theme.layout_fullscreen  = gears.color.recolor_image(theme_dir .. "icons/layouts/fullscreenw.png", theme.gray)
-- theme.layout_tilebottom  = gears.color.recolor_image(theme_dir .. "icons/layouts/tilebottomw.png", theme.gray)
-- theme.layout_tileleft    = gears.color.recolor_image(theme_dir .. "icons/layouts/tileleftw.png", theme.gray)
-- theme.layout_tile        = gears.color.recolor_image(theme_dir .. "icons/layouts/tilew.png", theme.gray)
-- theme.layout_tiletop     = gears.color.recolor_image(theme_dir .. "icons/layouts/tiletopw.png", theme.gray)
-- theme.layout_spiral      = gears.color.recolor_image(theme_dir .. "icons/layouts/spiralw.png", theme.gray)
-- theme.layout_dwindle     = gears.color.recolor_image(theme_dir .. "icons/layouts/dwindlew.png", theme.gray)
-- theme.layout_cornernw    = gears.color.recolor_image(theme_dir .. "icons/layouts/cornernww.png", theme.gray)
-- theme.layout_cornerne    = gears.color.recolor_image(theme_dir .. "icons/layouts/cornernew.png", theme.gray)
-- theme.layout_cornersw    = gears.color.recolor_image(theme_dir .. "icons/layouts/cornersww.png", theme.gray)
-- theme.layout_cornerse    = gears.color.recolor_image(theme_dir .. "icons/layouts/cornersew.png", theme.gray)

-- theme.mstab_tabbar_style = "modern"

return theme
