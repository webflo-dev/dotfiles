local awful = require("awful")
local gobject = require("gears.object")
local gtable = require("gears.table")
local gtimer = require("gears.timer")
local gstring = require("gears.string")
local gfilesystem = require("gears.filesystem")

local Playerctl = require("lgi").Playerctl

local utils = require("utils.daemon")
local helperIcon = require("utils.icon")

local METADATA_KEYS = {
	Title = "xesam:title",
	Artist = "xesam:artist",
	ArtUrl = "mpris:artUrl",
	Album = "xesam:album",
	Length = "mpris:length",
}

local function save_image_async_curl(url, filepath, callback)
	awful.spawn.with_line_callback(string.format("curl -L -s %s -o %s", url, filepath), {
		exit = callback,
	})
end

local function get_player_by_instance(manager, player_instance)
	if player_instance == nil then
		return manager.players[1]
	end

	for _, player in ipairs(manager.players) do
		if player.player_instance == player_instance then
			return player
		end
	end

	return nil
end

local function duration(timestamp)
	timestamp = tonumber(timestamp)
	local seconds = math.floor((timestamp / 1000000) % 60)
	local minutes = math.floor((timestamp / 1000000 / 60) % 60)
	local hours = math.floor((timestamp / 1000000 / 60 / 60))

	if hours ~= 0 then
		return string.format("%02.0f:%02.0f:%02.0f", hours, minutes, seconds)
	else
		return string.format("%02.0f:%02.0f", minutes, seconds)
	end
end

local function watch(self, done)
	awful.spawn.easy_async_with_shell("pkill playerctl", function()
		local script_system = gfilesystem.get_configuration_dir() .. "scripts/playerctl.sh"
		self._private.script_pid = utils.automatic_watch(script_system, self)
		if done ~= nil then
			done()
		end
	end)
end

-- API functions
local api = {}

function api:play_pause(player_instance)
	local player = get_player_by_instance(self._private.manager, player_instance)
	if player ~= nil then
		player:play_pause()
	end
end

function api:pause(player_instance)
	local player = get_player_by_instance(self._private.manager, player_instance)
	if player ~= nil then
		player:pause()
	end
end

function api:play(player_instance)
	local player = get_player_by_instance(self._private.manager, player_instance)
	if player ~= nil then
		player:play()
	end
end

function api:previous(player_instance)
	local player = get_player_by_instance(self._private.manager, player_instance)
	if player ~= nil then
		player:previous()
	end
end

function api:next(player_instance)
	local player = get_player_by_instance(self._private.manager, player_instance)
	if player ~= nil then
		player:next()
	end
end

function api:change_position(player_instance, value)
	local player = get_player_by_instance(self._private.manager, player_instance)
	if player ~= nil then
		player:set_position(value)
	end
end

-- SIGNALS functions
local signals = {}

function signals:emit_metadata(metadata)
	-- if
	-- 	metadata.title ~= self._private.players[metadata.player_instance].title
	-- 	or metadata.artist ~= self._private.players[metadata.player_instance].artist
	-- 	or metadata.art_url ~= self._private.players[metadata.player_instance].art_url
	-- then
	-- 	self._private.position_timer:again()
	-- end

	self._private.players[metadata.player_instance] = metadata
	self:emit_signal("metadata", self._private.players[metadata.player_instance])
end

function signals:emit_playback_status(player_instance, playback_status)
	self._private.players[player_instance].status = playback_status
	local is_playing = playback_status == "PLAYING"
	self:emit_signal("playback_status", playback_status, player_instance, self._private.players[player_instance])
end

function signals:emit_no_players()
	self:emit_signal("no-players")
end

function signals:emit_player_vanished(player)
	self._private.players[player.player_instance] = nil
	self:emit_signal("player-vanished", player.player_instance)
end

function signals:emit_position(player_instance, position)
	self:emit_signal("position", position)
end

-- CALLBACK functions
local callbacks = {}
function callbacks:on_metadata(player, player_metadata, done)
	self._private.manager:move_player_to_top(player)

	local metadata = nil

	if player_metadata ~= nil then
		local data = player_metadata.value
		metadata = {
			player_instance = player.player_instance,
			player_name = player.player_name,
			status = player.playback_status,
			artist = gstring.xml_escape(data[METADATA_KEYS.Artist][1] or ""),
			title = gstring.xml_escape(data[METADATA_KEYS.Title] or ""),
			album = gstring.xml_escape(data[METADATA_KEYS.Album] or ""),
			art_url = data[METADATA_KEYS.ArtUrl] or "",
			icon_path = self._private.player_icons[player.player_name],
			length = tonumber(data[METADATA_KEYS.Length] or 0),
		}

		for i = 2, #data[METADATA_KEYS.Artist] do
			metadata.artist = metadata.artist .. ", " .. data[METADATA_KEYS.Artist][i]
		end
	else
		metadata = {
			player_instance = player.player_instance,
			player_name = player.player_name,
			status = player.playback_status,
			artist = gstring.xml_escape(player:get_artist() or ""),
			title = gstring.xml_escape(player:get_title() or ""),
			album = gstring.xml_escape(player:get_album() or ""),
			art_url = player:print_metadata_prop(METADATA_KEYS.ArtUrl) or "",
			icon_path = self._private.player_icons[player.player_name],
			length = tonumber(player:print_metadata_prop(METADATA_KEYS.Length)) or 0,
		}
	end

	if metadata.art_url == "" or metadata.art_url == nil or gstring.startswith(metadata.art_url, "http") == false then
		done(metadata)
		return
	else
		metadata.art_url = metadata.art_url:gsub("open.spotify.com", "i.scdn.co")
		local art_path = os.tmpname()
		save_image_async_curl(metadata.art_url, art_path, function()
			metadata.art_url = art_path
			done(metadata)
		end)
	end
end

function callbacks:on_playback_status(player, playback_status, done)
	self._private.manager:move_player_to_top(player)

	done(player.player_instance, playback_status)
end

function callbacks:on_position()
	for _, player in ipairs(self._private.manager.players) do
		local length = (player.metadata.value[METADATA_KEYS.Length] or 0)

		local elapsed_raw = tonumber(player:get_position()) or 0
		local elapsed = duration(elapsed_raw)

		local remaining_raw = tonumber(length) - tonumber(elapsed_raw)
		local remaining = duration(remaining_raw)

		local position = {
			player_instance = player.player_instance,
			elapsed = elapsed,
			remaining = remaining,
			elapsed_raw = elapsed_raw,
			remaining_raw = remaining_raw,
		}
		self:emit_position(player.player_instance, position)
	end
end

local function init_player(self, name)
	local _player = Playerctl.Player.new_from_name(name)
	self._private.manager:manage_player(_player)
	self._private.players[_player.player_instance] = {}

	if self._private.player_icons[_player.player_name] == nil then
		self._private.player_icons[_player.player_name] = helperIcon.search_apps_icon(_player.player_name)
	end

	_player.on_metadata = function(player, metadata)
		self:on_metadata(player, metadata, function(new_metadata)
			self:emit_metadata(new_metadata)
		end)
	end

	_player.on_playback_status = function(player, playback_status)
		self:on_playback_status(player, playback_status, function(_player_instance, _playback_status)
			self:emit_playback_status(_player_instance, _playback_status)
		end)
	end

	_player.on_seeked = function(player, position)
		__Debug("on_seeked", position)
	end

	-- if not self._private.position_timer.started then
	-- 	self._private.position_timer:again()
	-- end

	-- player.on_seeked = function(player, position)
	-- 	seeked_cb(self, player, position)
	-- end
	-- player.on_volume = function(player, volume)
	-- 	volume_cb(self, player, volume)
	-- end
	-- player.on_loop_status = function(player, loop_status)
	-- 	loop_status_cb(self, player, loop_status)
	-- end
	-- player.on_shuffle = function(player, shuffle_status)
	-- 	shuffle_cb(self, player, shuffle_status)
	-- end
	-- player.on_exit = function(player, shuffle_status)
	-- 	exit_cb(self, player)
	-- end
end

local function get_player_info(self, player)
	if player == nil then
		player = self._private.manager.players[1]
	end

	self:on_metadata(player, nil, function(new_metadata)
		self:on_playback_status(player, player.playback_status, function(_player_instance, _playback_status)
			self:emit_metadata(new_metadata)
			self:emit_playback_status(_player_instance, _playback_status)
		end)
	end)
end

local function start(self)
	self._private.manager = Playerctl.PlayerManager()

	-- self._private.position_timer = gtimer({
	-- 	timeout = 1,
	-- 	autostart = true,
	-- 	callback = function()
	-- 		self:on_position()
	-- 	end,
	-- })

	for _, name in ipairs(self._private.manager.player_names) do
		init_player(self, name)
	end
	-- watch(self)

	for _, player in ipairs(self._private.manager.players) do
		get_player_info(self, player)
	end

	local _self = self

	function _self._private.manager:on_name_appeared(name)
		init_player(_self, name)
		-- watch(_self)
	end

	-- function self._private.manager:on_player_appeared(player)
	-- 	if player == self.players[1] then
	-- 		_self._private.active_player = player
	-- 	end
	-- end

	function self._private.manager:on_player_vanished(player)
		if #self.players == 0 then
			-- _self._private.position_timer:stop()
			_self:emit_signal("no-players")
		else
			_self._private.players[player.player_instance] = nil
			_self:emit_signal("player-vanished", player.player_instance)
			get_player_info(_self)
		end
	end
end

local function new()
	local ret = gobject({})
	gtable.crush(ret, signals, true)
	gtable.crush(ret, callbacks, true)
	gtable.crush(ret, api, true)

	ret._private = {
		manager = nil,
		players = {},
		player_icons = {},
		-- script_pid = nil,
		position_timer = nil,
	}

	gtimer.delayed_call(function()
		start(ret)
	end)

	return ret
end

return new()
