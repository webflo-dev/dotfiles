local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local utils = require("utils.widget")
local ui = require("ui.utils")
local tpl = require("ui.templates")

local daemon = require("daemons.playerctl")

local player_widget = require(... .. ".player")

local widget_thumbnail = wibox.widget(tpl.svg({ image = beautiful.svg.music, color = beautiful.accent_color }))
widget_thumbnail.visible = false
widget_thumbnail.art_path = nil

local widget_icon_player = wibox.widget(tpl.svg({ image = beautiful.svg.music, color = beautiful.accent_color }))
widget_icon_player.icon_path = nil

local widget_text = wibox.widget({
	widget = wibox.widget.textbox,
	markup = "---",
	valign = "center",
	font = beautiful.fonts.system,
})

local widget_control_play = wibox.widget(tpl.svg({ image = beautiful.svg.play, color = beautiful.fg_normal }))
widget_control_play.playback_status = nil
widget_control_play:connect_signal("mouse::enter", function(self)
	ui.mouse_hover_cursor(true)
	self:get_children_by_id("svg")[1].stylesheet = ui.stylesheet_color(beautiful.accent_color)
end)
widget_control_play:connect_signal("mouse::leave", function(self)
	ui.mouse_hover_cursor(false)
	self:get_children_by_id("svg")[1].stylesheet = ui.stylesheet_color(beautiful.fg_normal)
end)
widget_control_play:connect_signal("button::press", function()
	daemon:play_pause()
end)

local widget_control_backward = wibox.widget(tpl.svg({ image = beautiful.svg.backward, color = beautiful.fg_normal }))
widget_control_backward:connect_signal("mouse::enter", function(self)
	ui.mouse_hover_cursor(true)
	self:get_children_by_id("svg")[1].stylesheet = ui.stylesheet_color(beautiful.accent_color)
end)
widget_control_backward:connect_signal("mouse::leave", function(self)
	ui.mouse_hover_cursor(false)
	self:get_children_by_id("svg")[1].stylesheet = ui.stylesheet_color(beautiful.fg_normal)
end)
widget_control_backward:connect_signal("button::press", function()
	daemon:previous()
end)

local widget_control_forward = wibox.widget(tpl.svg({ image = beautiful.svg.forward, color = beautiful.fg_normal }))
widget_control_forward:connect_signal("mouse::enter", function(self)
	ui.mouse_hover_cursor(true)
	self:get_children_by_id("svg")[1].stylesheet = ui.stylesheet_color(beautiful.accent_color)
end)
widget_control_forward:connect_signal("mouse::leave", function(self)
	ui.mouse_hover_cursor(false)
	self:get_children_by_id("svg")[1].stylesheet = ui.stylesheet_color(beautiful.fg_normal)
end)
widget_control_forward:connect_signal("button::press", function()
	daemon:next()
end)

local widget_controls = wibox.widget({
	widget = wibox.container.margin,
	layout = wibox.layout.fixed.horizontal,
	widget_control_backward,
	widget_control_play,
	widget_control_forward,
	spacing = dpi(3),
})
widget_controls.visible = false

local widget = wibox.widget({
	{
		{
			{
				widget_icon_player,
				widget_thumbnail,
				widget_controls,
				widget_text,
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(10),
			},
			widget = wibox.container.margin,
			margins = {
				left = dpi(10),
				right = dpi(10),
			},
		},
		widget = wibox.container.background,
		shape = ui.rounded_rect,
		bg = beautiful.bg_normal,
		border_color = beautiful.bg_focus,
		border_width = dpi(2),
	},
	widget = wibox.container.margin,
	margins = { left = dpi(100) },
})

local function update_info(metadata)
	if metadata.icon_path ~= nil and metadata.icon_path ~= "" then
		if metadata.icon_path ~= widget_icon_player.icon_path then
			widget_icon_player:get_children_by_id("svg")[1].image = metadata.icon_path
			widget_icon_player.icon = metadata.icon_path
		end
	else
		if widget_icon_player.icon ~= nil then
			widget_icon_player:get_children_by_id("svg")[1].image = beautiful.svg.music
			widget_icon_player.icon = nil
		end
	end

	if metadata.art_path ~= nil and metadata.art_path ~= "" then
		if metadata.art_path ~= widget_thumbnail.art_path then
			widget_thumbnail.art_path = metadata.art_path
			widget_thumbnail.visible = true
			widget_thumbnail:get_children_by_id("svg")[1].image = metadata.art_path
		end
	else
		widget_thumbnail.visible = false
	end

	widget_control_play.playback_status = metadata.status
	if metadata.status == "PLAYING" then
		widget_control_play:get_children_by_id("svg")[1].image = beautiful.svg.pause
	else
		widget_control_play:get_children_by_id("svg")[1].image = beautiful.svg.play
	end

	local artist = ui.pango(metadata.artist, { weight = "bold" })
	local title = ui.pango(metadata.title, { weight = "light" })
	widget_text:set_markup(string.format("%s - %s", artist, title))
end

-- Player list
local player_widget_list = wibox.widget({
	layout = wibox.layout.fixed.vertical,
})

local popup = awful.popup(tpl.popup({
	widget = player_widget_list,
}))

widget_text:connect_signal("button::press", function()
	if popup.visible then
		popup.visible = not popup.visible
	else
		popup:move_next_to(mouse.current_widget_geometry, "left")
	end
end)

daemon:connect_signal("metadata", function(_, metadata)
	widget_controls.visible = true

	-- Current  player
	update_info(metadata)

	-- Player list
	local existing_widget = utils.find_by_id(player_widget_list.children, metadata.player_instance)
	if not existing_widget then
		local new_widget = player_widget(metadata)
		new_widget.id = metadata.player_instance
		player_widget_list:insert(1, new_widget)
	else
		existing_widget:update_info(metadata)
	end
end)

daemon:connect_signal("player-vanished", function(_, player_instance)
	local index = utils.index_of(player_widget_list.children, player_instance)
	if index ~= nil then
		player_widget_list:remove(index)
	end

	if player_widget_list.children == nil or #player_widget_list.children == 0 then
		widget.visible = false
	end
end)

return widget
