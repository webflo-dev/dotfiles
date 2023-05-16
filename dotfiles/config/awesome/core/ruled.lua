local awful = require("awful")
local ruled = require("ruled")
local helperClient = require("helpers.client")

--- Get screen geometry
local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

ruled.client.connect_signal("request::rules", function()
  --- Global
  ruled.client.append_rule({
    id = "global",
    rule = {},
    properties = {
      raise = true,
      size_hints_honor = false,
      honor_workarea = true,
      honor_padding = true,
      -- screen = awful.screen.preferred,
      screen = awful.screen.focused,
      focus = awful.client.focus.filter,
      -- titlebars_enabled = beautiful.titlebar_enabled,
      placement = awful.placement.no_overlap + awful.placement.no_offscreen,
    },
  })


  -- Add titlebars to normal clients and dialogs
  ruled.client.append_rule {
    id         = "titlebars",
    rule_any   = { type = { "normal", "dialog" } },
    properties = { titlebars_enabled = true }
  }


  --- Tasklist order
  ruled.client.append_rule({
    id = "tasklist_order",
    rule = {},
    properties = {},
    callback = awful.client.setslave,
  })

  --- Titlebar rules
  ruled.client.append_rule({
    id = "titlebars",
    rule_any = {
      class = {
        "Spotify",
        "Org.gnome.Nautilus",
        "Peek",
      },
    },
    properties = {
      titlebars_enabled = false,
    },
  })

  --- Float
  ruled.client.append_rule({
    id = "floating",
    rule_any = {
      instance = {
        "Devtools", --- Firefox devtools
        "pulsemixer",
      },
      class = {
        "Lxappearance",
        "Nm-connection-editor",
        "Nvidia-settings",
        "floating_terminal",
      },
      name = {
        "Event Tester", -- xev
      },
      role = {
        "AlarmWindow",
        "pop-up",
        "GtkFileChooserDialog",
        "conversation",
      },
      type = {
        "dialog",
      },
    },
    properties = { floating = true, placement = helperClient.centered_client_placement },
  })

  ruled.client.append_rule({
    rule_any = {
      name = {
        "Picture in picture",
      }
    },
    properties = {
      floating       = true,
      raise          = true,
      focus          = false,
      honor_workarea = true,
      honor_padding  = true,
      placement      = awful.placement.bottom_right + awful.placement.no_offscreen,
      width          = 640,
      height         = 480,
    },
  })

  --- Centered
  ruled.client.append_rule({
    id = "centered",
    rule_any = {
      type = {
        "dialog",
      },
      class = {
        --- "discord",
      },
      role = {
        "GtkFileChooserDialog",
        "conversation",
      },
    },
    properties = { placement = helperClient.centered_client_placement },
  })

  --- Music clients (usually a terminal running ncmpcpp)
  -- ruled.client.append_rule({
  --   rule_any = {
  --     class = {
  --       "spotify",
  --     },
  --     instance = {
  --       "spotify",
  --     },
  --   },
  --   properties = {
  --     floating = true,
  --     width = screen_width * 0.40,
  --     height = screen_height * 0.42,
  --     placement = helpers.client.centered_client_placement,
  --   },
  -- })

  --- Image viewers
  ruled.client.append_rule({
    rule_any = {
      class = {
        "feh",
        "imv",
      },
    },
    properties = {
      floating = true,
      width = screen_width * 0.7,
      height = screen_height * 0.75,
    },
    callback = function(c)
      awful.placement.centered(c, { honor_padding = true, honor_workarea = true })
    end,
  })
end)
