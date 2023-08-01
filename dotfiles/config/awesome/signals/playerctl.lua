local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi
local icon_theme = require("menubar.icon_theme")
local recolor_image = require("gears.color").recolor_image
local Playerctl = require("lgi").Playerctl
local manager = Playerctl.PlayerManager()

local helperIcon = require("helpers.icon")

local M = {}
local function get_player_by_instance(instance)
	if instance == nil then
		return manager.players[1]
	end

	for _, player in ipairs(manager.players) do
		if player.player_instance == instance then
			return player
		end
	end

	return nil
end

function M.play_pause(instance)
	local player = get_player_by_instance(instance)
	if player ~= nil then
		player:play_pause()
	end
end

function M.pause(instance)
	local player = get_player_by_instance(instance)
	if player ~= nil then
		player:pause()
	end
end

function M.play(instance)
	local player = get_player_by_instance(instance)
	if player ~= nil then
		player:play()
	end
end

function M.previous(instance)
	local player = get_player_by_instance(instance)
	if player ~= nil then
		player:previous()
	end
end

function M.next(instance)
	local player = get_player_by_instance(instance)
	if player ~= nil then
		player:next()
	end
end

local players = {}
local player_icon = {}

local function debug(prefix, data, key)
	require("gears.debug").print_warning(prefix .. " => " .. require("gears.debug").dump_return(data, key, 3))
end

local function indexOf(array, value)
	for i, v in ipairs(array) do
		if v == value then
			return i
		end
	end
	return nil
end

local function save_image_async_curl(url, filepath, callback)
	awful.spawn.with_line_callback(string.format("curl -L -s %s -o %s", url, filepath), {
		exit = callback,
	})
end

local function emit_metadata(player)
	if player_icon[player.player_name] == nil then
		player_icon[player.player_name] = helperIcon.search_apps_icon(player.player_name)
	end

	local art_url = gears.string.xml_escape(player:print_metadata_prop("mpris:artUrl") or "")

	local metadata = {
		player_instance = player.player_instance,
		player_name = player.player_name,
		status = player.playback_status,
		artist = gears.string.xml_escape(player:get_artist() or ""),
		title = gears.string.xml_escape(player:get_title() or ""),
		album = gears.string.xml_escape(player:get_album() or ""),
		art_path = nil,
		icon_path = player_icon[player.player_name],
	}

	if art_url ~= "" then
		art_url = art_url:gsub("open.spotify.com", "i.scdn.co")
		local art_path = os.tmpname()
		save_image_async_curl(art_url, art_path, function()
			metadata.art_path = art_path
			players[metadata.player_instance] = gears.table.crush(players[metadata.player_instance] or {}, metadata)
			awesome.emit_signal("signal::playerctl::metadata", players[metadata.player_instance])
		end)
	else
		players[metadata.player_instance] = gears.table.crush(players[metadata.player_instance] or {}, metadata)
		awesome.emit_signal("signal::playerctl::metadata", players[metadata.player_instance])
	end
end

local function emit_playback_status(player, status)
	players[player.player_instance].status = status
	awesome.emit_signal("signal::playerctl::metadata", players[player.player_instance])
end

local function configure_player(player)
	gears.timer({
		timeout = 1,
		autostart = true,
		single_shot = true,
		callback = function()
			manager:move_player_to_top(player)
			emit_metadata(player)
		end,
	})

	player.on_metadata = function()
		manager:move_player_to_top(player)
		emit_metadata(player)
	end

	player.on_playback_status = function()
		manager:move_player_to_top(player)
		emit_playback_status(player, player.playback_status)
	end
end

local function init_player(name, manager)
	local player = Playerctl.Player.new_from_name(name)
	manager:manage_player(player)
end

gears.timer.delayed_call(function()
	for _, name in ipairs(manager.player_names) do
		init_player(name, manager)
	end

	for _, player in ipairs(manager.players) do
		configure_player(player)
	end

	function manager:on_name_appeared(name)
		debug("on_name_appeared", name)
		init_player(name, manager)
	end

	function manager:on_player_appeared(player)
		configure_player(player)
	end

	function manager:on_name_vanished(name)
		debug("on_name_vanished", name)
		table.remove(players, indexOf(players, name))
		awesome.emit_signal("signal::playerctl::player-vanished", name, name)
	end

	function manager:on_player_vanished(player)
		table.remove(players, indexOf(players, player.player_instance))
		awesome.emit_signal("signal::playerctl::player-vanished", player.player_instance, player.player_name)
	end
end)

return M
