local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local base = require(... .. ".base")

return {
	base({
		image = beautiful.svg.clock,
		format = "%H:%M",
	}),
	base({
		image = beautiful.svg.calendar,
		format = "%A %d %B",
	}),
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(20),
}
