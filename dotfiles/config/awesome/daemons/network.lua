local awful = require("awful")
local gobject = require("gears.object")
local gtable = require("gears.table")
local gfilesystem = require("gears.filesystem")
local gstring = require("gears.string")

local function monitoring(self)
	local script_system = gfilesystem.get_configuration_dir() .. "scripts/network.sh"
	awful.spawn.with_line_callback(script_system, {
		stdout = function(line)
			local info = {}

			local category, data = line:match("([%w:]+) (.+)")
			for k, v in string.gmatch(data, "([%w_]+)=([%w_]+)") do
				info[k] = v
			end

			self:emit_signal(category, info)
		end,
	})
end

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
	local ret = gobject({})
	gtable.crush(ret, network, true)

	monitoring(ret)

	return ret
end

return new()
