local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local daemon = require("daemons.audio")

local tpl = require("ui.templates")

local popup_widget = wibox.widget({
	{
		{
			id = "w_content",
			layout = wibox.layout.align.horizontal,
			tpl.svg({
				image = beautiful.svg.volume_mute,
				color = beautiful.colors.sky,
				id = "w_image",
			}),
			{
				text = "---",
				align = "center",
				valign = "center",
				font = beautiful.fonts.monospace,
				widget = wibox.widget.textbox,
				id = "w_text",
			},
		},
		left = dpi(20),
		right = dpi(20),
		widget = wibox.container.margin,
	},
	border_width = beautiful.border_width,
	border_color = beautiful.colors.sky,
	bg = beautiful.bg_normal,
	shape = gears.shape.rounded_rect,
	widget = wibox.container.background,
})

local popup = wibox({
	visible = false,
	ontop = true,
	width = dpi(250),
	height = dpi(80),
	widget = popup_widget,
})

awful.placement.centered(popup, {
	honor_workarea = true,
	honor_padding = true,
})

local timer = gears.timer({
	timeout = 2,
	call_now = false,
	autostart = false,
	single_shot = true,
	callback = function()
		popup.visible = false
	end,
})

local previous_device = {
	sink = {},
	source = {},
}

daemon:connect_signal("sink::default::updated", function(_, device)
	if device.default == false then
		return
	end

	local w_image = popup_widget:get_children_by_id("w_image")[1]
	local w_text = popup_widget:get_children_by_id("w_text")[1]

	if device.mute == true then
		w_image.image = beautiful.svg.volume_mute
		w_text.text = "Muted"
	else
		w_image.image = beautiful.svg.volume
		w_text.text = device.volume .. "%"
	end

	if (previous_device.sink.volume == device.volume) and (previous_device.sink.mute == device.mute) then
		return
	end

	if not popup.visible then
		popup.visible = true

		timer:start()
	else
		timer:again()
	end

	previous_device.sink = gears.table.clone(device)
end)
