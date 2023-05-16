local beautiful = require("beautiful")

local base = require("themes.summer.widgets.base")

local widget = {}

local function worker()
  widget = base.iconbox("")
  widget:set_visible(false)

  awesome.connect_signal("bluetooth::state", function(state)
    widget:set_visible(true)
    if (state == "on") then
      widget:set_bg(beautiful.yellow)
      widget:set_fg(beautiful.gray)
    else
      widget:set_bg(beautiful.red)
      widget:set_fg(beautiful.light)
    end
  end)

  return widget
end

return setmetatable(widget, { __call = function(_, ...)
  return worker(...)
end })
