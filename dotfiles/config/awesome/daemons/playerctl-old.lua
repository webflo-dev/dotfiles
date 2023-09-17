local awful = require("awful")
local gtimer = require("gears.timer")
local gobject = require("gears.object")
local gtable = require("gears.table")
local gstring = require("gears.string")

local Playerctl = require("lgi").Playerctl

local utils = require("utils.widget")
local helperIcon = require("utils.icon")

local function get_player_by_instance(self, instance)
	if instance == nil then
		return self._private.manager.players[1]
	end

	for _, player in ipairs(self._private.manager.players) do
		if player.player_instance == instance then
			return player
		end
	end

	return nil
end

local function save_image_async_curl(url, filepath, callback)
	awful.spawn.with_line_callback(string.format("curl -L -s %s -o %s", url, filepath), {
		exit = callback,
	})
end

local playerctl = {}

function playerctl:has_players()
	return #self._private.manager.players > 0
end

function playerctl:get_current_metadata()
	local current_player = self._private.manager.players[1]
	if current_player == nil then
		return nil
	end
	return self._private.players[current_player.player_instance]
end

function playerctl:play_pause(instance)
	local player = get_player_by_instance(self, instance)
	if player ~= nil then
		player:play_pause()
	end
end

function playerctl:pause(instance)
	local player = get_player_by_instance(self, instance)
	if player ~= nil then
		player:pause()
	end
end

function playerctl:play(instance)
	local player = get_player_by_instance(self, instance)
	if player ~= nil then
		player:play()
	end
end

function playerctl:previous(instance)
	local player = get_player_by_instance(self, instance)
	if player ~= nil then
		player:previous()
	end
end

function playerctl:next(instance)
	local player = get_player_by_instance(self, instance)
	if player ~= nil then
		player:next()
	end
end

local function emit_metadata(self, player)
	if self._private.player_icons[player.player_name] == nil then
		self._private.player_icons[player.player_name] = helperIcon.search_apps_icon(player.player_name)
	end

	local art_url = gstring.xml_escape(player:print_metadata_prop("mpris:artUrl") or "")

	local current_player = self._private.manager.players[1]

	local metadata = {
		player_instance = player.player_instance,
		player_name = player.player_name,
		status = player.playback_status,
		artist = gstring.xml_escape(player:get_artist() or ""),
		title = gstring.xml_escape(player:get_title() or ""),
		album = gstring.xml_escape(player:get_album() or ""),
		art_path = nil,
		icon_path = self._private.player_icons[player.player_name],
	}

	if art_url ~= "" then
		art_url = art_url:gsub("open.spotify.com", "i.scdn.co")
		local art_path = os.tmpname()
		save_image_async_curl(art_url, art_path, function()
			metadata.art_path = art_path
			self._private.players[metadata.player_instance] =
				gtable.crush(self._private.players[metadata.player_instance] or {}, metadata)
			self:emit_signal(
				"metadata",
				self._private.players[metadata.player_instance],
				current_player ~= nil and self._private.players[current_player.player_instance] or {}
			)
		end)
	else
		self._private.players[metadata.player_instance] =
			gtable.crush(self._private.players[metadata.player_instance] or {}, metadata)
		self:emit_signal(
			"metadata",
			self._private.players[metadata.player_instance],
			current_player ~= nil and self._private.players[current_player.player_instance] or {}
		)
	end
end

local function emit_playback_status(self, player_instance, status)
	local existing_metadata = self._private.players[player_instance]
	if existing_metadata == nil then
		self._private.players[player_instance] = {
			status = status,
		}
	else
		existing_metadata.status = status
	end
	self:emit_signal("metadata", self._private.players[player_instance])
end

local function init_player(self, name)
	local player = Playerctl.Player.new_from_name(name)
	self._private.manager:manage_player(player)
end

local function configure_player(self, player)
	gtimer({
		timeout = 1,
		autostart = true,
		single_shot = true,
		callback = function()
			self._private.manager:move_player_to_top(player)
			emit_metadata(self, player)
		end,
	})

	player.on_metadata = function()
		self._private.manager:move_player_to_top(player)
		emit_metadata(self, player)
	end

	player.on_playback_status = function()
		self._private.manager:move_player_to_top(player)
		emit_playback_status(self, player.player_instance, player.playback_status)
	end
end

local function new()
	local ret = gobject({})
	gtable.crush(ret, playerctl, true)

	ret._private = {
		manager = Playerctl.PlayerManager(),
		players = {},
		player_icons = {},
	}

	gtimer.delayed_call(function()
		for _, name in ipairs(ret._private.manager.player_names) do
			init_player(ret, name)
		end

		for _, player in ipairs(ret._private.manager.players) do
			configure_player(ret, player)
		end

		function ret._private.manager:on_name_appeared(name)
			init_player(ret, name)
		end

		function ret._private.manager:on_player_appeared(player)
			configure_player(ret, player)
		end

		-- function ret._private.manager:on_name_vanished(player_name)
		-- 	table.remove(ret._private.players, utils.index_of(ret._private.players, player_name))
		-- 	ret:emit_signal("name-vanished", player_name)
		-- end

		function ret._private.manager:on_player_vanished(player)
			ret._private.players[player.player_instance] = nil
			ret:emit_signal("player-vanished", player.player_instance, player.player_name)
		end
	end)

	return ret
end

return new()
