local wibox = require("wibox")

local utils = require("utils.widget")
local tpl = require("ui.templates")
local daemon = require("daemons.network")

local device_widget = require(... .. ".device")

local widget = wibox.widget(tpl.wibar_module({
	layout = wibox.layout.fixed.horizontal,
	id = "list",
}))

daemon:get_devices_info(function(data)
	local w_devices = widget:get_children_by_id("list")[1]
	for _, value in ipairs(data) do
		local w_device = device_widget(value)
		w_devices:add(w_device)
		w_device:update_info(value)
	end
end)

daemon:connect_signal("UPDATE", function(_, data)
	local w_devices = widget:get_children_by_id("list")[1]
	local w_device = utils.find_by_id(w_devices.children, data.device)

	if w_device then
		w_device:update_info(data)
	else
		-- device = build_device_widget(data)
		-- devices:add(device)
		-- device:update_info(data)
	end
end)

return widget
