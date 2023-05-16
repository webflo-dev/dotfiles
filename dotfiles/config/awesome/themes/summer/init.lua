local awful = require "awful"
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")

local theme = require("themes.summer.theme")
beautiful.init(theme)

require(... .. ".bar")
require(... .. ".notification")
require(... .. ".decorations")


-- Rounded corners
-- client.connect_signal("request::manage", function(c)
--   if c.fullscreen or c.maximized then
--     c.shape = function(cr, w, h) gears.shape.rectangle(cr, w, h) end
--   else
--     c.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 12) end
--   end
-- end)

-- Disable Rounded Corners when fullscreen or maximized
-- local function disable_rounded(c)
--   if c.fullscreen or c.maximized then
--     c.shape = function(cr, w, h) gears.shape.rectangle(cr, w, h) end
--   else
--     c.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 15) end
--   end
-- end

-- client.connect_signal("property::maximized", function(c)
--   disable_rounded(c)
-- end)

-- client.connect_signal("property::fullscreen", function(c)
--   disable_rounded(c)
-- end)

-- Wallpaper
screen.connect_signal("request::wallpaper", function(s)
  awful.spawn.easy_async_with_shell("xdpyinfo | awk '/dimensions/{print $2}'", function(stdout)
    local theme_dir = gears.filesystem.get_configuration_dir() .. "themes/summer/"
    awful.wallpaper {
      screen = s,
      widget = {
        -- {
        image                 = theme_dir .. "wallpaper-" .. stdout:sub(1, -2) .. ".jpg",
        upscale               = true,
        downscale             = true,
        horizontal_fit_policy = "fit",
        vertical_fit_policy   = "fit",
        widget                = wibox.widget.imagebox,
      },
    }
    -- awful.wallpaper {
    --   screen = s,
    --   widget = {
    --     {
    --       image     = theme_dir .. "wallpaper-" .. stdout:sub(1, -2) .. ".jpg",
    --       upscale   = true,
    --       downscale = true,
    --       widget    = wibox.widget.imagebox,
    --     },
    --     valign = "center",
    --     halign = "center",
    --     tiled  = false,
    --     widget = wibox.container.tile,
    --   }
    -- }
  end)
end)
