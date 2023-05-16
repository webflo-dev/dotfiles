local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local dpi = beautiful.xresources.apply_dpi

local utilUi = require("helpers.ui")
local box = require("themes.summer.widgets.base.box")


local gpu_icon = wibox.widget {
  widget = wibox.widget.textbox,
  text = "",
  align = 'center',
  valign = 'center',
  forced_width = dpi(20),
  font = utilUi.font_glyph(12),
}

local gpu_text = wibox.widget {
  widget = wibox.widget.textbox,
  text = "---",
  align = "right",
  valign = "center",
  forced_width = dpi(40),
  font = utilUi.font(12),
}

awesome.connect_signal("nvidia::update", function(value)
  gpu_text:set_text(value .. '%')
end)

local gpu = wibox.widget {
  gpu_icon,
  gpu_text,
  layout = wibox.layout.fixed.horizontal,
  spacing = dpi(5)
}

return gpu
