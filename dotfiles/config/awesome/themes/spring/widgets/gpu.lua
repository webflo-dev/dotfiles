local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

local gpu_image = base.svg(beautiful.svg.gpu, beautiful.accent_color)

local gpu_text = wibox.widget({
	widget = wibox.widget.textbox,
	markup = "---",
	align = "right",
	valign = "center",
	forced_width = dpi(30),
	font = helperUI.font(nil, beautiful.fonts.monospace),
})

awesome.connect_signal("nvidia::update", function(value_str)
	local value = tonumber(value_str)
	local pango = {}

	if value >= 70 and value < 90 then
		pango.foreground = beautiful.colors.orange
		gpu_image:change_fill(beautiful.colors.orange)
	elseif value >= 90 then
		pango.foreground = beautiful.colors.red
		gpu_image:change_fill(beautiful.colors.red)
	else
		pango.foreground = nil
		gpu_image:change_fill(beautiful.colors.lime)
	end

	gpu_text:set_markup(helperUI.pango2(value .. "%", pango))
end)

local gpu = wibox.widget({
	gpu_image,
	gpu_text,
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(5),
})

return gpu
