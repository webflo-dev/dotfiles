local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local utilUi = require("helpers.ui")
local box = require("themes.summer.widgets.base.box")

local widget = {}

local function worker(user_args)
  local icon = wibox.widget {
    widget = wibox.widget.textbox,
    -- text = "",
    text = "",
    align = 'center',
    valign = 'center',
    forced_width = dpi(20),
    -- font = util.font_glyph(12),
    font = 'bootstrap-icons 12'
  }

  local value_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "---",
    align = "right",
    valign = "center",
    forced_width = dpi(40),
    font = utilUi.font(12),
  }


  widget = box(
    icon,
    value_widget
  )

  awesome.connect_signal("nvidia::update", function(value)
    value_widget:set_text(value .. '%')
  end)

  return widget
end

return setmetatable(widget, {
  __call = function(_, ...)
    return worker(...)
  end
})
