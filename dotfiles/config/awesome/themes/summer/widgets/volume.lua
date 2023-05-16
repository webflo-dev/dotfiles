local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local utilUi = require("helpers.ui")
local box = require("themes.summer.widgets.base.box")

local widget = {}

local function worker()
  local icon_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "",
    align = 'center',
    valign = 'center',
    forced_width = dpi(20),
    font = utilUi.font_glyph(12),
  }

  local value_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "---",
    align = "center",
    valign = "center",
    font = utilUi.font(12),
  }


  widget = box(
    icon_widget,
    value_widget
  )

  awesome.connect_signal("signal::volume", function(volume, mute)
    value_widget:set_text(volume .. "%")
    if (mute == true) then
      icon_widget:set_markup("")
      widget:set_bg_left(beautiful.red)
      widget:set_fg_left(beautiful.light)
    else
      icon_widget:set_markup("")
      widget:set_bg_left(beautiful.yellow)
      widget:set_fg_left(beautiful.gray)
    end
  end)

  return widget
end

return setmetatable(widget, {
  __call = function(_, ...)
    return worker(...)
  end
})
