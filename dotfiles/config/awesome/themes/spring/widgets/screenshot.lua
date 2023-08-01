local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local helperString = require("helpers.string")
local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

local signals = require("signals").screenshot_signals

local w_icon = base.svg(beautiful.svg.camera, beautiful.colors.light, "w_icon")

local w_text = wibox.widget({
	id = "w_text",
	widget = wibox.widget.textbox,
	font = beautiful.fonts.system,
	align = "right",
	valign = "center",
	markup = "",
})

local widget = wibox.widget({
	{
		{
			w_icon,
			w_text,
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(10),
		},
		widget = wibox.container.margin,
		margins = {
			left = dpi(10),
			right = dpi(10),
		},
	},
	widget = wibox.container.background,
	shape = helperUI.rounded_shape(),
	bg = beautiful.bg_normal,
	border_color = beautiful.bg_focus,
	border_width = dpi(2),
	visible = false,
})

awesome.connect_signal(signals.idle, function()
	widget.visible = false
end)

awesome.connect_signal(signals.selecting, function()
	widget.visible = true
	w_text.markup = "taking screenshot..."
end)

return widget
