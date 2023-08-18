local wibox = require("wibox")

local screenshot = require(... .. ".screenshot")
local screenrecord = require(... .. ".screenrecord")

local widget = {
	screenrecord,
	screenshot,
	layout = wibox.layout.fixed.horizontal,
}

return widget
