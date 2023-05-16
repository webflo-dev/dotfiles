local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

return function(child_left, child_right)
  local left = wibox.widget {
    {
      child_left,
      widget = wibox.container.margin,
      margins = { left = dpi(10), right = dpi(10) }
    },
    widget = wibox.container.background,
    shape = function(cr, w, h) gears.shape.partially_rounded_rect(cr, w, h, true, false, false, true, 8) end,
    bg = beautiful.yellow,
    fg = beautiful.gray,
    id = 'left',
  }

  local right = wibox.widget {
    {
      child_right,
      widget = wibox.container.margin,
      margins = { left = dpi(10), right = dpi(10) }
    },
    widget = wibox.container.background,
    shape = function(cr, w, h) gears.shape.partially_rounded_rect(cr, w, h, false, true, true, false, 8) end,
    bg = beautiful.bg_normal,
    fg = "#FFFFFF",
    id = 'right',
  }

  return wibox.widget {
    left,
    right,
    layout = wibox.layout.fixed.horizontal,
    widget = wibox.container.margin,
    set_fg_right = function(_, color)
      right:set_fg(color)
    end,
    set_bg_right = function(_, color)
      right:set_bg(color)
    end,
    set_fg_left = function(_, color)
      left:set_fg(color)
    end,
    set_bg_left = function(_, color)
      left:set_bg(color)
    end,
  }
end
