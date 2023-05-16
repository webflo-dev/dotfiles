local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local utilUi = require("helpers.ui")

local base = require("themes.summer.widgets.base")

local widget = {}

local function worker(user_args)
  local icon_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "",
    align = 'center',
    valign = 'center',
    forced_width = dpi(20),
    font = utilUi.font_glyph(12),
  }

  local value_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "---",
    align = "right",
    valign = "center",
    forced_width = dpi(40),
    font = utilUi.font(12),
  }


  widget = base.box(icon_widget, value_widget)

  awesome.connect_signal("cpu::update", function(value)
    value_widget:set_text(value .. '%')
  end)

  return widget
end

return setmetatable(widget, {
  __call = function(_, ...)
    return worker(...)
  end
})
