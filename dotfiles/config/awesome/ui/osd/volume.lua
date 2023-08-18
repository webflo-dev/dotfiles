local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local ui = require("ui.utils")

local height = dpi(250)
local width = dpi(50)

local prg = wibox.widget({
	max_value = 100,
	forced_height = width,
	forced_width = height,
	value = 25,
	shape = gears.shape.rounded_rect,
	color = beautiful.colors.sky,
	background_color = beautiful.bg_normal,
	widget = wibox.widget.progressbar,
})

local icon = wibox.widget({
	image = beautiful.svg.volume,
	stylesheet = ui.stylesheet_color(beautiful.bg_normal),
	valign = "bottom",
	halign = "center",
	widget = wibox.widget.imagebox,
})

local pop = wibox({
	height = height,
	width = width,
	shape = gears.shape.rounded_rect,
	halign = "center",
	valign = "center",
	ontop = true,
	visible = false,
})

awful.placement.right(pop, { margins = { right = beautiful.useless_gap * 4 } })

pop:setup({
	{
		prg,
		widget = wibox.container.rotate,
		direction = "east",
	},
	{
		icon,
		margins = { bottom = dpi(12), left = dpi(5), right = dpi(5) },
		widget = wibox.container.margin,
	},
	layout = wibox.layout.stack,
})

local run = gears.timer({
	timeout = 2,
	auto_start = false,
	callback = function()
		pop.visible = false
	end,
})

local daemon = require("daemons.audio")
daemon:connect_signal("sink::default::updated", function(_, device)
	if device.mute == false then
		prg.color = beautiful.colors.sky
		icon.image = beautiful.svg.volume
	else
		prg.color = beautiful.colors.red
		icon.image = beautiful.svg.volume_mute
	end
	prg.value = device.volume
	if pop.visible then
		run:again()
	else
		pop.visible = true
		run:again()
	end
end)
