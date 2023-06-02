local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local helperIcon = require("helpers.icon")
local base = require("themes.spring.widgets.base")

local playerctl = require("signals").playerctl

local function debug(prefix, data, key)
	require("gears.debug").print_warning(prefix .. " => " .. require("gears.debug").dump_return(data, key, 3))
end

local widget_thumbnail = base.svg(beautiful.svg.music, beautiful.accent_color)
widget_thumbnail.visible = false

local widget_icon_player = base.svg(beautiful.svg.music)

local widget_text = wibox.widget({
	widget = wibox.widget.textbox,
	markup = "---",
	valign = "center",
	font = beautiful.fonts.system,
})

local function clickable_control(widget, on_click)
	widget:connect_signal("mouse::enter", function()
		local w = mouse.current_wibox
		if w then
			w.cursor = "hand2"
		end
		widget:change_fill(beautiful.accent_color)
	end)

	widget:connect_signal("mouse::leave", function()
		local w = mouse.current_wibox
		if w then
			w.cursor = "left_ptr"
		end
		widget:change_fill(beautiful.fg_normal)
	end)

	widget:connect_signal("button::press", function()
		on_click()
	end)

	return widget
end

local widget_control_play = clickable_control(base.svg(beautiful.svg.play, beautiful.fg_normal), function()
	playerctl:play_pause()
end)
local widget_control_backward = clickable_control(base.svg(beautiful.svg.backward, beautiful.fg_normal), function()
	playerctl:previous()
end)
local widget_control_forward = clickable_control(base.svg(beautiful.svg.forward, beautiful.fg_normal), function()
	playerctl:next()
end)

local widget_controls = wibox.widget({
	widget = wibox.container.margin,
	layout = wibox.layout.fixed.horizontal,
	widget_control_backward,
	widget_control_play,
	widget_control_forward,
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
		shape = helperUI.rounded_shape(),
		bg = beautiful.bg_normal,
		border_color = beautiful.bg_focus,
		border_width = dpi(2),
	},
	widget = wibox.container.margin,
	margins = { left = dpi(100) },
})

local players = {}
local active_player = nil

local function update_info(player_name)
	local metadata = players[player_name]
	if not metadata then
		return
	end

	if metadata.icon_path ~= nil and metadata.icon_path ~= "" then
		widget_icon_player:change_image(metadata.icon_path)
	else
		widget_icon_player:change_image(beautiful.svg.music)
	end

	if metadata.art_path ~= "" then
		widget_thumbnail.visible = true
		widget_thumbnail:change_image(metadata.art_path)
	else
		widget_thumbnail.visible = false
	end

	local artist = helperUI.pango2(metadata.artist, { weight = "bold" })
	local title = helperUI.pango2(metadata.title, { weight = "light" })
	widget_text:set_markup(string.format("%s - %s", artist, title))
end

awesome.connect_signal("playerctl::metadata", function(metadata, new, player_name)
	widget_controls.visible = true

	local existing_player = players[player_name]
	if existing_player == nil then
		local icon_path = helperIcon.search_apps_icon(player_name)
		if icon_path ~= nil then
			widget_icon_player:change_image(icon_path)
		else
			widget_icon_player:change_image(beautiful.svg.music)
		end
		metadata["icon_path"] = icon_path
		players[player_name] = metadata
	else
		players[player_name] = gears.table.crush(existing_player, metadata)
	end

	active_player = player_name

	update_info(player_name)
end)

awesome.connect_signal("playerctl::playback_status", function(status, player_name)
	widget_controls.visible = true

	if active_player ~= player_name then
		update_info(player_name)
		active_player = player_name
	end

	if status == true then
		widget_control_play:change_image(beautiful.svg.pause)
	else
		widget_control_play:change_image(beautiful.svg.play)
	end
end)

local player_list = wibox.widget({
	widget = wibox.container.margin,
	homogeneous = true,
	spacing = 5,
	layout = wibox.layout.grid,
	forced_num_cols = 3,
	forced_num_rows = 3,
})
player_list:add_widget_at({
	widget = wibox.widget.imagebox,
	image = beautiful.svg.music,
	forced_height = dpi(30),
	forced_width = dpi(30),
}, 1, 1, 3, 1)
player_list:add_widget_at({
	widget = wibox.widget.textbox,
	text = "Artist",
}, 1, 2, 1, 2)
player_list:add_widget_at({
	widget = wibox.widget.textbox,
	text = "Title",
}, 2, 2, 1, 2)
local player_list_popup = awful.popup({
	preferred_anchors = "middle",
	border_color = beautiful.border_color,
	border_width = beautiful.border_width,
	visible = false,
	ontop = true,
	hide_on_right_click = true,
	widget = {
		widget = wibox.container.margin,
		layout = wibox.layout.fixed.vertical,
		player_list,
	},
})
player_list_popup:bind_to_widget(widget_text)

return widget
