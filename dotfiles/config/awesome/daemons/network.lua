local awful = require("awful")
local gfilesystem = require("gears.filesystem")
local gstring = require("gears.string")

local utils = require("utils.daemon")

local network = {}

function network:get_devices_info(callback)
	awful.spawn.easy_async_with_shell([[ nmcli -t device | grep 'ethernet\|wifi' ]], function(stdout)
		stdout = stdout:gsub("\n", "")
		local devices = {}
		for line in stdout:gmatch("[^\r\n]+") do
			local data = gstring.split(line, ":")
			table.insert(devices, {
				device = data[1],
				type = data[2],
				state = data[3],
				connection = data[4] or nil,
			})
		end
		callback(devices)
	end)
end

local function new()
	local script_network = gfilesystem.get_configuration_dir() .. "scripts/network.sh"
	return utils.automatic_watcher(script_network, network)
end

return new()
