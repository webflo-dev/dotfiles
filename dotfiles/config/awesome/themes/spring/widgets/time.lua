local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

local time_image = base.svg(beautiful.svg.clock, beautiful.colors.yellow)

local time_text = wibox.widget({
	widget = wibox.widget.textclock,
	format = helperUI.pango2("%H:%M", { weight = "bold", font = beautiful.font_size }),
	align = "center",
	valign = "center",
})

local time = wibox.widget({
	time_image,
	time_text,
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(10),
})

return base.box(time)
