local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local bling = require("modules.bling")
-- local machi = require("modules.layout-machi")
local helperClient = require("helpers.client")
local user_variables = require("user_variables")

local playerctl = bling.signal.playerctl.lib({
  update_on_activity = true,
})

--- Make key easier to call
--- ~~~~~~~~~~~~~~~~~~~~~~~
local mod = "Mod4"
local alt = "Mod1"
local ctrl = "Control"
local shift = "Shift"

--- Global key bindings
--- ~~~~~~~~~~~~~~~~~~~
awful.keyboard.append_global_keybindings({

  --- App
  --- ~~~
  -- Terminal
  awful.key({ mod }, "Return", function()
    awful.spawn(user_variables.cmd.terminal)
  end, { description = "open terminal", group = "app" }),
  awful.key({ mod, shift }, "Return", function()
    awful.spawn(user_variables.cmd.terminal_float)
  end, { description = "open floating terminal", group = "app" }),

  -- --- App launcher
  awful.key({ mod }, "d", function()
    awful.spawn.with_shell(user_variables.cmd.menu_launcher)
  end, { description = "open app launcher", group = "app" }),

  -- --- Code editor
  -- awful.key({ mod, shift }, "e", function()
  -- 	awful.spawn(user_variables.code_editor)
  -- end, { description = "open code editor", group = "app" }),

  -- --- File manager
  -- awful.key({ mod, shift }, "f", function()
  -- 	awful.spawn(user_variables.file_manager)
  -- end, { description = "open file manager", group = "app" }),

  -- --- Web browser
  -- awful.key({ mod, shift }, "w", function()
  -- 	awful.spawn(user_variables.web_browser)
  -- end, { description = "open web browser", group = "app" }),

  -- --- Music player
  -- awful.key({ mod, shift }, "s", function()
  -- 	awful.spawn.spawn(user_variables.music_player)
  -- end, { description = "open music client", group = "app" }),


  --- WM
  --- ~~
  --- Restart awesome
  awful.key({ mod, ctrl }, "r", awesome.restart, { description = "reload awesome", group = "WM" }),

  --- Quit awesome
  awful.key({ mod, ctrl }, "q", awesome.quit, { description = "quit awesome", group = "WM" }),

  --- Show help
  awful.key({ mod }, "F1", hotkeys_popup.show_help, { description = "show Help", group = "WM" }),

  --- Client
  --- ~~~~~~
  --- Focus client by direction
  awful.key({ mod }, "j", function()
    awful.client.focus.bydirection("up")
  end, { description = "focus up", group = "client" }),
  awful.key({ mod }, "k", function()
    awful.client.focus.bydirection("down")
  end, { description = "focus down", group = "client" }),
  awful.key({ mod }, "h", function()
    awful.client.focus.bydirection("left")
  end, { description = "focus left", group = "client" }),
  awful.key({ mod }, "l", function()
    awful.client.focus.bydirection("right")
  end, { description = "focus right", group = "client" }),

  awful.key({ mod }, "Up", function()
    awful.client.focus.bydirection("up")
  end, { description = "focus up", group = "client" }),
  awful.key({ mod }, "Down", function()
    awful.client.focus.bydirection("down")
  end, { description = "focus down", group = "client" }),
  awful.key({ mod }, "Left", function()
    awful.client.focus.bydirection("left")
  end, { description = "focus left", group = "client" }),
  awful.key({ mod }, "Right", function()
    awful.client.focus.bydirection("right")
  end, { description = "focus right", group = "client" }),

  --- Resize focused client
  awful.key({ mod, ctrl }, "j", function()
    helperClient.resize_client(client.focus, "up")
  end, { description = "resize to the up", group = "client" }),
  awful.key({ mod, ctrl }, "k", function()
    helperClient.resize_client(client.focus, "down")
  end, { description = "resize to the down", group = "client" }),
  awful.key({ mod, ctrl }, "h", function()
    helperClient.resize_client(client.focus, "left")
  end, { description = "resize to the left", group = "client" }),
  awful.key({ mod, ctrl }, "l", function()
    helperClient.resize_client(client.focus, "right")
  end, { description = "resize to the right", group = "client" }),

  awful.key({ mod, ctrl }, "Up", function()
    helperClient.resize_client(client.focus, "up")
  end, { description = "resize to the up", group = "client" }),
  awful.key({ mod, ctrl }, "Down", function()
    helperClient.resize_client(client.focus, "down")
  end, { description = "resize to the down", group = "client" }),
  awful.key({ mod, ctrl }, "Left", function()
    helperClient.resize_client(client.focus, "left")
  end, { description = "resize to the left", group = "client" }),
  awful.key({ mod, ctrl }, "Right", function()
    helperClient.resize_client(client.focus, "right")
  end, { description = "resize to the right", group = "client" }),

  --- Bling
  --- ~~~~~
  --- Add client to tabbed layout
  -- awful.key({ alt }, "a", function()
  -- 	bling.module.tabbed.pick_with_dmenu()
  -- end, { description = "pick client to add to tab group", group = "tabs" }),

  --- Remove client from tabbed layout
  -- awful.key({ alt }, "d", function()
  -- 	bling.module.tabbed.pop()
  -- end, { description = "remove focused client from tabbing group", group = "tabs" }),

  --- Cycle through client in tabbed layout
  -- awful.key({ alt }, "s", function()
  -- 	bling.module.tabbed.iter()
  -- end, { description = "iterate through tabbing group", group = "tabs" }),

  --- Hotkeys
  --- ~~~~~~~

  --- Brightness Control
  awful.key({}, "XF86MonBrightnessUp", function()
    awful.spawn(user_variables.cmd.brightness_up, false)
    awesome.emit_signal("widget::brightness")
    awesome.emit_signal("module::brightness_osd:show", true)
  end, { description = "increase brightness", group = "hotkeys" }),
  awful.key({}, "XF86MonBrightnessDown", function()
    awful.spawn(user_variables.cmd.brightness_down, false)
    awesome.emit_signal("widget::brightness")
    awesome.emit_signal("module::brightness_osd:show", true)
  end, { description = "decrease brightness", group = "hotkeys" }),

  --- Volume control
  awful.key({}, "XF86AudioRaiseVolume", function()
    awful.spawn(user_variables.cmd.volume_up, false)
    awesome.emit_signal("widget::volume")
    awesome.emit_signal("module::volume_osd:show", true)
  end, { description = "increase volume", group = "hotkeys" }),
  awful.key({}, "XF86AudioLowerVolume", function()
    awful.spawn(user_variables.cmd.volume_down, false)
    awesome.emit_signal("widget::volume")
    awesome.emit_signal("module::volume_osd:show", true)
  end, { description = "decrease volume", group = "hotkeys" }),
  awful.key({}, "XF86AudioMute", function()
    awful.spawn(user_variables.cmd.volume_mute, false)
  end, { description = "mute volume", group = "hotkeys" }),

  --- Music
  awful.key({}, "XF86AudioPlay", function()
    playerctl:play_pause()
  end, { description = "play pause music", group = "hotkeys" }),
  awful.key({}, "XF86AudioPrev", function()
    playerctl:previous()
  end, { description = "previous music", group = "hotkeys" }),
  awful.key({}, "XF86AudioNext", function()
    playerctl:next()
  end, { description = "next music", group = "hotkeys" }),

  --- Screenshots
  awful.key({}, "Print", function()
    awful.spawn.spawn(user_variables.cmd.menu_screenshot, function()
    end)
  end, { description = "open screenshot menu", group = "hotkeys" }),


  --- Lockscreen
  awful.key({ mod, alt }, "l", function()
    -- lock_screen_show()
  end, { description = "lock screen", group = "hotkeys" }),

  --- Exit screen
  awful.key({ mod }, "Escape", function()
    awesome.emit_signal("module::exit_screen:show")
  end, { description = "exit screen", group = "hotkeys" }),
})

--- Client key bindings
--- ~~~~~~~~~~~~~~~~~~~
client.connect_signal("request::default_keybindings", function()
  awful.keyboard.append_client_keybindings({
    -- Move or swap by direction
    awful.key({ mod, shift }, "j", function(c)
      helperClient.move_client(c, "up")
    end, { description = "move up", group = "client" }),
    awful.key({ mod, shift }, "k", function(c)
      helperClient.move_client(c, "down")
    end, { description = "move down", group = "client" }),
    awful.key({ mod, shift }, "h", function(c)
      helperClient.move_client(c, "left")
    end, { description = "move left", group = "client" }),
    awful.key({ mod, shift }, "l", function(c)
      helperClient.move_client(c, "right")
    end, { description = "move right", group = "client" }),

    awful.key({ mod, shift }, "Up", function(c)
      helperClient.move_client(c, "up")
    end, { description = "move up", group = "client" }),
    awful.key({ mod, shift }, "Down", function(c)
      helperClient.move_client(c, "down")
    end, { description = "move down", group = "client" }),
    awful.key({ mod, shift }, "Left", function(c)
      helperClient.move_client(c, "left")
    end, { description = "move left", group = "client" }),
    awful.key({ mod, shift }, "Right", function(c)
      helperClient.move_client(c, "right")
    end, { description = "move right", group = "client" }),

    --- Relative move client
    awful.key({ mod, shift, ctrl }, "j", function(c)
      c:relative_move(0, dpi(20), 0, 0)
    end, { description = "relative move up", group = "client" }),

    awful.key({ mod, shift, ctrl }, "k", function(c)
      c:relative_move(0, dpi(-20), 0, 0)
    end, { description = "relative move down", group = "client" }),

    awful.key({ mod, shift, ctrl }, "h", function(c)
      c:relative_move(dpi(-20), 0, 0, 0)
    end, { description = "relative move left", group = "client" }),

    awful.key({ mod, shift, ctrl }, "l", function(c)
      c:relative_move(dpi(20), 0, 0, 0)
    end, { description = "relative move right", group = "client" }),

    --- Toggle floating
    awful.key({ mod, ctrl }, "space", awful.client.floating.toggle, { description = "toggle floating", group = "client" }),

    --- Toggle fullscreen
    awful.key({ mod }, "f", function()
      client.focus.fullscreen = not client.focus.fullscreen
      client.focus:raise()
    end, { description = "toggle fullscreen", group = "client" }),

    --- Maximize windows
    awful.key({ mod }, "m", function(c)
      c.maximized = not c.maximized
    end, { description = "toggle maximize", group = "client" }),
    awful.key({ mod, ctrl }, "m", function(c)
      c.maximized_vertical = not c.maximized_vertical
      c:raise()
    end, { description = "(un)maximize vertically", group = "client" }),
    awful.key({ mod, shift }, "m", function(c)
      c.maximized_horizontal = not c.maximized_horizontal
      c:raise()
    end, { description = "(un)maximize horizontally", group = "client" }),

    --- Minimize windows
    awful.key({ mod }, "n", function(c)
      -- The client currently has the input focus, so it cannot be
      -- minimized, since minimized clients can't have the focus.
      c.minimized = true
    end, { description = "minimize", group = "client" }),

    --- Un-minimize windows
    awful.key({ mod, ctrl }, "n", function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        c:activate({ raise = true, context = "key.unminimize" })
      end
    end, { description = "restore minimized", group = "client" }),

    --- Keep on top
    awful.key({ mod }, "p", function(c)
      c.ontop = not c.ontop
    end, { description = "toggle on top", group = "client" }),

    --- Sticky
    awful.key({ mod, shift }, "p", function(c)
      c.sticky = not c.sticky
    end, { description = "toggle sticky", group = "client" }),

    --- Close window
    awful.key({ mod }, "q", function()
      client.focus:kill()
    end, { description = "kill client", group = "client" }),

    --- Center window
    awful.key({ mod }, "c", function()
      awful.placement.centered(c, { honor_workarea = true, honor_padding = true })
    end, { description = "centered", group = "client" }),

    --- Window switcher
    awful.key({ alt }, "Tab", function()
      awful.spawn.spawn(user_variables.cmd.menu_window)
      awesome.emit_signal("window_switcher::turn_on")
    end, { description = "switch windows", group = "client" }),


    -- awful.key({ mod, }, "Tab", function()
    -- 	awful.client.focus.history.previous()
    -- 	if client.focus then
    -- 		client.focus:raise()
    -- 	end
    -- end, { description = "go back", group = "client" })


    awful.key({ mod }, "Tab", function()
      awful.client.focus.byidx(1)
      if client.focus then client.focus:raise() end
    end, { description = "alt-tab equivalent" }),
    awful.key({ mod, shift }, "Tab", function()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
    end, { description = "alt-tab equivalent" })

  })
end)

--- Layout
--- ~~~~~~
awful.keyboard.append_global_keybindings({
  --- Set tilling layout
  awful.key({ mod }, "s", function()
    awful.layout.set(awful.layout.suit.tile)
  end, { description = "set tile layout", group = "layout" }),

  --- Set floating layout
  awful.key({ mod, shift }, "s", function()
    awful.layout.set(awful.layout.suit.floating)
  end, { description = "set floating layout", group = "layout" }),

  --- Number of columns
  awful.key({ mod, alt }, "j", function()
    awful.tag.incncol(1, nil, true)
  end, { description = "increase the number of columns", group = "layout" }),
  awful.key({ mod, alt }, "k", function()
    awful.tag.incncol(-1, nil, true)
  end, { description = "decrease the number of columns", group = "layout" }),
  awful.key({ mod, alt }, "Up", function()
    awful.tag.incncol(1, nil, true)
  end, { description = "increase the number of columns", group = "layout" }),
  awful.key({ mod, alt }, "Down", function()
    awful.tag.incncol(-1, nil, true)
  end, { description = "decrease the number of columns", group = "layout" }),

  --- On the fly padding change
  awful.key({ mod, shift }, "=", function()
    helperClient.resize_padding(5)
  end, { description = "add padding", group = "layout" }),
  awful.key({ mod, shift }, "-", function()
    helperClient.resize_padding(-5)
  end, { description = "subtract padding", group = "layout" }),

  --- On the fly useless gaps change
  awful.key({ mod }, "=", function()
    helperClient.resize_gaps(5)
  end, { description = "add gaps", group = "layout" }),

  awful.key({ mod }, "-", function()
    helperClient.resize_gaps(-5)
  end, { description = "subtract gaps", group = "layout" }),
})

--- Move through workspaces
--- ~~~~~~~~~~~~~~~~~~~~~~~
awful.keyboard.append_global_keybindings({
  awful.key({ mod, alt }, "Left", awful.tag.viewprev, { description = "view previous", group = "tags" }),
  awful.key({ mod, alt }, "Right", awful.tag.viewnext, { description = "view next", group = "tags" }),
  awful.key({
    modifiers = { mod },
    keygroup = "numrow",
    description = "only view tag",
    group = "tags",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end,
  }),
  awful.key({
    modifiers = { mod, ctrl },
    keygroup = "numrow",
    description = "toggle tag",
    group = "tags",
    on_press = function(index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        awful.tag.viewtoggle(tag)
      end
    end,
  }),
  awful.key({
    modifiers = { mod, shift },
    keygroup = "numrow",
    description = "move focused client to tag",
    group = "tags",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end,
  }),
})


--- Mouse bindings on desktop
--- ~~~~~~~~~~~~~~~~~~~~~~~~~
-- awful.mouse.append_global_mousebindings({
-- 	--- Right click
-- 	awful.button({
-- 		modifiers = {},
-- 		button = 3,
-- 		on_press = function()
-- 			main_menu:toggle()
-- 		end,
-- 	}),
-- })

--- Mouse buttons on the client
--- ~~~~~~~~~~~~~~~~~~~~~~~~~~~
client.connect_signal("request::default_mousebindings", function()
  awful.mouse.append_client_mousebindings({
    awful.button({}, 1, function(c)
      c:activate({ context = "mouse_click" })
    end),
    awful.button({ mod }, 1, function(c)
      c:activate({ context = "mouse_click", action = "mouse_move" })
    end),
    awful.button({ mod }, 3, function(c)
      c:activate({ context = "mouse_click", action = "mouse_resize" })
    end),
  })
end)
