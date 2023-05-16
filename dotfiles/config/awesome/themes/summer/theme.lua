local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local theme_dir = gears.filesystem.get_configuration_dir() .. "/themes/summer/"


local theme           = {}

--theme.font_name       = "Inter V"
--theme.font_name       = "Cartograph CF"
theme.font_name       = "system-ui"
-- theme.font_name       = "monospace"
-- theme.font_glyph_name = "Material Icons Two Tone"
-- theme.font_glyph_name = "CartographCF Nerd Font"
theme.font_glyph_name = "Font Awesome 6 Pro"
-- theme.font_glyph_name = "Symbols Nerd Font"
theme.font            = theme.font_name .. " 12"


-- Palette
theme.red        = "#CF3746"
theme.orange     = "#DF7C2C"
theme.yellow     = "#ECBD10"
theme.lime       = "#7CBD27"
theme.green      = "#41A36F"
theme.sky        = "#32B5C7"
theme.blue       = "#277AB6"
theme.purple     = "#AD4ED2"

theme.darker     = "#1D1D1D"
theme.dark       = "#292A2B"
theme.gray       = "#626861"
theme.light_gray = "#AEB7B6"
theme.light      = "#D8E2E1"
theme.brown      = "#776550"


theme.acccent_color       = theme.yellow
theme.bg                  = theme.dark

theme.bg_normal           = theme.bg .. "66"
theme.bg_focus            = theme.bg .. "bf"
theme.bg_urgent           = theme.red
theme.bg_minimize         = theme.darker .. "66"
theme.bg_systray          = theme.bg_normal

theme.fg_normal           = theme.light
theme.fg_focus            = "#ffffff"
theme.fg_urgent           = "#ffffff"
theme.fg_minimize         = "#ffffff"

theme.useless_gap         = dpi(12)
theme.border_width        = dpi(4)
theme.border_color_normal = theme.bg
theme.border_color_active = theme.acccent_color
theme.border_color_marked = "#91231c"


-- Define the image to load
theme.titlebar_close_button_normal              = theme_dir .. "icons/titlebar/close_normal.png"
theme.titlebar_close_button_focus               = theme_dir .. "icons/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal           = theme_dir .. "icons/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = theme_dir .. "icons/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive     = theme_dir .. "icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = theme_dir .. "icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = theme_dir .. "icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = theme_dir .. "icons/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = theme_dir .. "icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = theme_dir .. "icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = theme_dir .. "icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = theme_dir .. "icons/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = theme_dir .. "icons/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = theme_dir .. "icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = theme_dir .. "icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = theme_dir .. "icons/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = theme_dir .. "icons/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme_dir .. "icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = theme_dir .. "icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = theme_dir .. "icons/titlebar/maximized_focus_active.png"



-- You can use your own layout icons like this:
theme.layout_fairh              = gears.color.recolor_image(theme_dir .. "icons/layouts/fairhw.png", theme.gray)
theme.layout_fairv              = gears.color.recolor_image(theme_dir .. "icons/layouts/fairvw.png", theme.gray)
theme.layout_floating           = gears.color.recolor_image(theme_dir .. "icons/layouts/floatingw.png", theme.gray)
theme.layout_magnifier          = gears.color.recolor_image(theme_dir .. "icons/layouts/magnifierw.png", theme.gray)
theme.layout_max                = gears.color.recolor_image(theme_dir .. "icons/layouts/maxw.png", theme.gray)
theme.layout_fullscreen         = gears.color.recolor_image(theme_dir .. "icons/layouts/fullscreenw.png", theme.gray)
theme.layout_tilebottom         = gears.color.recolor_image(theme_dir .. "icons/layouts/tilebottomw.png", theme.gray)
theme.layout_tileleft           = gears.color.recolor_image(theme_dir .. "icons/layouts/tileleftw.png", theme.gray)
theme.layout_tile               = gears.color.recolor_image(theme_dir .. "icons/layouts/tilew.png", theme.gray)
theme.layout_tiletop            = gears.color.recolor_image(theme_dir .. "icons/layouts/tiletopw.png", theme.gray)
theme.layout_spiral             = gears.color.recolor_image(theme_dir .. "icons/layouts/spiralw.png", theme.gray)
theme.layout_dwindle            = gears.color.recolor_image(theme_dir .. "icons/layouts/dwindlew.png", theme.gray)
theme.layout_cornernw           = gears.color.recolor_image(theme_dir .. "icons/layouts/cornernww.png", theme.gray)
theme.layout_cornerne           = gears.color.recolor_image(theme_dir .. "icons/layouts/cornernew.png", theme.gray)
theme.layout_cornersw           = gears.color.recolor_image(theme_dir .. "icons/layouts/cornersww.png", theme.gray)
theme.layout_cornerse           = gears.color.recolor_image(theme_dir .. "icons/layouts/cornersew.png", theme.gray)

theme.mstab_tabbar_style        = "modern"

theme.notification_border_width = theme.border_width
theme.notification_border_color = theme.lime
theme.notification_font         = theme.font
theme.notification_padding      = dpi(10)

return theme
