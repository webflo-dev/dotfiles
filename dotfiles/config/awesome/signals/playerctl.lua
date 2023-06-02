local awful = require("awful")
local gobject = require("gears.object")
local gtable = require("gears.table")
local gtimer = require("gears.timer")
local gstring = require("gears.string")
local setmetatable = setmetatable
local ipairs = ipairs
local capi = { awesome = awesome }

local playerctl = { mt = {} }

function playerctl:play_pause(player)
	player = player or self._private.manager.players[1]
	if player then
		player:play_pause()
	end
end

function playerctl:pause(player)
	player = player or self._private.manager.players[1]
	if player then
		player:pause()
	end
end

function playerctl:play(player)
	player = player or self._private.manager.players[1]
	if player then
		player:play()
	end
end

function playerctl:stop(player)
	player = player or self._private.manager.players[1]
	if player then
		player:stop()
	end
end

function playerctl:previous(player)
	player = player or self._private.manager.players[1]
	if player then
		player:previous()
	end
end

function playerctl:next(player)
	player = player or self._private.manager.players[1]
	if player then
		player:next()
	end
end

function playerctl:set_position(position, player)
	player = player or self._private.manager.players[1]
	if player then
		player:set_position(position * 1000000)
	end
end

local function save_image_async_curl(url, filepath, callback)
	awful.spawn.with_line_callback(string.format("curl -L -s %s -o %s", url, filepath), {
		exit = callback,
	})
end

local function emit_metadata_signal(self, title, artist, artUrl, album, new, player_name)
	title = gstring.xml_escape(title)
	artist = gstring.xml_escape(artist)
	album = gstring.xml_escape(album)

	-- Spotify client doesn't report its art URL's correctly...
	if player_name == "spotify" then
		artUrl = artUrl:gsub("open.spotify.com", "i.scdn.co")
	end

	if artUrl ~= "" then
		local art_path = os.tmpname()
		save_image_async_curl(artUrl, art_path, function()
			capi.awesome.emit_signal(
				"playerctl::metadata",
				{ title = title, artist = artist, art_path = art_path, album = album },
				new,
				player_name
			)
		end)
	else
		capi.awesome.emit_signal(
			"playerctl::metadata",
			{ title = title, artist = artist, art_path = "", album = album },
			new,
			player_name
		)
	end
end

local function playback_status_cb(self, player, status)
	self._private.manager:move_player_to_top(player)

	if player == self._private.manager.players[1] then
		self._private.active_player = player
		-- Reported as PLAYING, PAUSED, or STOPPED
		if status == "PLAYING" then
			capi.awesome.emit_signal("playerctl::playback_status", true, player.player_name)
		else
			capi.awesome.emit_signal("playerctl::playback_status", false, player.player_name)
		end
	end
end

local function metadata_cb(self, player, metadata)
	self._private.manager:move_player_to_top(player)

	local data = metadata.value

	local title = data["xesam:title"] or ""
	local artist = data["xesam:artist"][1] or ""
	for i = 2, #data["xesam:artist"] do
		artist = artist .. ", " .. data["xesam:artist"][i]
	end
	local artUrl = data["mpris:artUrl"] or ""
	local album = data["xesam:album"] or ""

	if player == self._private.manager.players[1] then
		self._private.active_player = player

		-- Callback can be called even though values we care about haven't
		-- changed, so check to see if they have
		if
			player ~= self._private.last_player
			or title ~= self._private.last_title
			or artist ~= self._private.last_artist
			or artUrl ~= self._private.last_artUrl
		then
			if title == "" and artist == "" and artUrl == "" then
				return
			end

			if self._private.metadata_timer ~= nil and self._private.metadata_timer.started then
				self._private.metadata_timer:stop()
			end

			self._private.metadata_timer = gtimer({
				timeout = 0.35,
				autostart = true,
				single_shot = true,
				callback = function()
					emit_metadata_signal(self, title, artist, artUrl, album, true, player.player_name)
				end,
			})

			-- Re-sync with position timer when track changes
			self._private.position_timer:again()
			self._private.last_player = player
			self._private.last_title = title
			self._private.last_artist = artist
			self._private.last_artUrl = artUrl
		end
	end
end

local function position_cb(self)
	local player = self._private.manager.players[1]
	if player then
		local position = player:get_position() / 1000000
		local length = (player.metadata.value["mpris:length"] or 0) / 1000000
		if position ~= self._private.last_position or length ~= self._private.last_length then
			capi.awesome.emit_signal("playerctl::position", position, length, player.player_name)
			-- self:emit_signal("position", position, length, player.player_name)
			self._private.last_position = position
			self._private.last_length = length
		end
	end
end

local function seeked_cb(self, player, position)
	self._private.manager:move_player_to_top(player)

	if player == self._private.manager.players[1] then
		self._private.active_player = player
		self:emit_signal("seeked", position / 1000000, player.player_name)
	end
end

local function exit_cb(self, player)
	if player == self._private.manager.players[1] then
		self:emit_signal("exit", player.player_name)
	end
end

local function get_current_player_info(self, player)
	local title = player:get_title() or ""
	local artist = player:get_artist() or ""
	local artUrl = player:print_metadata_prop("mpris:artUrl") or ""
	local album = player:get_album() or ""

	emit_metadata_signal(self, title, artist, artUrl, album, false, player.player_name)
	playback_status_cb(self, player, player.playback_status)
end

-- Create new player and connect it to callbacks
local function init_player(self, name)
	local new_player = self._private.lgi_Playerctl.Player.new_from_name(name)

	self._private.manager:manage_player(new_player)

	new_player.on_metadata = function(player, metadata)
		metadata_cb(self, player, metadata)
	end
	new_player.on_playback_status = function(player, playback_status)
		playback_status_cb(self, player, playback_status)
	end
	new_player.on_seeked = function(player, position)
		seeked_cb(self, player, position)
	end
	new_player.on_exit = function(player)
		exit_cb(self, player)
	end

	-- Start position timer if its not already running
	if not self._private.position_timer.started then
		self._private.position_timer:again()
	end

	get_current_player_info(self, new_player)
end

local function start_manager(self)
	self._private.manager = self._private.lgi_Playerctl.PlayerManager()

	-- Timer to update track position at specified interval
	self._private.position_timer = gtimer({
		timeout = 1,
		callback = function()
			position_cb(self)
		end,
	})

	-- Manage existing players on startup
	for _, name in ipairs(self._private.manager.player_names) do
		init_player(self, name)
	end

	local _self = self

	function self._private.manager:on_name_appeared(name)
		init_player(_self, name)
	end

	function self._private.manager:on_player_appeared(player)
		if player == self.players[1] then
			_self._private.active_player = player
		end
	end

	function self._private.manager:on_player_vanished(player)
		if #self.players == 0 then
			_self._private.metadata_timer:stop()
			_self._private.position_timer:stop()
			capi.awesome.emit_signal("playerctl::no_players")
		elseif player == _self._private.active_player then
			_self._private.active_player = self.players[1]
			get_current_player_info(_self, self.players[1])
		end
	end
end

local function new(args)
	args = args or {}

	local ret = gobject({})
	gtable.crush(ret, playerctl, true)

	ret._private = {}

	-- Metadata callback for title, artist, and album art
	ret._private.last_player = nil
	ret._private.last_title = ""
	ret._private.last_artist = ""
	ret._private.last_artUrl = ""

	-- Track position callback
	ret._private.last_position = -1
	ret._private.last_length = -1

	ret._private.lgi_Playerctl = require("lgi").Playerctl
	ret._private.manager = nil
	ret._private.metadata_timer = nil
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
