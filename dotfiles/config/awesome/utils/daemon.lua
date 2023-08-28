local awful = require("awful")
local gobject = require("gears.object")
local gtable = require("gears.table")

local M = {}

function M.automatic_watch(command, object)
	awful.spawn.with_line_callback(command, {
		stdout = function(line)
			local info = {}

			local category, data = line:match("([%w:]+) (.+)")
			for k, v in string.gmatch(data, "([%w_]+)=([%w_]+)") do
				info[k] = v
			end

			object:emit_signal(category, info)
		end,
	})
end

function M.automatic_watcher(command, methods)
	local ret = gobject({})

	if methods ~= nil then
		gtable.crush(ret, methods, true)
	end

	M.automatic_watch(command, ret)

	return ret
end

return M
