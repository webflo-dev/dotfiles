local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")

local base = require("themes.spring.widgets.base")

local function player_icon(player_name, icon_path)
  local player_icon = nil
  if icon_path ~= nil and icon_path ~= "" then
    player_icon = base.svg(icon_path, beautiful.colors.light)
    player_icon.forced_height = dpi(30)
    player_icon.forced_width = dpi(30)
  else
    player_icon = { widget = wibox.widget.textbox, markup = helperUI.pango2(player_name, { style = "italic" }) }
  end
  return player_icon
end

return player_icon
