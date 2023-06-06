local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")

local base = require("themes.spring.widgets.base")

local function player_image(player_name, art_path)
  local image_widget = nil
  if art_path ~= nil and art_path ~= "" then
    image_widget = {
      widget = wibox.widget.imagebox,
      clip_shape = helperUI.rounded_shape(),
      forced_height = dpi(85),
      forced_width = dpi(85),
      image = art_path,
    }
  else
    image_widget = base.svg(beautiful.svg.music, beautiful.accent_color)
    image_widget.forced_width = dpi(85)
    image_widget.forced_height = dpi(85)
  end

  return image_widget
end

return player_image
