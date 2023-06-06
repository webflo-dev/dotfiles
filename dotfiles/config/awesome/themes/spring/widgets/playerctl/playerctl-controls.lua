local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local make_widget_clickable = require("themes.spring.widgets.playerctl.playerctl-make-widget-clickable")
local base = require("themes.spring.widgets.base")

local function force_size(widget)
  widget.forced_height = dpi(30)
  widget.forced_width = dpi(30)
  return widget
end

local function playerctl_controls(playerctl, player_name)
  local control_play_pause = make_widget_clickable(force_size(base.svg(beautiful.svg.play, beautiful.colors.light)),
    beautiful.accent_color,
    beautiful.fg_normal, function()
      playerctl:play_pause(player_name)
    end)


  local control_previous = make_widget_clickable(force_size(base.svg(beautiful.svg.backward, beautiful.colors.light)),
    beautiful
    .accent_color, beautiful.fg_normal, function()
      playerctl:previous(player_name)
    end)

  local control_next = make_widget_clickable(force_size(base.svg(beautiful.svg.forward, beautiful.colors.light)),
    beautiful.accent_color,
    beautiful.fg_normal, function()
      playerctl:next(player_name)
    end)

  return control_previous, control_play_pause, control_next
end

return playerctl_controls
