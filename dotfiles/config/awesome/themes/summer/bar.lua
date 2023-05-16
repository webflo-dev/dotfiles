local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local tag_list = require("themes.summer.widgets.tag_list")
local layout_box = require("themes.summer.widgets.layout_box")
local playerctl = require("themes.summer.widgets.playerctl")
local volume = require("themes.summer.widgets.volume")
local mic = require("themes.summer.widgets.mic")
local cpu = require("themes.summer.widgets.cpu")
local memory = require("themes.summer.widgets.memory")
local memory2 = require("themes.summer.widgets.memory2")
local power = require("themes.summer.widgets.power")
local time = require("themes.summer.widgets.time")
local date = require("themes.summer.widgets.date")
local bluetooth = require("themes.summer.widgets.bluetooth")
local network = require("themes.summer.widgets.network")
local nvidia = require("themes.summer.widgets.nvidia")

local time2 = require("themes.summer.widgets.time2")
-- local date2 = require("themes.summer.widgets.date2")

-- Left
local function left(s)
  return wibox.widget {
    tag_list(s),
    layout_box(s),
    playerctl(),
    spacing = dpi(30),
    layout = wibox.layout.fixed.horizontal,
  }
end

-- Center
local function center(s)
  return wibox.widget {
    time(),
    date(),
    -- time2(),
    -- date2(),
    spacing = dpi(30),
    layout = wibox.layout.fixed.horizontal,
  }
end

-- Right
local function right(s)
  return wibox.widget {
    {
      wibox.widget.systray(),
      cpu(),
      memory(),
      -- memory2(),
      nvidia(),
      power(),
      bluetooth(),
      network(),
      mic(s),
      volume(s),
      spacing = dpi(20),
      layout = wibox.layout.fixed.horizontal,
    },
    halign = "right",
    widget = wibox.container.place
  }
end

-- Bar
local function get_bar(s)
  local bar = awful.wibar {
    position = 'top',
    type = 'dock',
    screen = s,
    height = dpi(45),
    width = s.geometry.width,
    bg = "#00000000",
  }

  bar:setup {
    {
      left(s),
      widget = wibox.container.margin,
      margins = { left = dpi(20), top = dpi(5), bottom = dpi(5) },
    },
    {
      center(s),
      widget = wibox.container.margin,
      margins = { top = dpi(5), bottom = dpi(5) },
    },
    {
      right(s),
      widget = wibox.container.margin,
      margins = { right = dpi(20), top = dpi(5), bottom = dpi(5) },
    },
    expand = 'outside',
    layout = wibox.layout.align.horizontal,
  }
end

awful.screen.connect_for_each_screen(function(s)
  get_bar(s)
end)
