local awful = require("awful")
local aClient = require("awful.client")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local theme = require("themes.summer.theme")
beautiful.init(theme)

local dpi = beautiful.xresources.apply_dpi


local title_size = 32

local mkbutton = function(options)
  return function(c)
    local textbox = wibox.widget {
      widget = wibox.widget.textbox,
      align = 'center',
      valign = 'center',
      markup = options.default_text
      -- text = options.default_icon or '',
    }
    local button = wibox.widget {
      textbox,
      forced_width  = dpi(options.width or title_size),
      forced_height = dpi(title_size),
      bg            = options.bg_color,
      shape         = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 2) end,
      widget        = wibox.container.background
    }

    client.connect_signal("property::active", function()
      if c.active then
        button:set_bg(options.bg_color)
        button:set_fg(options.fg_color or beautiful.fg_normal)
      else
        button:set_fg(beautiful.light_gray)
        button:set_bg(beautiful.gray)
      end
      if options.on_active then
        options.on_active(c.active, button, textbox)
      end
    end)

    button:add_button(awful.button({}, 1, function()
      if options.on_click then
        options.on_click(c, button, textbox)
      end
    end))

    return button
  end
end


local close = mkbutton({
  bg_color = beautiful.red,
  default_text = "窱",
  -- width = title_size * 4 / 3,
  on_click = function(c)
    c:kill()
  end
})

local maximize = mkbutton({
  bg_color = beautiful.yellow,
  fg_color = beautiful.gray,
  -- default_text = "ﬕ",
  default_text = "M",
  on_click = function(c, button, textbox)
    if c.maximized == true then
      c.maximized = false
      textbox:set_text("M")
      -- textbox:set_text("ﬕ")
    else
      c.maximized = true
      textbox:set_text("M!")
      -- textbox:set_text("ﬔ")
      textbox:set_markup("<span weight='bold' fgcolor='" .. beautiful.dark .. "'>M!</span>")
    end
  end
})


local sticky = mkbutton({
  bg_color = beautiful.green,
  default_text = "P",
  -- default_text = "",
  on_click = function(c, button, textbox)
    if c.sticky == true then
      c.sticky = false
      textbox:set_text("P")
      button:set_bg(beautiful.green)
      -- textbox:set_text("")
    else
      c.sticky = true
      textbox:set_markup("<span weight='bold' fgcolor='" .. beautiful.dark .. "'>P!</span>")
      button:set_bg(beautiful.green)
      -- textbox:set_text("賈")
    end
  end
})

local onTop = mkbutton({
  bg_color = beautiful.orange,
  default_text = "T",
  on_click = function(c, button, textbox)
    if c.ontop == true then
      c.ontop = false
      textbox:set_text("T")
    else
      c.ontop = true
      -- textbox:set_text("T!")
      textbox:set_markup("<span weight='bold' fgcolor='" .. beautiful.dark .. "'>T!</span>")
    end
  end,
})


local floating = mkbutton({
  bg_color = beautiful.blue,
  -- default_text = "﩯",
  default_text = "F",
  on_click = function(c, button, textbox)
    local is_floating = aClient.object.get_floating(c)
    if is_floating == true then
      aClient.floating.toggle(c, false)
      -- textbox:set_text("﩯")
      textbox:set_text("F")
    else
      aClient.floating.toggle(c, true)
      -- textbox:set_text("穀")
      -- textbox:set_text("F!")
      textbox:set_markup("<span weight='bold' fgcolor='" .. beautiful.dark .. "'>F!</span>")
    end
    -- "穀"
  end
})


-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
  -- if c.requests_no_titlebar then
  --   return
  -- end

  -- buttons for the titlebar
  local buttons = {
    awful.button({}, 1, function()
      c:activate { context = "titlebar", action = "mouse_move" }
    end),
    awful.button({}, 3, function()
      c:activate { context = "titlebar", action = "mouse_resize" }
    end),
  }

  local n_titlebar = awful.titlebar(c, {
    size     = title_size,
    position = "top",
  })


  n_titlebar.widget = {
    {
      { -- Left

        {
          maximize(c),
          direction = "north",
          widget    = wibox.container.rotate
        },
        {
          sticky(c),
          direction = "north",
          widget    = wibox.container.rotate
        },
        {
          onTop(c),
          direction = "north",
          widget = wibox.container.rotate
        },
        {
          floating(c),
          direction = "north",
          widget = wibox.container.rotate
        },
        buttons = buttons,
        spacing = dpi(title_size / 4),
        layout  = wibox.layout.fixed.horizontal
      },
      {
        { -- Middle
          awful.titlebar.widget.iconwidget(c),
          { -- Title
            halign = "center",
            widget = awful.titlebar.widget.titlewidget(c)
          },
          buttons = buttons,
          layout  = wibox.layout.fixed.horizontal,
          spacing = 10,
        },
        widget = wibox.container.margin,
        margins = { left = dpi(40) }
      },
      { -- Right
        {
          close(c),
          direction = "north",
          widget    = wibox.container.rotate
        },
        buttons = buttons,
        layout  = wibox.layout.fixed.horizontal
      },
      spacing = dpi(title_size / 4),
      layout  = wibox.layout.align.horizontal
    },
    top    = dpi(title_size / 4),
    bottom = dpi(title_size / 4),
    left   = dpi(title_size / 3),
    right  = dpi(title_size / 2),
    widget = wibox.container.margin
  }

  -- awful.titlebar(c).widget = {
  --   { -- Left
  --     awful.titlebar.widget.iconwidget(c),
  --     buttons = buttons,
  --     layout  = wibox.layout.fixed.horizontal
  --   },
  --   { -- Middle
  --     { -- Title
  --       halign = "center",
  --       widget = awful.titlebar.widget.titlewidget(c)
  --     },
  --     buttons = buttons,
  --     layout  = wibox.layout.flex.horizontal
  --   },
  --   { -- Right
  --     awful.titlebar.widget.floatingbutton(c),
  --     awful.titlebar.widget.maximizedbutton(c),
  --     awful.titlebar.widget.stickybutton(c),
  --     awful.titlebar.widget.ontopbutton(c),
  --     awful.titlebar.widget.closebutton(c),
  --     layout = wibox.layout.fixed.horizontal()
  --   },
  --   layout = wibox.layout.align.horizontal
  -- }
end)
