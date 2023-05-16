local wibox = require("wibox")
local beautiful = require("beautiful")
local awful = require("awful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi


local cpu_cmd = [[grep --max-count=1 '^cpu.' /proc/stat]]
local timeout = 1
local widget = {}

local function worker(user_args)

  local cpugraph_widget = wibox.widget {
    -- forced_width = width,
    -- step_width = 2,
    -- step_spacing = 1,
    max_value = 100,
    capacity = (60 / timeout) * 2,
    background_color = beautiful.bg_normal,
    widget = wibox.widget.graph,
    color = "linear:0,0:0,20:0," .. beautiful.red .. ":0.3," .. beautiful.orange .. ":0.6," .. beautiful.lime
  }

  local cpu_widget = wibox.widget {
    widget = wibox.widget.textbox,
    text = "",
    valign = "center",
    halign = "right",
  }

  widget = wibox.widget {
    {
      {
        {
          {
            widget = wibox.widget.textbox,
            text = "CPU",
            valign = "center",
            halign = "center",
          },
          cpu_widget,
          spacing         = 5,
          expand          = true,
          homogeneous     = false,
          forced_num_cols = 1,
          forced_num_rows = 2,
          layout          = wibox.layout.grid
        },
        widget = wibox.container.margin,
        top = dpi(5), bottom = dpi(5), left = dpi(10), right = dpi(10)
      },
      widget = wibox.container.background,
      shape = function(cr, w, h) gears.shape.partially_rounded_rect(cr, w, h, true, false, false, true, 8) end,
      bg = beautiful.yellow,
      fg = beautiful.gray,
    },
    {
      {
        cpugraph_widget,
        reflection = { horizontal = true },
        layout = wibox.container.mirror
      },
      widget = wibox.container.background,
      shape = function(cr, w, h) gears.shape.partially_rounded_rect(cr, w, h, false, true, true, false, 8) end,
    },
    layout = wibox.layout.fixed.horizontal,
    widget = wibox.container.margin,
  }


  local maincpu = {}
  awful.widget.watch(cpu_cmd, timeout, function(widget, stdout)

    local _, user, nice, system, idle, iowait, irq, softirq, steal, _, _ =
    stdout:match('(%w+)%s+(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)')

    local total = user + nice + system + idle + iowait + irq + softirq + steal

    local diff_idle = idle - tonumber(maincpu['idle_prev'] == nil and 0 or maincpu['idle_prev'])
    local diff_total = total - tonumber(maincpu['total_prev'] == nil and 0 or maincpu['total_prev'])
    local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

    maincpu['total_prev'] = total
    maincpu['idle_prev'] = idle

    widget:add_value(diff_usage)
    cpu_widget:set_text(math.floor(diff_usage) .. '%')
  end,
    cpugraph_widget
  )

  return widget

end

return setmetatable(widget, { __call = function(_, ...)
  return worker(...)
end })
