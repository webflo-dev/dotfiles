local awful = require("awful")
local gobject = require("gears.object")
local gtable = require("gears.table")
local gtimer = require("gears.timer")
local gstring = require("gears.string")

local function all(processes, predicate)
	for _, process in ipairs(processes) do
		if predicate(process) == false then
			return false
		end
	end
	return true
end

local overmind = {}

function overmind:start_process(name)
	self._private.timer:stop()
	awful.spawn.easy_async_with_shell(
		string.format([[ /home/florent/dev/castor/scripts/castor restart %s ]], name),
		function()
			self._private.timer:again()
		end
	)
end

function overmind:stop_process(name)
	self._private.timer:stop()
	awful.spawn.easy_async_with_shell(
		string.format([[ /home/florent/dev/castor/scripts/castor stop %s ]], name),
		function()
			self._private.timer:again()
		end
	)
end

function overmind:log_process(name)
	self._private.timer:stop()
	awful.spawn.easy_async_with_shell(
		string.format(
			[[ terminal --float --title overmind --command "/home/florent/dev/castor/scripts/castor connect %s" ]],
			name
		),
		function()
			self._private.timer:again()
		end
	)
end

local function watch_status(self)
	awful.spawn.easy_async_with_shell(
		[[ set -o pipefail; /home/florent/dev/castor/scripts/castor status | tail -n +2 | awk '{print $1, $3}' ]],
		function(stdout, stderr, _, exit_code)
			if exit_code ~= 0 then
				self:emit_signal("error", stderr, exit_code)
				return
			end

			local processes = gstring.split(stdout:sub(1, -2), "\n")

			local all_process = {}

			for _, process in ipairs(processes) do
				local name, status = table.unpack(gstring.split(process, " "))
				all_process[name] = {
					name = name,
					status = status,
					running = status == "running",
				}
				self:emit_signal("update::process", all_process[name])
			end

			local global_status = "incomplete"
			if all(all_process, function(process)
				return process.status == "running"
			end) == true then
				global_status = "running"
			elseif all(all_process, function(process)
				return process.status == "dead"
			end) == false then
				global_status = "stopped"
			end

			self:emit_signal("update::global", global_status)
		end
	)
end

local function new()
	local ret = gobject({})
	gtable.crush(ret, overmind, true)

	ret._private = {}
	ret._private.timer = gtimer({
		timeout = 2,
		call_now = true,
		autostart = true,
		callback = function()
			watch_status(ret)
		end,
	})

	return ret
end

return new()
