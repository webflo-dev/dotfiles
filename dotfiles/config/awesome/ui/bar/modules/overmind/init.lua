local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local utils = require("utils.widget")
local ui = require("ui.utils")
local tpl = require("ui.templates")

local daemon = require("daemons.overmind")

local process_widget = require(... .. ".process")

local widget = wibox.widget(tpl.wibar_module(tpl.svg({
	image = beautiful.svg.rocket,
	color = beautiful.colors.light,
	id = "w_icon",
})))

local process_widget_list = wibox.widget({
	layout = wibox.layout.fixed.vertical,
})

local popup = awful.popup(tpl.popup({
	widget = {
		spacing = dpi(5),
		widget = wibox.container.background,
		{
			margins = dpi(8),
			layout = wibox.container.margin,
			process_widget_list,
		},
	},
}))

widget:connect_signal("button::press", function()
	if popup.visible then
		popup.visible = not popup.visible
	else
		popup:move_next_to(mouse.current_widget_geometry)
	end
end)

daemon:connect_signal("update::process", function(_, process)
	local existing_widget = utils.find_by_id(process_widget_list.children, process.name)
	if not existing_widget then
		local new_widget = process_widget(process)
		process_widget_list:add(new_widget)
		new_widget:update_info(process)
		new_widget:connect_signal("request_popup_visibility", function(_, args)
			popup.visible = args.visible
		end)
	else
		existing_widget:update_info(process)
	end
end)

daemon:connect_signal("update::global", function(_, status)
	local color = beautiful.colors.light
	if status == "running" then
		color = beautiful.colors.green
	elseif status == "incomplete" then
		color = beautiful.colors.orange
	elseif status == "stopped" then
		color = beautiful.colors.red
	end
	widget:get_children_by_id("w_icon")[1].stylesheet = ui.stylesheet_color(color)
end)

return widget
