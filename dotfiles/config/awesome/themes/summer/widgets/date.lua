local wibox = require("wibox")

local box = require("themes.summer.widgets.base.box")
local utilUi = require("helpers.ui")

local widget = {}

local function worker()
  widget = box(
    {
      widget = wibox.widget.textbox,
      text = "",
      align = 'center',
      valign = 'center',
      font = utilUi.font_glyph(12),
    },
    {
      widget = wibox.widget.textclock,
      format = "%A %d %B",
      align = "center",
      valign = "center",
      font = utilUi.font(12),
    }
  )
  return widget
end

return setmetatable(widget, {
  __call = function(_, ...)
    return worker(...)
  end
})
