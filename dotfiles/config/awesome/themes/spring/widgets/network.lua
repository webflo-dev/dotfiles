local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local base = require("themes.spring.widgets.base")

local ethernet = require("themes.spring.widgets.ethernet")
local wifi = require("themes.spring.widgets.wifi")

local seperator = wibox.widget({
	widget = wibox.widget.textbox,
	text = " ",
	align = "center",
	valign = "center",
})

local network = wibox.widget({
	wifi,
	ethernet,
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(5),
})

return base.box(network)
