local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

local cpu_image = base.svg(beautiful.svg.cpu, beautiful.accent_color)

local cpu_text = wibox.widget({
	widget = wibox.widget.textbox,
	markup = "---",
	align = "right",
	valign = "center",
	forced_width = dpi(30),
	font = helperUI.font(nil, beautiful.fonts.monospace),
})

awesome.connect_signal("cpu::update", function(value)
	local pango = {}

	if value >= 70 and value < 90 then
		pango.foreground = beautiful.colors.orange
		cpu_image:change_fill(beautiful.colors.orange)
	elseif value >= 90 then
		pango.foreground = beautiful.colors.red
		cpu_image:change_fill(beautiful.colors.red)
	else
		pango.foreground = nil
		cpu_image:change_fill(beautiful.colors.lime)
	end

	cpu_text:set_markup(helperUI.pango2(value .. "%", pango))
end)

local cpu = wibox.widget({
	cpu_image,
	cpu_text,
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(5),
})

return cpu
