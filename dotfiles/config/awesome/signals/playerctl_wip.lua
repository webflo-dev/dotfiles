local awful = require("awful")
local gobject = require("gears.object")
local gtable = require("gears.table")
local gtimer = require("gears.timer")
local gstring = require("gears.string")
local capi = { awesome = awesome }

local helperIcon = require("helpers.icon")

local playerctl = { mt = {} }

local players = {}

local function debug(prefix, data, key)
	require("gears.debug").print_warning(prefix .. " => " .. require("gears.debug").dump_return(data, key, 3))
end

local function get_player_by_name(self, name)
	if name == nil then
		return self:get_active_player()
	end

	for _, player in ipairs(self._private.manager.players) do
		if player.player_name == name then
			return player
		end
	end

	return nil
end

function playerctl:get_all_metadata()
	return players
end

function playerctl:get_active_player()
	return self._private.manager.players[1]
end

function playerctl:play_pause(player_name)
	local player = get_player_by_name(self, player_name)
	if player ~= nil then
		player:play_pause()
	end
end

function playerctl:pause(player_name)
	local player = get_player_by_name(self, player_name)
	if player ~= nil then
		player:pause()
	end
end

function playerctl:play(player_name)
	local player = get_player_by_name(self, player_name)
	if player ~= nil then
		player:play()
	end
end

function playerctl:stop(player_name)
	local player = get_player_by_name(self, player_name)
	if player ~= nil then
		player:stop()
	end
end

function playerctl:previous(player_name)
	local player = get_player_by_name(self, player_name)
	if player ~= nil then
		player:previous()
	end
end

function playerctl:next(player_name)
	local player = get_player_by_name(self, player_name)
	if player ~= nil then
		player:next()
	end
end

function playerctl:set_position(position, player_name)
	local player = get_player_by_name(self, player_name)
	if player ~= nil then
		player:set_position(position * 1000000)
	end
end

local function save_image_async_curl(url, filepath, callback)
	awful.spawn.with_line_callback(string.format("curl -L -s %s -o %s", url, filepath), {
		exit = callback,
	})
end

local function emit_metadata_signal(self, player_name, title, artist, artUrl, album, done_callback)
	local metadata = {
		title = gstring.xml_escape(title),
		artist = gstring.xml_escape(artist),
		album = gstring.xml_escape(album),
		icon_path = nil,
		art_path = nil,
		is_playing = false,
	}

	if players[player_name] == nil then
		metadata["icon_path"] = helperIcon.search_apps_icon(player_name)
		players[player_name] = gtable.crush({}, metadata)
	else
		metadata["icon_path"] = players[player_name]["icon_path"]
		players[player_name] = gtable.crush(players[player_name], metadata)
	end

	-- Spotify client doesn't report its art URL's correctly...
	if player_name == "spotify" then
		artUrl = artUrl:gsub("open.spotify.com", "i.scdn.co")
	end
	if artUrl ~= "" then
		local art_path = os.tmpname()
		save_image_async_curl(artUrl, art_path, function()
			metadata["art_path"] = art_path
			players[player_name] = gtable.crush(players[player_name], metadata)
			capi.awesome.emit_signal(
				"playerctl2::metadata",
				player_name,
				metadata
			)
			if done_callback ~= nil then
				done_callback(metadata)
			end
		end)
	else
		capi.awesome.emit_signal(
			"playerctl2::metadata",
			player_name,
			players[player_name]
		)
		if done_callback ~= nil then
			done_callback(players[player_name])
		end
	end
end

local function emit_playback_status_signal(self, player_name, playback_status)
	local is_playing = playback_status == "PLAYING" and true or false
	players[player_name] = gtable.crush(players[player_name], { is_playing = is_playing })
	capi.awesome.emit_signal("playerctl2::playback_status", player_name, players[player_name])
end

local function emit_position_signal(self, player_name, position)
	capi.awesome.emit_signal("playerctl2::position", player_name, position)
end


local function get_player_info(self, player)
	local title = player:get_title() or ""
	local artist = player:get_artist() or ""
	local artUrl = player:print_metadata_prop("mpris:artUrl") or ""
	local album = player:get_album() or ""

	emit_metadata_signal(self, player.player_name, title, artist, artUrl, album)
	emit_playback_status_signal(self, player.player_name, player.playback_status)
end

local function update_position(self)
	-- emit signal for all players with new position for each
	-- 1 signal per player or 1 signal for all players?
end

local function initialize_player(self, name)
	local new_player = self._private.lgi_Playerctl.Player.new_from_name(name)

	self._private.manager:manage_player(new_player)


	new_player.on_metadata = function(player, metadata)
		self._private.manager:move_player_to_top(player)

		local title = metadata.value["xesam:title"] or ""
		local artist = metadata.value["xesam:artist"][1] or ""
		for i = 2, #metadata.value["xesam:artist"] do
			artist = artist .. ", " .. metadata.value["xesam:artist"][i]
		end
		local artUrl = metadata.value["mpris:artUrl"] or ""
		local album = metadata.value["xesam:album"] or ""

		if title == "" and artist == "" and artUrl == "" then
			return
		end

		emit_metadata_signal(self, player.player_name, title, artist, artUrl, album)
		self._private.position_timer:again()
	end
	new_player.on_playback_status = function(player, playback_status)
		self._private.manager:move_player_to_top(player)
		emit_playback_status_signal(self, player.player_name, playback_status)
	end
	-- new_player.on_seeked = function(player, position)
	-- self._private.manager:move_player_to_top(player)
	-- 	seeked_cb(self, player, position)
	-- end
	new_player.on_exit = function(player)
		capi.awesome.emit_signal("playerctl2::exit", player.player_name)
	end



	-- Start position timer if its not already running
	if not self._private.position_timer.started then
		self._private.position_timer:again()
	end

	get_player_info(self, new_player)
end

local function start_manager(self)
	self._private.manager = self._private.lgi_Playerctl.PlayerManager()

	-- Timer to update track position at specified interval
	self._private.position_timer = gtimer({
		timeout = 1,
		callback = function()
			update_position(self)
		end,
	})

	-- Manage existing players on startup
	for _, name in ipairs(self._private.manager.player_names) do
		initialize_player(self, name)
	end

	local _self = self

	function self._private.manager:on_name_appeared(name)
		initialize_player(_self, name)
	end

	-- function self._private.manager:on_player_appeared(player)
	-- 	if player == self.players[1] then
	-- 		_self._private.active_player = player
	-- 	end
	-- end

	function self._private.manager:on_player_vanished(player)
		if #self.players == 0 then
			_self._private.metadata_timer:stop()
			_self._private.position_timer:stop()
			capi.awesome.emit_signal("playerctl2::no_players")
		end
		players[player.player_name] = nil
	end
end

local function new(args)
	args = args or {}

	local ret = gobject({})
	gtable.crush(ret, playerctl, true)

	ret._private = {}

	ret._private.lgi_Playerctl = require("lgi").Playerctl
	ret._private.manager = nil
	ret._private.position_timer = nil
	--
	-- Ensure main event loop has started before starting player manager
	gtimer.delayed_call(function()
		start_manager(ret)
	end)

	return ret
end

function playerctl.mt:__call(...)
	return new(...)
end

return setmetatable(playerctl, playerctl.mt)
