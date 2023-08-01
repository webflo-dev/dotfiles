local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local helperString = require("helpers.string")
local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

local signals = require("signals").screenrecord_signals

local w_icon = base.svg(beautiful.svg.video, beautiful.colors.light, "w_icon")
local w_stop = base.svg(beautiful.svg.stop, beautiful.bg_urgent, "w_stop")
w_stop.visible = false

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
			w_stop,
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

local function set_duration(elapsed_time)
	w_text.markup = string.format(
		"%s %s",
		helperUI.pango2("recording...", { foreground = beautiful.bg_urgent, style = "italic" }),
		elapsed_time and helperString.elapsedTimeToDuration(elapsed_time)
	)
end

widget:connect_signal("button::press", function()
	if w_stop.visible then
		awesome.emit_signal(signals.toggle)
	end
end)

awesome.connect_signal(signals.idle, function()
	widget.visible = false
	w_stop.visible = false
end)

awesome.connect_signal(signals.selecting, function()
	widget.visible = true
	w_stop.visible = false
	w_text.markup = "selecting area..."
end)

awesome.connect_signal(signals.recording, function()
	widget.visible = true
	w_stop.visible = true
	set_duration()
end)

awesome.connect_signal(signals.tick, set_duration)

return widget
