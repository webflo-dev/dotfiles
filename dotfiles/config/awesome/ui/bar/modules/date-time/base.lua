local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local ui = require("ui.utils")
local tpl = require("ui.templates")
local utils = require("utils.widget")

local function new(args)
	local module = tpl.wibar_module({
		tpl.svg({
			image = args.image,
			color = beautiful.colors.yellow,
		}),
		{
			widget = wibox.widget.textclock,
			format = ui.pango(args.format, {
				weight = "bold",
				font = beautiful.font_size,
			}),
			align = "center",
			valign = "center",
		},
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(10),
	})

	return wibox.widget(module)
end

return utils.factory(new)
