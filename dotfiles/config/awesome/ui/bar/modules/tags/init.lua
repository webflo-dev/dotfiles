local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local workspaces = require(... .. ".workspaces")
local layouts = require(... .. ".layouts")

return function(s)
	return {
		workspaces(s),
		layouts(s),
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(10),
	}
end
