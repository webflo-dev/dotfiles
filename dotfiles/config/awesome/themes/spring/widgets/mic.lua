local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

local mic_image = base.svg(beautiful.svg.microphone, beautiful.colors.yellow)

awesome.connect_signal("signal::mic", function(volume, mute)
	if mute == true then
		mic_image:change(beautiful.svg.microphone_mute, beautiful.colors.red)
	else
		mic_image:change(beautiful.svg.microphone, beautiful.colors.yellow)
	end
end)

return mic_image
