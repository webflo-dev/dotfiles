local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local helperIcon = require("helpers.icon")
local base = require("themes.spring.widgets.base")

local playerctl = require("signals.playerctl_wip")()

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

local function update_info(player_name, metadata)
	if metadata.icon_path ~= nil and metadata.icon_path ~= "" then
		widget_icon_player:change_image(metadata.icon_path)
	else
		widget_icon_player:change_image(beautiful.svg.music)
	end

	if metadata.art_path ~= nil and metadata.art_path ~= "" then
		widget_thumbnail.visible = true
		widget_thumbnail:change_image(metadata.art_path)
	else
		widget_thumbnail.visible = false
	end

	local artist = helperUI.pango2(metadata.artist, { weight = "bold" })
	local title = helperUI.pango2(metadata.title, { weight = "light" })
	widget_text:set_markup(string.format("%s - %s", artist, title))
end

awesome.connect_signal("playerctl2::metadata", function(player_name, metadata)
	widget_controls.visible = true

	debug("playerctl2::metadata", metadata)


	update_info(player_name, metadata)
end)

awesome.connect_signal("playerctl2::playback_status", function(player_name, metadata)
	widget_controls.visible = true

	debug("playerctl2::metadata (playback_status)", metadata)

	if metadata.is_playing == true then
		widget_control_play:change_image(beautiful.svg.pause)
	else
		widget_control_play:change_image(beautiful.svg.play)
	end
end)

local popup = awful.popup({
	preferred_anchors = "middle",
	ontop = true,
	visible = false,
	shape = gears.shape.rounded_rect,
	border_width = beautiful.border_width,
	border_color = beautiful.colors.sky,
	-- hide_on_right_click = true,
	offset = { y = 5 },
	widget = {},
})

local function create_player(player_name, metadata)
	-- local function toggle_play_pause(_player_name, status)
	-- 	if player_name ~= _player_name then
	-- 		return
	-- 	end

	-- 	if status == true then
	-- 		play_pause:change_image(beautiful.svg.pause)
	-- 	else
	-- 		play_pause:change_image(beautiful.svg.play)
	-- 	end
	-- end

	-- awesome.connect_signal("playerctl2::playback_status", toggle_play_pause)

	local player = require("themes.spring.widgets.playerctl.playerctl-player")({
		player_name = player_name,
		metadata = metadata,
		playerctl = playerctl
	})
	return player
end

local function rebuild_popup()
	local rows = {
		layout = wibox.layout.fixed.vertical,
	}


	for player_name, metadata in pairs(playerctl:get_all_metadata()) do
		table.insert(rows, create_player(player_name, metadata))
	end
	popup:setup(rows)
end

widget_text:connect_signal("button::press", function()
	if popup.visible then
		popup.visible = not popup.visible
	else
		rebuild_popup()
		popup:move_next_to(mouse.current_widget_geometry, "left")
	end
end)

return widget
