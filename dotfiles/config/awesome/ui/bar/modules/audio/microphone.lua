local wibox = require("wibox")
local beautiful = require("beautiful")

local ui = require("ui.utils")
local tpl = require("ui.templates")

local daemon = require("daemons.audio")

local widget = wibox.widget({
	tpl.svg({
		image = beautiful.svg.microphone,
		color = beautiful.colors.yellow,
		id = "w_image",
	}),
	layout = wibox.layout.fixed.horizontal,
})

daemon:connect_signal("source::default::updated", function(_, device)
	local w_image = widget:get_children_by_id("w_image")[1]

	if device.mute then
		w_image.image = beautiful.svg.microphone_mute
		w_image.stylesheet = ui.stylesheet_color(beautiful.colors.red)
	else
		w_image.image = beautiful.svg.microphone
		w_image.stylesheet = ui.stylesheet_color(beautiful.colors.yellow)
	end
end)

return widget
