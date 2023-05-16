local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")

local base = require("themes.spring.widgets.base")
local cpu = require("themes.spring.widgets.cpu")
local memory = require("themes.spring.widgets.memory")
local gpu = require("themes.spring.widgets.gpu")

local separator = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helperUI.pango(" | ", beautiful.accent_color),
	align = "center",
	valign = "center",
})

local system = wibox.widget({
	cpu,
	-- seperator,
	memory,
	-- seperator,
	gpu,
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(20),
})

return base.box(system)
