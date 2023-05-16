local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local utilUi = require("helpers.ui")

local widget = {}

local icons = {
  wifi_connected = "",
  wifi_connecting = "",
  wifi_disconnected = "",
  ethernet_connected = "",
  ethernet_connecting = "",
  ethernet_disconnected = "",
}

local function worker()
  local icon_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "",
    align = 'center',
    valign = 'center',
    -- forced_width = dpi(20),
    font = utilUi.font_glyph(12),
  }

  widget = wibox.widget {
    {
      icon_widget,
      widget  = wibox.container.margin,
      -- margins = dpi(10),
      margins = { left = dpi(10), right = dpi(10) }
    },
    widget = wibox.container.background,
    shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    bg = beautiful.yellow,
    fg = beautiful.gray,
  }

  awesome.connect_signal("network::update", function(devices)
    local text = ''
    for _, device in ipairs(devices) do
      local key = device.type .. "_" .. device.state
      local icon = icons[key]
      local icon_color = beautiful.gray
      if (device.state == "disconnected") then
        icon_color = beautiful.red
      end
      local device_text = "<span foreground='" .. icon_color .. "'>" .. icon .. "</span>"
      text = text .. device_text .. " "
    end
    icon_widget:set_markup(text:sub(1, -2))
  end)

  return widget
end

return setmetatable(widget, {
  __call = function(_, ...)
    return worker(...)
  end
})
