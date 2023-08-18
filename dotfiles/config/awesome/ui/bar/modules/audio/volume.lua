local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local ui = require("ui.utils")
local tpl = require("ui.templates")

local daemon = require("daemons.audio")

local widget = wibox.widget({
	tpl.svg({
		image = beautiful.svg.volume,
		color = beautiful.colors.yellow,
		id = "w_image",
	}),
	tpl.text({
		align = "right",
		forced_width = dpi(40),
		id = "w_text",
	}),
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(5),
})

daemon:connect_signal("sink::default::updated", function(_, device)
	if device.default == false then
		return
	end

	local w_text = widget:get_children_by_id("w_text")[1]
	local w_image = widget:get_children_by_id("w_image")[1]
	local value = device.volume .. "%"

	if device.mute == true then
		w_image.image = beautiful.svg.volume_mute
		w_image.stylesheet = ui.stylesheet_color(beautiful.colors.red)
		w_text.markup = ui.pango(value, {
			foreground = beautiful.colors.red,
			font = beautiful.fonts.monospace,
		})
	else
		w_image.image = beautiful.svg.volume
		w_image.stylesheet = ui.stylesheet_color(beautiful.colors.yellow)
		w_text.markup = value
	end
end)

return widget
