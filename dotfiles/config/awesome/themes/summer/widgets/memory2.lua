local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local utilUi = require("helpers.ui")
local box = require("themes.summer.widgets.base.box")

local fixed_width = 50
local widget = {}

local function worker(user_args)
  local icon = wibox.widget {
    widget = wibox.widget.textbox,
    text = "",
    align = 'center',
    valign = 'center',
    forced_width = dpi(20),
    font = utilUi.font_glyph(12),
  }

  local value_widget = wibox.widget {
    widget           = wibox.widget.progressbar,
    max_value        = 1,
    value            = 100,
    color            = "#FFFFFF00",
    background_color = "#FFFFFF00",
    forced_width     = fixed_width,
  }

  local percentage_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "---",
    align = "center",
    valign = "center",
  }



  widget = box(
    icon,
    {
      value_widget,
      percentage_widget,
      layout = wibox.layout.stack
    }
  )

  awesome.connect_signal("memory::update", function(used, used_ram_percentage, total, available)
    local used_value = used_ram_percentage / 100
    value_widget:set_value(total);
    value_widget:set_color({
      type  = "linear",
      from  = { 0, 0 },
      to    = { fixed_width, 0 },
      stops = {
        { 0,          beautiful.green },
        { used_value, beautiful.green },
        { used_value, beautiful.lime },
        { 1,          beautiful.lime },
      }
    })
    percentage_widget:set_text(math.floor(used_ram_percentage) .. "%")
  end)

  return widget
end

return setmetatable(widget, {
  __call = function(_, ...)
    return worker(...)
  end
})
