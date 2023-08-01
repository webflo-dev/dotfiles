local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

local playerctl = require("signals").playerctl

-- local function clickable_widget(widget, hover_color, leave_color, on_click)
-- 	widget:connect_signal("mouse::enter", function()
-- 		local w = mouse.current_wibox
-- 		if w then
-- 			w.cursor = "hand2"
-- 		end
--
-- 		widget.stylesheet = "svg { fill: " .. (hover_color or beautiful.accent_color) .. " }"
-- 	end)
--
-- 	widget:connect_signal("mouse::leave", function()
-- 		local w = mouse.current_wibox
-- 		if w then
-- 			w.cursor = "left_ptr"
-- 		end
-- 		widget.stylesheet = "svg { fill: " .. (leave_color or beautiful.accent_color) .. " }"
-- 	end)
--
-- 	if on_click ~= nil then
-- 		widget:connect_signal("button::press", on_click)
-- 	end
--
-- 	return widget
-- end

local widget_thumbnail = base.svg(beautiful.svg.music, beautiful.accent_color)
widget_thumbnail.visible = false
widget_thumbnail.art_path = nil

local widget_icon_player = base.svg(beautiful.svg.music)
widget_icon_player.icon_path = nil

local widget_text = wibox.widget({
	widget = wibox.widget.textbox,
	markup = "---",
	valign = "center",
	font = beautiful.fonts.system,
})

local widget_control_play = base.clickable_widget(
	base.svg(beautiful.svg.play, beautiful.fg_normal),
	beautiful.accent_color,
	beautiful.fg_normal,
	function()
		playerctl.play_pause()
	end
)
widget_control_play.playback_status = nil

local widget_control_backward = base.clickable_widget(
	base.svg(beautiful.svg.backward, beautiful.fg_normal),
	beautiful.accent_color,
	beautiful.fg_normal,
	function()
		playerctl.previous()
	end
)
local widget_control_forward = base.clickable_widget(
	base.svg(beautiful.svg.forward, beautiful.fg_normal),
	beautiful.accent_color,
	beautiful.fg_normal,
	function()
		playerctl.next()
	end
)

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
		shape = helperUI.rounded_shape(),
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
			widget_icon_player:change_image(metadata.icon_path)
			widget_icon_player.icon = metadata.icon_path
		end
	else
		if widget_icon_player.icon ~= nil then
			widget_icon_player:change_image(beautiful.svg.music)
			widget_icon_player.icon = nil
		end
	end

	if metadata.art_path ~= nil and metadata.art_path ~= "" then
		if metadata.art_path ~= widget_thumbnail.art_path then
			widget_thumbnail.art_path = metadata.art_path
			widget_thumbnail.visible = true
			widget_thumbnail:change_image(metadata.art_path)
		end
	else
		widget_thumbnail.visible = false
	end

	widget_control_play.playback_status = metadata.status
	if metadata.status == "PLAYING" then
		widget_control_play:change_image(beautiful.svg.pause)
	else
		widget_control_play:change_image(beautiful.svg.play)
	end

	local artist = helperUI.pango2(metadata.artist, { weight = "bold" })
	local title = helperUI.pango2(metadata.title, { weight = "light" })
	widget_text:set_markup(string.format("%s - %s", artist, title))
end

-- Player list
local player_widget_list = wibox.widget({
	layout = wibox.layout.fixed.vertical,
})

local function build_player_widget(metadata)
	local player_icon = nil
	if metadata.icon_path ~= nil and metadata.icon_path ~= "" then
		player_icon = helperUI.force_size(base.svg(metadata.icon_path, beautiful.colors.light))
	else
		player_icon =
			{ widget = wibox.widget.textbox, markup = helperUI.pango2(metadata.player_name, { style = "italic" }) }
	end

	local player_image = helperUI.force_size({
		widget = wibox.widget.imagebox,
		clip_shape = helperUI.rounded_shape(),
		valign = "center",
		halign = "center",
		id = "w_player_image",
	}, 85)

	if metadata.art_path ~= nil and metadata.art_path ~= "" then
		player_image.image = metadata.art_path
	else
		player_image.image = beautiful.svg.music
	end

	local control_play_pause =
		helperUI.force_size(base.svg_template(beautiful.svg.play, beautiful.colors.light, "w_player_play_pause"))
	local control_previous =
		helperUI.force_size(base.svg_template(beautiful.svg.backward, beautiful.colors.light, "w_player_previous"))
	local control_next =
		helperUI.force_size(base.svg_template(beautiful.svg.forward, beautiful.colors.light, "w_player_next"))

	local player = wibox.widget({
		{
			{
				{
					{
						player_image,
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
								id = "w_player_artist",
							},
							layout = wibox.layout.fixed.horizontal,
						},
						{
							{
								markup = metadata.title,
								font = beautiful.fonts.system,
								widget = wibox.widget.textbox,
								id = "w_player_title",
							},
							widget = wibox.container.margin,
							margins = { left = dpi(8) },
						},
						forced_width = dpi(500),
						layout = wibox.layout.fixed.vertical,
						spacing = dpi(3),
					},
					valign = "center",
					layout = wibox.container.place,
				},
				{
					{
						control_previous,
						control_play_pause,
						control_next,
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

	base.clickable_widget(
		player:get_children_by_id("w_player_play_pause")[1],
		beautiful.svg.accent_color,
		beautiful.colors.light,
		function()
			playerctl.play_pause(metadata.player_instance)
		end
	)

	base.clickable_widget(
		player:get_children_by_id("w_player_previous")[1],
		beautiful.svg.accent_color,
		beautiful.colors.light,
		function()
			playerctl.previous(metadata.player_instance)
		end
	)

	base.clickable_widget(
		player:get_children_by_id("w_player_next")[1],
		beautiful.svg.accent_color,
		beautiful.colors.light,
		function()
			playerctl.next(metadata.player_instance)
		end
	)

	function player:update_info(updated_metadata)
		local w_image = self:get_children_by_id("w_player_image")[1]
		if updated_metadata.art_path ~= nil and updated_metadata.art_path ~= "" then
			w_image.image = updated_metadata.art_path
		else
			if w_image.image ~= beautiful.svg.music then
				w_image.image = beautiful.svg.music
			end
		end

		local w_title = self:get_children_by_id("w_player_title")[1]
		w_title.markup = updated_metadata.title

		local w_artist = self:get_children_by_id("w_player_artist")[1]
		w_artist.markup = helperUI.pango2(metadata.artist, { weight = "bold" })

		local w_play = self:get_children_by_id("w_player_play_pause")[1]
		if w_play ~= nil then
			if updated_metadata.status == "PLAYING" then
				w_play.image = beautiful.svg.pause
			else
				w_play.image = beautiful.svg.play
			end
		end
	end

	return player
end

local popup = awful.popup({
	preferred_anchors = "middle",
	ontop = true,
	visible = false,
	shape = gears.shape.rounded_rect,
	border_width = beautiful.border_width,
	border_color = beautiful.colors.sky,
	-- hide_on_right_click = true,
	offset = { y = 5 },
	widget = player_widget_list,
})

widget_text:connect_signal("button::press", function()
	if popup.visible then
		popup.visible = not popup.visible
	else
		popup:move_next_to(mouse.current_widget_geometry, "left")
	end
end)

local function indexOf_player_widget(id)
	for index, value in ipairs(player_widget_list.children) do
		if value.id == id then
			return index
		end
	end
	return nil
end

local function find_player_widget(id)
	for _, value in ipairs(player_widget_list.children) do
		if value.id == id then
			return value
		end
	end
	return nil
end

awesome.connect_signal("signal::playerctl::metadata", function(metadata)
	widget_controls.visible = true

	-- Current  player
	update_info(metadata)

	-- Player list
	local existing_player_widget = find_player_widget(metadata.player_instance)
	if not existing_player_widget then
		local player_widget = build_player_widget(metadata)
		player_widget.id = metadata.player_instance
		player_widget_list:insert(1, player_widget)
	else
		existing_player_widget:update_info(metadata)
	end
end)

awesome.connect_signal("signal::playerctl::player-vanished", function(player_instance, player_name)
	local index = indexOf_player_widget(player_instance)
	if index ~= nil then
		player_widget_list:remove(index)
	end
end)

return widget
