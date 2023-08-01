local gears = require("gears")
local awful = require("awful")

local function all(processes, predicate)
	for _, process in ipairs(processes) do
		if predicate(process) == false then
			return false
		end
	end
	return true
end

local function watch_status()
	awful.spawn.easy_async_with_shell(
		[[ set -o pipefail; /home/florent/dev/castor/scripts/castor status | tail -n +2 | awk '{print $1, $3}' ]],
		function(stdout, stderr, exit_reason, exit_code)
			if exit_code ~= 0 then
				awesome.emit_signal("signals::overmind", "error", stderr, exit_code)
				return
			end

			local processes = gears.string.split(stdout:sub(1, -2), "\n")

			local all_process = {}

			for _, process in ipairs(processes) do
				local name, status = table.unpack(gears.string.split(process, " "))
				all_process[name] = {
					name = name,
					status = status,
					running = status == "running",
				}
				awesome.emit_signal("signals::overmind::process", all_process[name])
			end

			local global_status = "incomplete"
			if all(all_process, function(process)
				return process.running == true
			end) == true then
				global_status = "running"
			end

			if all(all_process, function(process)
				return process.running == false
			end) == false then
				global_status = "stopped"
			end

			awesome.emit_signal("signals::overmind::all", global_status)
		end
	)
end

local timer = gears.timer({
	timeout = 2,
	call_now = true,
	autostart = true,
	callback = watch_status,
})

local M = {}

function M.start_process(name)
	timer:stop()
	awful.spawn.easy_async_with_shell(
		string.format([[ /home/florent/dev/castor/scripts/castor restart %s ]], name),
		function()
			timer:again()
		end
	)
end

function M.stop_process(name)
	timer:stop()
	awful.spawn.easy_async_with_shell(
		string.format([[ /home/florent/dev/castor/scripts/castor stop %s ]], name),
		function()
			timer:again()
		end
	)
end

function M.log_process(name)
	timer:stop()
	awful.spawn.easy_async_with_shell(
		string.format(
			[[ terminal --float --title overmind --command "/home/florent/dev/castor/scripts/castor connect %s" ]],
			name
		),
		function()
			timer:again()
		end
	)
end

return M
