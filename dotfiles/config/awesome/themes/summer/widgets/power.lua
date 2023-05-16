local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local utilUi = require("helpers.ui")
local box = require("themes.summer.widgets.base.box")

local UPower_States =
{
  Unknown = 0,
  Charging = 1,
  Discharging = 2,
  Empty = 3,
  Fully_charged = 4,
  Pending_charge = 5,
  Pending_discharge = 6,
}

local Battery_States =
{
  Low = 0,
  Medium = 1,
  High = 2,
  Full = 3,
  Charging = 4
}

local widget = {}

local function worker()
  local battery_state = -1

  local icon_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "",
    align = 'center',
    valign = 'center',
    forced_width = dpi(25),
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
    visible = false,
  }

  awesome.connect_signal("battery::update", function(percentage, state)
    widget:set_visible(true)
    if state == UPower_States.Discharging then
      if percentage < 25 and battery_state ~= Battery_States.Low then
        icon_widget:set_text("")
        battery_state = Battery_States.Low
        widget:set_bg(beautiful.red)
      end

      if percentage > 50 and battery_state ~= Battery_States.Medium then
        icon_widget:set_text("")
        widget:set_bg(beautiful.orange)
        battery_state = Battery_States.Medium
      end
      if percentage > 75 and battery_state ~= Battery_States.High then
        icon_widget:set_text("")
        widget:set_bg(beautiful.yellow)
        battery_state = Battery_States.High
      end
    elseif state == UPower_States.Fully_charged and percentage > 90 and
        battery_state ~= Battery_States.Full then
      icon_widget:set_text("")
      widget:set_bg(beautiful.yellow)
      battery_state = Battery_States.Full
    elseif state == UPower_States.Charging and battery_state ~= Battery_States.Charging then
      icon_widget:set_text("")
      widget:set_bg(beautiful.lime)
      battery_state = Battery_States.Charging
    end
  end)

  return widget
end

return setmetatable(widget, {
  __call = function(_, ...)
    return worker(...)
  end
})
