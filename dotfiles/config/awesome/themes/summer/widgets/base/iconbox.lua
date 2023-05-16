local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local utilUi = require("helpers.ui")

return function(icon)
  local icon_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = icon,
    align = 'center',
    valign = 'center',
    forced_width = dpi(20),
    font = utilUi.font_glyph(12),
  }

  local widget = wibox.widget {
    {
      icon_widget,
      widget = wibox.container.margin,
      margins = { left = dpi(10), right = dpi(10) }
    },
    widget = wibox.container.background,
    shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    bg = beautiful.yellow,
    fg = beautiful.gray,
    set_icon_text = function(_, text)
      icon_widget:set_text(text)
    end,
    set_icon_width = function(_, width)
      icon_widget:set_forced_width(width)
    end,
    set_icon_size = function(_, size)
      icon_widget:set_font(utilUi.font_glyph(size))
    end,
    set_icon_font = function(_, font)
      icon_widget:set_font(font)
    end

  }

  return widget
end
