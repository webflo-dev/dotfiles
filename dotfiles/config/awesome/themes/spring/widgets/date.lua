local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

local date_image = base.svg(beautiful.svg.calendar, beautiful.colors.yellow)

local date_text = wibox.widget({
	widget = wibox.widget.textclock,
	format = helperUI.pango2("%A %d %B", { weight = "bold", font = beautiful.font_size }),
	align = "center",
	valign = "center",
})

local date = wibox.widget({
	date_image,
	date_text,
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(10),
})

return base.box(date)
