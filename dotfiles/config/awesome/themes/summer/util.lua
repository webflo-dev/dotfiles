local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local util = {}

util.shape = function(cr, width, height)
  gears.shape.rounded_rect(cr, width, height, 8)
end

util.seperator = wibox.widget.separator {
  orientation = "horizontal",
  forced_height = 2,
  thickness = 2,
  color = "#4c4c4c"
}

util.center = function(widget)
  return {
    layout = wibox.layout.align.horizontal,
    expand = "none",
    nil,
    widget,
    nil
  }
end

util.widget_background = function(widget, bg)
  return wibox.container.background(wibox.container.margin({
    layout = wibox.layout.align.horizontal,
    expand = "none",
    nil,
    widget,
    nil,
    forced_width = 30;
  }, 0, 0, 5, 5), bg, util.shape)
end

util.spacer = wibox.container.margin(nil, 0, 0, 15, 0)


util.font = function(size, font_name)
  return font_name or beautiful.font_name .. " " .. size
end

util.font_glyph = function(size, font_name)
  return font_name or beautiful.font_glyph_name .. " " .. size
  -- return "Material Icons Two Tone " .. size
end

return util
