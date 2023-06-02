local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local base = require("themes.spring.widgets.base")

local popup = wibox({
	visible = false,
	ontop = true,
	width = dpi(250),
	height = dpi(80),
})

awful.placement.centered(popup, {
	honor_workarea = true,
	honor_padding = true,
	offset = { y = dpi(30) },
})

local value_widget = wibox.widget({
	text = "---",
	align = "center",
	valign = "center",
	font = beautiful.fonts.monospace,
	widget = wibox.widget.textbox,
})

local image_widget = base.svg(beautiful.svg.microphone, beautiful.colors.sky)

popup:setup({
	{
		{
			second = image_widget,
			layout = wibox.layout.align.horizontal,
		},
		margins = dpi(10),
		widget = wibox.container.margin,
	},
	border_width = beautiful.border_width,
	border_color = beautiful.colors.sky,
	bg = beautiful.bg_normal,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
})

local lifespan = gears.timer({
	timeout = 2,
	call_now = false,
	autostart = false,
	single_shot = true,
	callback = function()
		popup.visible = false
	end,
})

local first_run = true
local previous_mute = nil

awesome.connect_signal("signal::mic", function(value, mute)
	if first_run == true then
		first_run = false
		previous_mute = mute
	end

	if mute == true then
		image_widget:change_image(beautiful.svg.microphone_mute)
	else
		image_widget:change_image(beautiful.svg.microphone)
	end

	if not popup.visible then
		if previous_mute == mute then
			return
		end

		popup.visible = true
		lifespan:start()
	else
		lifespan:again()
	end

	previous_mute = mute
end)
