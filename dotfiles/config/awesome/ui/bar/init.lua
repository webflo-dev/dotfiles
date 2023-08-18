local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local tags = require(... .. ".modules.tags")
local date_time = require(... .. ".modules.date-time")
local system = require(... .. ".modules.system")
local audio = require(... .. ".modules.audio")
local network = require(... .. ".modules.network")
local playerctl = require(... .. ".modules.playerctl")
local record = require(... .. ".modules.record")
local overmind = require(... .. ".modules.overmind")

local function left(s)
	return wibox.widget({
		tags(s),
		playerctl,
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(10),
	})
end

local function middle(_)
	return wibox.widget({
		date_time,
		record,
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(20),
	})
end

local function right(_)
	return wibox.widget({
		{
			overmind,
			wibox.widget.systray(),
			system,
			network,
			audio,
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(20),
		},
		widget = wibox.container.place,
		halign = "right",
	})
end

local function get_bar(s)
	local bar = awful.wibar({
		position = "top",
		type = "dock",
		screen = s,
		margins = {
			top = dpi(5),
			bottom = -1 * beautiful.useless_gap,
		},
		height = dpi(30),
		width = s.geometry.width,
		bg = "#00000000",
		-- bg = beautiful.bg_normal,
	})

	bar:setup({
		{
			left(s),
			widget = wibox.container.margin,
			margins = { left = dpi(20) },
			-- margins = { left = dpi(20), top = dpi(5), bottom = dpi(5) },
		},
		{
			middle(s),
			widget = wibox.container.margin,
			-- margins = { top = dpi(5), bottom = dpi(5) },
		},
		{
			right(s),
			widget = wibox.container.margin,
			margins = { right = dpi(20) },
			-- margins = { right = dpi(20), top = dpi(5), bottom = dpi(5) },
		},
		expand = "outside",
		layout = wibox.layout.align.horizontal,
	})
end

awful.screen.connect_for_each_screen(function(s)
	get_bar(s)
end)
