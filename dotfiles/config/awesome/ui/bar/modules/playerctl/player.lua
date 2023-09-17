local wibox = require("wibox")
local gtable = require("gears.table")
local gshape = require("gears.shape")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local daemon = require("daemons.playerctl")

local ui = require("ui.utils")
local tpl = require("ui.templates")
local utils = require("utils.widget")
local widgets_slider = require("ui.widgets.slider")

local control_button = require("ui.bar.modules.playerctl.control-button")

local IMAGE_DEFAULT_SIZE = dpi(24)
local IMAGE_LARGE_SIZE = dpi(85)
local IMAGE_SMALL_SIZE = dpi(12)

local _box = function(widget, color)
	return {
		widget,
		widget = wibox.container.background,
		border_width = dpi(1),
		border_color = color or beautiful.colors.red,
	}
end

local api = {}
function api:update_metadata(metadata)
	local w_image = self:get_children_by_id("w_image")[1]

	if self:get_children_by_id("w_player")[1] ~= nil then
		self:get_children_by_id("w_player_icon")[1].image = metadata.icon_path
		self:get_children_by_id("w_player_name")[1].markup =
			ui.pango(metadata.player_name, { font = beautiful.fonts.system })
	end

	local image = beautiful.svg.music
	if metadata.art_url ~= nil and metadata.art_url ~= "" then
		image = metadata.art_url
	elseif metadata.icon_path ~= nil and metadata.icon_path ~= "" then
		image = metadata.icon_path
	end

	w_image.image = image

	self:get_children_by_id("w_title")[1].markup = metadata.title
	self:get_children_by_id("w_artist")[1].markup = (metadata.artist and ui.pango(metadata.artist, { weight = "bold" }))
		or ""

	self:get_children_by_id("w_slider")[1].maximum = metadata.length
	-- self:get_children_by_id("btn_play_pause")[1]:toggle_play_pause(metadata.status)
	-- self:update_playback_status(metadata.status)
end

function api:update_playback_status(playback_status, metadata)
	self:get_children_by_id("btn_play_pause")[1]:toggle_play_pause(playback_status)
end

function api:update_position(position)
	self:get_children_by_id("w_time_elapsed")[1].markup = position.elapsed
	self:get_children_by_id("w_time_remaining")[1].markup = position.remaining

	local w_slider = self:get_children_by_id("w_slider")[1]
	if w_slider:is_busy() == false then
		w_slider.value = tonumber(position.elapsed_raw)
	end
end

local function new(metadata)
	local w_image = {
		tpl.svg({
			clip_shape = ui.rounded_rect,
			id = "w_image",
			resize = true,
		}),
		height = IMAGE_LARGE_SIZE,
		width = IMAGE_LARGE_SIZE,
		strategy = "exact",
		widget = wibox.container.constraint,
	}

	local w_player = {
		tpl.svg({
			id = "w_player_icon",
			resize = true,
			forced_width = IMAGE_SMALL_SIZE,
			forced_height = IMAGE_SMALL_SIZE,
		}),
		tpl.text({
			id = "w_player_name",
			font = beautiful.fonts.system,
		}),
		layout = wibox.layout.fixed.horizontal,
	}

	local w_artist = tpl.text({
		id = "w_artist",
		font = beautiful.fonts.system,
		halign = "left",
		ellipsize = "end",
	})

	local w_title = tpl.text({
		id = "w_title",
		font = beautiful.fonts.system,
		halign = "left",
		ellipsize = "end",
	})

	local w_slider = {
		id = "w_slider",
		minimum = 0,
		shape = ui.rounded_rect,
		forced_height = dpi(12),
		bar_color = beautiful.colors.green,
		bar_active_color = beautiful.colors.lime,
		bar_shape = gshape.rounded_bar,
		bar_height = dpi(2),
		handle_color = beautiful.colors.lime,
		handle_shape = gshape.circle,
		handle_width = dpi(10),
		handle_border_color = beautiful.colors.white,
		handle_border_width = dpi(2),
		widget = widgets_slider,
	}

	local w_time = {
		tpl.text({
			id = "w_time_elapsed",
			markup = "01:07",
			halign = "left",
			font = beautiful.fonts.system,
		}),
		nil,
		-- {
		-- 	w_player,
		-- 	id = "w_player",
		-- 	widget = wibox.container.place,
		-- },
		tpl.text({
			id = "w_time_remaining",
			markup = "-03:25",
			halign = "right",
			font = beautiful.fonts.system,
		}),
		layout = wibox.layout.align.horizontal,
	}

	local w_controls = {
		tpl.svg({
			id = "btn_backward",
			forced_width = IMAGE_DEFAULT_SIZE,
			forced_height = IMAGE_DEFAULT_SIZE,
		}),
		tpl.svg({
			id = "btn_play_pause",
			forced_width = IMAGE_DEFAULT_SIZE,
			forced_height = IMAGE_DEFAULT_SIZE,
		}),
		tpl.svg({
			id = "btn_forward",
			forced_width = IMAGE_DEFAULT_SIZE,
			forced_height = IMAGE_DEFAULT_SIZE,
		}),
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
	}

	local widget = wibox.widget({
		{
			w_image,
			{
				{
					{
						w_artist,
						w_title,
						layout = wibox.layout.fixed.vertical,
						spacing = dpi(10),
						forced_width = dpi(300),
					},
					w_controls,
					layout = wibox.layout.fixed.horizontal,
					spacing = dpi(10),
				},
				{
					w_slider,
					w_time,
					layout = wibox.layout.fixed.vertical,
					forced_width = dpi(300),
				},
				layout = wibox.layout.fixed.vertical,
				spacing = dpi(10),
			},
			spacing = dpi(10),
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.margin,
		margins = dpi(10),
	})

	widget.id = metadata.player_instance

	widget._priv = {}

	control_button(widget, {
		backward = "btn_backward",
		play_pause = "btn_play_pause",
		forward = "btn_forward",
		player_instance = metadata.player_instance,
	})

	ui.slider(widget:get_children_by_id("w_slider")[1], {
		on_release = function(value)
			daemon:change_position(metadata.player_instance, value)
		end,
	})

	return gtable.crush(widget, api, true)
end

return utils.factory(new)
