local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

local memory_image = base.svg(beautiful.svg.memory, beautiful.accent_color)

local memory_text = wibox.widget({
	widget = wibox.widget.textbox,
	markup = "---",
	align = "right",
	valign = "center",
	forced_width = dpi(30),
	font = helperUI.font(nil, beautiful.fonts.monospace),
})

awesome.connect_signal("memory::update", function(used, used_ram_percentage, total, available)
	local value = math.floor(used_ram_percentage)
	local pango = {}

	if value >= 70 and value < 90 then
		pango.foreground = beautiful.colors.orange
		memory_image:change_fill(beautiful.colors.orange)
	elseif value >= 90 then
		pango.foreground = beautiful.colors.red
		memory_image:change_fill(beautiful.colors.red)
	else
		pango.foreground = nil
		memory_image:change_fill(beautiful.colors.lime)
	end

	memory_text:set_markup(helperUI.pango2(value .. "%", pango))
end)

local memory = wibox.widget({
	memory_image,
	memory_text,
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(5),
})

return memory
