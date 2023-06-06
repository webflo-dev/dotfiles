local beautiful = require("beautiful")

local function make_widget_clickable(widget, hover_color, leave_color, on_click)
  widget:connect_signal("mouse::enter", function()
    local w = mouse.current_wibox
    if w then
      w.cursor = "hand2"
    end
    widget:change_fill(hover_color or beautiful.accent_color)
  end)

  widget:connect_signal("mouse::leave", function()
    local w = mouse.current_wibox
    if w then
      w.cursor = "left_ptr"
    end
    widget:change_fill(leave_color or beautiful.fg_normal)
  end)

  if (on_click ~= nil) then
    widget:connect_signal("button::press", on_click)
  end

  return widget
end


return make_widget_clickable
