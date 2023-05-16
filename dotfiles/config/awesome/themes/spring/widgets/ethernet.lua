local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

local ethernet_icon = wibox.widget({
	widget = wibox.widget.textbox,
	markup = "ETH",
	align = "center",
	valign = "center",
	-- forced_width = dpi(20),
	font = helperUI.font(nil, beautiful.fonts.fontawesome),
})

local ethernet_icon_block = wibox.widget({
	ethernet_icon,
	widget = wibox.container.background,
})

local default_fg = ethernet_icon_block.fg

-- local icons = {
-- 	ethernet_connected = beautiful.icons.ethernet,
-- 	ethernet_connecting = beautiful.icons.ethernet_connecting,
-- 	ethernet_disconnected = beautiful.icons.ethernet_disconnected,
-- }

-- awesome.connect_signal("network::update", function(devices)
-- 	local text = ""
-- 	for _, device in ipairs(devices) do
-- 		if device.type == "ethernet" then
-- 			local key = device.type .. "_" .. device.state
-- 			local icon = icons[key]
-- 			local icon_color = (device.state == "disconnected" and beautiful.red) or beautiful.fg_normal
-- 			local device_text = helperUI.pango(icon, icon_color, nil, beautiful.fonts.fontawesome)
-- 			text = text .. device_text .. " "
-- 		end
-- 		ethernet_icon:set_markup(text:sub(1, -2))
-- 	end
-- end)

return ethernet_icon_block
