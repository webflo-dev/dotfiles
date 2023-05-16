local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local box = require("themes.summer.widgets.base.box")


local _icon = function(s, enable_click)
  return wibox.widget {
    awful.widget.layoutbox {
      screen = s,
      buttons = enable_click == true and {
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(-1) end),
        awful.button({}, 5, function() awful.layout.inc(1) end),
      }
    },
    widget = wibox.container.margin,
    margins = dpi(5),
  }
end


local _name = function(s)
  local textbox = wibox.widget {
    widget = wibox.widget.textbox,
    text   = "",
    align  = 'center',
    valign = 'center',
  }

  local function update_txt(_s)
    local name = awful.layout.getname(awful.layout.get(_s)) or ""
    textbox:set_text(name)
  end

  update_txt(s)

  awful.tag.attached_connect_signal(s, "property::selected", function() update_txt(s) end)
  awful.tag.attached_connect_signal(s, "property::layout", function() update_txt(s) end)
  return textbox
end


return function(s)
  return wibox.widget {
    box(_icon(s), _name(s)),
    buttons = {
      awful.button({}, 1, function() awful.layout.inc(1) end),
      awful.button({}, 3, function() awful.layout.inc(-1) end),
      awful.button({}, 4, function() awful.layout.inc(-1) end),
      awful.button({}, 5, function() awful.layout.inc(1) end),
    },
    layout = wibox.layout.fixed.horizontal
  }
end



-- https://awesomewm.org/doc/api/classes/awful.widget.layoutlist.html
