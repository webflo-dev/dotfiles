local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local theme_dir = gears.filesystem.get_configuration_dir() .. "themes/spring/"


local theme               = {}

theme.theme_dir           = theme_dir

theme.font_size           = 12
theme.font_name           = "system-ui"
theme.font_monospace_name = "monospace"

theme.font_glyph_name     = "bootstrap-icons"
theme.font_glyph_alt_name = "Font Awesome 6 Pro"


-- Palette
theme.red    = "#e05f65"
theme.orange = "#DF7C2C"
theme.yellow = "#f1cf8a"
theme.lime   = "#94f7c5"
theme.green  = "#78dba9"
theme.sky    = "#8cc1ff"
theme.blue   = "#70a5eb"
theme.purple = "#c68aee"

theme.darker = "#171a1f"
theme.dark   = "#171a1f"
theme.gray   = "#b6beca"
-- theme.light_gray = "#AEB7B6"
theme.light  = "#DEE1E6"
-- theme.brown  = "#776550"


theme.accent_color        = theme.yellow
theme.bg                  = theme.dark

theme.bg_normal           = theme.bg .. "da"
theme.bg_focus            = theme.bg .. "ea"
-- theme.bg_normal           = theme.bg .. "66"
theme.bg_focus            = theme.bg .. "bf"
theme.bg_urgent           = theme.red
theme.bg_minimize         = theme.darker .. "66"
theme.bg_systray          = theme.bg_normal

-- theme.fg_normal           = "#aaaaaa"
theme.fg_normal           = theme.light
theme.fg_focus            = "#ffffff"
theme.fg_urgent           = "#ffffff"
theme.fg_minimize         = "#ffffff"

theme.useless_gap         = dpi(10)
theme.border_width        = dpi(3)
theme.border_normal       = theme.bg .. "00"
theme.border_focus        = theme.bg .. "00"
theme.border_color_normal = theme.bg
theme.border_color_active = theme.accent_color
theme.border_color_marked = "#91231c"


theme.notification_border_width = theme.border_width
theme.notification_border_color = theme.lime
theme.notification_font         = theme.font_name .. " " .. theme.font_size
theme.notification_padding      = dpi(10)
theme.notification_min_width    = dpi(300)

theme.radius                    = 8

theme.icons                     = {
  calendar = " ",
  clock = " ",
  processor = " ",
  memory = " ",
  graphic_card = " ",
  volume = " ",
  volume_mute = " ",
  microphone = " ",
  microphone_mute = " ",
  ethernet = " ",
  ethernet_disconnected = "",
  ethernet_connecting = " ",
  wifi = " ",
  wifi_disconnected = " ",
  wifi_connecting = " ",
}

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
