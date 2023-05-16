local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local function get_wallpaper_path(screen_dimension)
	if beautiful.wallpaper ~= nil then
		return beautiful.theme_dir .. beautiful.wallpaper
	else
		return beautiful.theme_dir .. "wallpaper-" .. screen_dimension .. ".jpg"
	end
end

screen.connect_signal("request::wallpaper", function(s)
	awful.spawn.easy_async_with_shell("xdpyinfo | awk '/dimensions/{print $2}'", function(stdout)
		awful.wallpaper({
			screen = s,
			widget = {
				-- {
				image = get_wallpaper_path(stdout:sub(1, -2)),
				upscale = true,
				downscale = true,
				horizontal_fit_policy = "fit",
				vertical_fit_policy = "fit",
				widget = wibox.widget.imagebox,
			},
		})
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
