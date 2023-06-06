local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")

local controls = require("themes.spring.widgets.playerctl.playerctl-controls")
local player_icon = require("themes.spring.widgets.playerctl.playerctl-icon")
local player_image = require("themes.spring.widgets.playerctl.playerctl-image")

local function player(args)
  local playerctl = args.playerctl
  local metadata = args.metadata
  local player_name = args.player_name

  local control_prev, control_play_pause, control_next = controls(playerctl, player_name)
  local player_icon = player_icon(player_name, metadata.icon_path)

  local player_image = player_image(player_name, metadata.art_path)

  local player = wibox.widget({
    {
      {
        {
          {
            player_image,
            margins = dpi(8),
            layout = wibox.container.margin,
          },
          valign = "center",
          layout = wibox.container.place,
        },
        {
          {
            {
              player_icon,
              {
                markup = helperUI.pango2(metadata.artist, { weight = "bold" }),
                font = beautiful.fonts.system,
                widget = wibox.widget.textbox,
              },
              layout = wibox.layout.fixed.horizontal,
            },
            {
              {
                markup = metadata.title,
                font = beautiful.fonts.system,
                widget = wibox.widget.textbox,
              },
              widget = wibox.container.margin,
              margins = { left = dpi(8) },
            },
            forced_width = dpi(300),
            layout = wibox.layout.fixed.vertical,
            spacing = dpi(3),
          },
          valign = "center",
          layout = wibox.container.place,
        },
        {
          {
            control_prev,
            control_play_pause,
            control_next,
            layout = wibox.layout.align.horizontal,
          },
          forced_width = 90,
          valign = "center",
          haligh = "center",
          layout = wibox.container.place,
        },
        spacing = dpi(8),
        layout = wibox.layout.align.horizontal,
      },
      margins = dpi(8),
      layout = wibox.container.margin,
    },
    bg = beautiful.bg_normal,
    widget = wibox.container.background,
  })
  return player
end

return player
