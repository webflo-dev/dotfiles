local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local utilUi = require("helpers.ui")

local widget = {}

local function worker()
  local icon_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "",
    align = 'center',
    valign = 'center',
    forced_width = dpi(20),
    font = utilUi.font_glyph(12),
  }

  widget = wibox.widget {
    {
      icon_widget,
      widget = wibox.container.margin,
      margins = { left = dpi(10), right = dpi(10) }
    },
    widget = wibox.container.background,
    shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    bg = beautiful.yellow,
    fg = beautiful.gray,
  }

  awesome.connect_signal("signal::mic", function(volume, mute)
    if (mute == true) then
      icon_widget:set_markup("")
      widget:set_bg(beautiful.red)
      widget:set_fg(beautiful.light)
    else
      icon_widget:set_markup("")
      widget:set_bg(beautiful.yellow)
      widget:set_fg(beautiful.gray)
    end
  end)

  return widget
end

return setmetatable(widget, {
  __call = function(_, ...)
    return worker(...)
  end
})
