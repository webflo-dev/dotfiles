local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

-- local layout_box = require("themes.spring.widgets.layout-box")
local layout = require("themes.spring.widgets.layouts")
local workspaces = require("themes.spring.widgets.workspaces")
local date = require("themes.spring.widgets.date")
local time = require("themes.spring.widgets.time")
local system = require("themes.spring.widgets.system")
local audio = require("themes.spring.widgets.audio")
local network = require("themes.spring.widgets.network")
local playerctl = require("themes.spring.widgets.playerctl")
local screenrecord = require("themes.spring.widgets.screenrecord")
local screenshot = require("themes.spring.widgets.screenshot")
local overmind = require("themes.spring.widgets.overmind")

local function left(s)
	return wibox.widget({
		workspaces(s),
		-- layout_box(s),
		layout(s),
		playerctl,
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(10),
	})
end

local function middle(s)
	return wibox.widget({
		time,
		date,
		screenrecord,
		screenshot,
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(20),
	})
end

local function right(s)
	return wibox.widget({
		{
			overmind,
			wibox.widget.systray(),
			system,
			-- network,
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
