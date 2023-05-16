local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi


return function(args)
  args = args or {}

  return wibox.widget {
    id = "#margin",
    layout = wibox.container.margin,
    {
      id = "#background",
      layout = wibox.container.background,
      {
        id = "#background_content",
        layout = wibox.layout.stack,
        {
          id = "#overlay",
          layout = wibox.container.background,
          visible = false,
          {
            layout = wibox.layout.stack,
            {
              id = "#hover_overlay",
              layout = wibox.container.background,
              visible = false,
            },
            {
              id = "#press_overlay",
              layout = wibox.container.background,
              visible = false,
            },
          },
        },
        {
          id = "#padding",
          layout = wibox.container.margin,
          {
            id = "#content_container",
            layout = wibox.container.constraint,
            args.widget,
          },
        },
      },
    },
  }
end
