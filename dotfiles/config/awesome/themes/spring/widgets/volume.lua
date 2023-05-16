local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

local volume_image = base.svg(beautiful.svg.volume, beautiful.colors.yellow)

local volume_text = wibox.widget({
	widget = wibox.widget.textbox,
	markup = "---",
	align = "right",
	valign = "center",
	forced_width = dpi(40),
	font = helperUI.font(nil, beautiful.fonts.monospace),
})

local volume = wibox.widget({
	volume_image,
	volume_text,
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(5),
})

awesome.connect_signal("signal::volume", function(volume, mute)
	local value = volume .. "%"
	if mute == true then
		volume_image:change(beautiful.svg.volume_mute, beautiful.colors.red)
		volume_text:set_markup(helperUI.pango2(value, {
			foreground = beautiful.colors.red,
			font = beautiful.fonts.monospace,
		}))
	else
		volume_image:change(beautiful.svg.volume, beautiful.colors.yellow)
		volume_text:set_markup(value)
	end
end)

return volume
