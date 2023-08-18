local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local tpl = require("ui.templates")

local volume = require(... .. ".volume")
local microphone = require(... .. ".microphone")

local audio = {
	microphone,
	tpl.separator(),
	volume,
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(5),
}

return tpl.wibar_module(audio)
