local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

local wifi_icon = wibox.widget({
	widget = wibox.widget.textbox,
	markup = helperUI.pango2("WIFI", { foreground = beautiful.accent_color }),
	align = "center",
	valign = "center",
	-- forced_width = dpi(20),
})

local wifi_icon_block = wibox.widget({
	wifi_icon,
	widget = wibox.container.background,
})

local default_fg = wifi_icon_block.fg

-- local icons = {
-- 	wifi_connected = beautiful.icons.wifi,
-- 	wifi_connecting = beautiful.icons.wifi_connecting,
-- 	wifi_disconnected = beautiful.icons.wifi_disconnected,
-- }
--
-- awesome.connect_signal("network::update", function(devices)
-- 	local text = ""
-- 	for _, device in ipairs(devices) do
-- 		if device.type == "wifi" then
-- 			local key = device.type .. "_" .. device.state
-- 			local icon = icons[key]
-- 			local icon_color = (device.state == "disconnected" and beautiful.red) or beautiful.fg_normal
-- 			local device_text = helperUI.pango(icon, icon_color, nil, beautiful.fonts.fontawesome)
-- 			text = text .. device_text .. " "
-- 		end
-- 		wifi_icon:set_markup(text:sub(1, -2))
-- 	end
-- end)

return wifi_icon_block
