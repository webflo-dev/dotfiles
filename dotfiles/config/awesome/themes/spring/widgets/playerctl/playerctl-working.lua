local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local helperIcon = require("helpers.icon")
local base = require("themes.spring.widgets.base")

--local playerctl = require("signals").playerctl
local playerctl = require("signals.playerctl_working")()

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

local popup = awful.popup({
	preferred_anchors = "middle",
	ontop = true,
	visible = false,
	shape = gears.shape.rounded_rect,
	border_width = beautiful.border_width,
	border_color = beautiful.colors.lime,
	-- hide_on_right_click = true,
	offset = { y = 5 },
	widget = {},
})

local function create_player(player_name, metadata)
	local play_pause = clickable_control(base.svg(beautiful.svg.play, beautiful.colors.light), function()
		playerctl:play_pause(player_name)
	end)
	local previous = clickable_control(base.svg(beautiful.svg.backward, beautiful.colors.light), function()
		playerctl:previous(player_name)
	end)
	local next = clickable_control(base.svg(beautiful.svg.forward, beautiful.colors.light), function()
		playerctl:next(player_name)
	end)

	local player_icon = nil
	if metadata.icon_path ~= nil and metadata.icon_path ~= "" then
		player_icon = base.svg(metadata.icon_path, beautiful.colors.light)
	else
		player_icon = { widget = wibox.widget.textbox, markup = helperUI.pango2(player_name, { style = "italic" }) }
	end

	local album_image = nil
	if metadata.art_path ~= "" then
		album_image = {
			widget = wibox.widget.imagebox,
			clip_shape = helperUI.rounded_shape(),
			forced_height = dpi(85),
			forced_width = dpi(85),
			image = metadata.art_path,
		}
	else
		album_image = base.svg(beautiful.svg.music, beautiful.accent_color)
		album_image.forced_width = dpi(85)
		album_image.forced_height = dpi(85)
	end

	local player = wibox.widget({
		{
			{
				{
					{
						album_image,
						margins = dpi(8),
						layout = wibox.container.margin,
					},
					valign = "center",
					layout = wibox.container.place,
				},
				{
					{
						{
							player_icon,
							{
								markup = helperUI.pango2(metadata.artist, { weight = "bold" }),
								font = beautiful.fonts.system,
								widget = wibox.widget.textbox,
							},
							layout = wibox.layout.fixed.horizontal,
						},
						{
							{
								markup = metadata.title,
								font = beautiful.fonts.system,
								widget = wibox.widget.textbox,
							},
							widget = wibox.container.margin,
							margins = { left = dpi(8) },
						},
						forced_width = dpi(300),
						layout = wibox.layout.fixed.vertical,
						spacing = dpi(3),
					},
					valign = "center",
					layout = wibox.container.place,
				},
				{
					{
						previous,
						play_pause,
						next,
						layout = wibox.layout.align.horizontal,
					},
					forced_width = 90,
					valign = "center",
					haligh = "center",
					layout = wibox.container.place,
				},
				spacing = dpi(8),
				layout = wibox.layout.align.horizontal,
			},
			margins = dpi(8),
			layout = wibox.container.margin,
		},
		bg = beautiful.bg_normal,
		widget = wibox.container.background,
	})

	local function toggle_play_pause(status, _player_name)
		if player_name ~= _player_name then
			return
		end

		if status == true then
			play_pause:change_image(beautiful.svg.pause)
		else
			play_pause:change_image(beautiful.svg.play)
		end
	end

	awesome.connect_signal("playerctl::playback_status", toggle_play_pause)

	return player
end

local function rebuild_popup()
	local rows = {
		layout = wibox.layout.fixed.vertical,
	}
	for player_name, metadata in pairs(players) do
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
