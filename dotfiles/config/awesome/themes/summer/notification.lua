local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local dpi = beautiful.xresources.apply_dpi

naughty.config.spacing = 10
naughty.config.padding = 10

naughty.config.defaults.margin = 20
naughty.config.defaults.border_width = 0
naughty.config.defaults.timeout = 5
naughty.config.defaults.margin = 10

naughty.config.presets.low.timeout = 2
naughty.config.presets.critical.timeout = 12

naughty.config.presets.normal.bg = beautiful.bg_normal
naughty.config.presets.normal.fg = beautiful.fg_normal



naughty.connect_signal("request::display", function(n)
  local actions = wibox.widget {
    notification = n,
    base_layout = wibox.widget {
      spacing = dpi(5),
      layout = wibox.layout.flex.horizontal
    },
    widget_template = {
      {
        {
          {
            font = "monospace 11 bold",
            markup = " ",
            widget = wibox.widget.textbox
          },
          {
            id = 'text_role',
            font = beautiful.notification_font,
            widget = wibox.widget.textbox
          },
          forced_height = dpi(35),
          layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.place
      },
      strategy = "min",
      width = dpi(60),
      widget = wibox.container.constraint,
    },
    style = {
      underline_normal = false,
      underline_selected = true
    },
    widget = naughty.list.actions
  }

  naughty.layout.box {
    notification = n,
    shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 8) end,
    border_width = beautiful.notification_border_width,
    border_color = beautiful.notification_border_color,
    position = "top_middle",

    widget_template = {
      {
        {
          {
            {
              naughty.widget.icon,
              {
                {
                  nil,
                  {
                    {
                      align = "left",
                      font = beautiful.notification_font,
                      markup = "<b>" .. n.title .. "</b>",
                      widget = wibox.widget.textbox,
                      -- widget = naughty.widget.title,
                    },
                    {
                      align = "left",
                      widget = naughty.widget.message,
                    },
                    layout = wibox.layout.fixed.vertical
                  },
                  expand = "none",
                  layout = wibox.layout.align.vertical
                },
                left = n.icon and beautiful.notification_padding or 0,
                widget = wibox.container.margin,
              },
              layout = wibox.layout.align.horizontal
            },
            {
              {
                nil,
                actions,
                expand = "none",
                layout = wibox.layout.align.horizontal
              },
              visible = n.actions and #n.actions > 0,
              layout = wibox.layout.fixed.vertical
            },
            layout = wibox.layout.fixed.vertical
          },
          margins = beautiful.notification_padding,
          widget = wibox.container.margin,
        },
        strategy = "min",
        width = beautiful.notification_min_width or dpi(150),
        widget = wibox.container.constraint,
      },
      strategy = "max",
      width = beautiful.notification_max_width or dpi(300),
      height = beautiful.notification_max_height or dpi(150),
      widget = wibox.container.constraint,
    }
  }
end)
