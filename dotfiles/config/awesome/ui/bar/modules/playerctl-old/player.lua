local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local daemon = require("daemons.playerctl-old")

local ui = require("ui.utils")
local tpl = require("ui.templates")
local utils = require("utils.widget")

local SVG_DEFAULT_SIZE = dpi(30)
local SVG_LARGE_SIZE = dpi(85)

local function new(metadata)
	local player_icon = nil
	if metadata.icon_path ~= nil and metadata.icon_path ~= "" then
		player_icon = tpl.svg({
			image = metadata.icon_path,
			color = beautiful.colors.light,
			forced_width = SVG_DEFAULT_SIZE,
			forced_height = SVG_DEFAULT_SIZE,
		})
	else
		player_icon = {
			widget = wibox.widget.textbox,
			markup = ui.pango(metadata.player_name, { style = "italic" }),
		}
	end

	local player_image = {
		widget = wibox.widget.imagebox,
		clip_shape = ui.rounded_rect,
		valign = "center",
		halign = "center",
		forced_width = SVG_LARGE_SIZE,
		forced_height = SVG_LARGE_SIZE,
		id = "w_player_image",
	}

	if metadata.art_path ~= nil and metadata.art_path ~= "" then
		player_image.image = metadata.art_path
	else
		player_image.image = beautiful.svg.music
	end

	local control_play_pause = tpl.svg({
		image = beautiful.svg.play,
		color = beautiful.colors.light,
		id = "w_player_play_pause",
		forced_width = SVG_DEFAULT_SIZE,
		forced_height = SVG_DEFAULT_SIZE,
	})

	local control_previous = tpl.svg({
		image = beautiful.svg.backward,
		color = beautiful.colors.light,
		id = "w_player_previous",
		forced_width = SVG_DEFAULT_SIZE,
		forced_height = SVG_DEFAULT_SIZE,
	})

	local control_next = tpl.svg({
		image = beautiful.svg.forward,
		color = beautiful.colors.light,
		id = "w_player_next",
		forced_width = SVG_DEFAULT_SIZE,
		forced_height = SVG_DEFAULT_SIZE,
	})

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
								markup = ui.pango(metadata.artist, { weight = "bold" }),
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

	local w_control_play = player:get_children_by_id("w_player_play_pause")[1]
	w_control_play:connect_signal("mouse::enter", function(self)
		ui.mouse_hover_cursor(true)
		self.stylesheet = ui.stylesheet_color(beautiful.accent_color)
	end)
	w_control_play:connect_signal("mouse::leave", function(self)
		ui.mouse_hover_cursor(false)
		self.stylesheet = ui.stylesheet_color(beautiful.fg_normal)
	end)
	w_control_play:connect_signal("button::press", function()
		daemon:play_pause(metadata.player_instance)
	end)

	local w_control_previous = player:get_children_by_id("w_player_previous")[1]
	w_control_previous:connect_signal("mouse::enter", function(self)
		ui.mouse_hover_cursor(true)
		self.stylesheet = ui.stylesheet_color(beautiful.accent_color)
	end)
	w_control_previous:connect_signal("mouse::leave", function(self)
		ui.mouse_hover_cursor(false)
		self.stylesheet = ui.stylesheet_color(beautiful.fg_normal)
	end)
	w_control_previous:connect_signal("button::press", function()
		daemon:previous(metadata.player_instance)
	end)

	local w_control_next = player:get_children_by_id("w_player_next")[1]
	w_control_next:connect_signal("mouse::enter", function(self)
		ui.mouse_hover_cursor(true)
		self.stylesheet = ui.stylesheet_color(beautiful.accent_color)
	end)
	w_control_next:connect_signal("mouse::leave", function(self)
		ui.mouse_hover_cursor(false)
		self.stylesheet = ui.stylesheet_color(beautiful.fg_normal)
	end)
	w_control_next:connect_signal("button::press", function()
		daemon:next(metadata.player_instance)
	end)

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
		w_artist.markup = ui.pango(metadata.artist, { weight = "bold" })

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

return utils.factory(new)
