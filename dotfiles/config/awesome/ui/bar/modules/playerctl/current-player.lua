local wibox = require("wibox")
local gobject = require("gears.object")
local gtable = require("gears.table")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local tpl = require("ui.templates")
local ui = require("ui.utils")
local utils = require("utils.widget")

local control_button = require("ui.bar.modules.playerctl.control-button")

local api = {}

function api:update_metadata(metadata)
	local w_icon = self:get_children_by_id("w_icon")[1]
	if not metadata.icon_path then
		w_icon.image = beautiful.svg.music
	else
		w_icon.image = metadata.icon_path
	end

	local w_thumbnail = self:get_children_by_id("w_thumbnail")[1]
	if metadata.art_url == nil or metadata.art_url == "" then
		w_thumbnail.visible = false
	else
		w_thumbnail.image = metadata.art_url
		w_thumbnail.visible = true
	end

	local w_text = self:get_children_by_id("w_text")[1]
	local artist = (metadata.artist and ui.pango(metadata.artist, { weight = "bold" })) or ""
	local title = (metadata.title and ui.pango(metadata.title, { weight = "light" }) or "")
	w_text.markup = string.format("%s - %s", artist, title)

	-- self:get_children_by_id("btn_play_pause")[1]:toggle_play_pause(metadata.status)
	-- self:update_playback_status(metadata.status)

	self._priv.metadata = metadata
end

function api:update_playback_status(playback_status, metadata)
	if self._priv.metadata == nil then
		self:update_metadata(metadata)
	end

	self._priv.metadata.status = playback_status
	self:get_children_by_id("btn_play_pause")[1]:toggle_play_pause(playback_status)
end

local function new()
	local widget = wibox.widget({
		tpl.svg({
			id = "w_icon",
			color = beautiful.colors.yellow,
		}),
		tpl.svg({
			id = "w_thumbnail",
		}),
		tpl.svg({
			id = "btn_backward",
		}),
		tpl.svg({
			id = "btn_play_pause",
		}),
		tpl.svg({
			id = "btn_forward",
		}),
		tpl.text({
			id = "w_text",
			font = beautiful.fonts.system,
		}),
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
	})

	widget._priv = {}
	widget._priv.metadata = nil

	widget:get_children_by_id("w_text")[1]:connect_signal("button::press", function()
		widget:emit_signal("on-click")
	end)

	control_button(widget, {
		backward = "btn_backward",
		play_pause = "btn_play_pause",
		forward = "btn_forward",
	})

	return gtable.crush(widget, api, true)
end

return new()
