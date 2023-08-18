local awful = require("awful")
local gobject = require("gears.object")
local gtable = require("gears.table")
local gfilesystem = require("gears.filesystem")

local function new()
	local ret = gobject({})
	gtable.crush(ret, {}, true)

	local script_system = gfilesystem.get_configuration_dir() .. "scripts/system.sh"
	awful.spawn.with_line_callback(script_system, {
		stdout = function(line)
			local info = {}

			local category, data = line:match("([%w:]+) (.+)")
			for k, v in string.gmatch(data, "([%w_]+)=([%w_]+)") do
				info[k] = v
			end

			ret:emit_signal(category, info)
		end,
	})

	return ret
end

return new()
