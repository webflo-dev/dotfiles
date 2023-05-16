local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local box = require("themes.summer.widgets.base.box2")
local utilUi = require("helpers.ui")

local widget = {}

local function worker()
  -- widget = box(
  --   {
  --     widget = wibox.widget.textbox,
  --     text = "",
  --     align = 'center',
  --     valign = 'center',
  --     font = util.font_glyph(12),
  --   },
  --   {
  --     widget = wibox.widget.textclock,
  --     format = "%H:%M",
  --     align = "center",
  --     valign = "center",
  --     font = util.font(12),
  --   }
  -- )
  --
  -- return widget

  return box({
    widget = {
      layout = wibox.layout.fixed.horizontal,
      spacing = dpi(10),
      {
        widget = wibox.widget.textbox,
        text = "",
        align = 'center',
        valign = 'center',
        font = utilUi.font_glyph(12),
      },
      {
        id = "bar_container",
        layout = wibox.container.place,
        valign = "center",
        {
          widget = wibox.widget.textclock,
          format = "%H:%M",
          align = "center",
          valign = "center",
          font = utilUi.font(12),
        }
      },
    },
  }
  )
end

return setmetatable(widget, {
  __call = function(_, ...)
    return worker(...)
  end
})
