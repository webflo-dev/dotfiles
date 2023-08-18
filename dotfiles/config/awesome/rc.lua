local awful = require("awful")
local gtimer = require("gears.timer")
local gfilesystem = require("gears.filesystem")
local beautiful = require("beautiful")

__Debug = function(prefix, data, key)
	require("gears.debug").print_warning(prefix .. " => " .. require("gears.debug").dump_return(data, key, 3))
end

require("awful.autofocus")

local collectgarbage = collectgarbage
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

local memory_last_check_count = collectgarbage("count")
local memory_last_run_time = os.time()
local memory_growth_factor = 1.1 -- 10% over last
local memory_long_collection_time = 300 -- five minutes in seconds

gtimer.start_new(5, function()
	local cur_memory = collectgarbage("count")
	-- instead of forcing a garbage collection every 5 seconds
	-- check to see if memory has grown enough since we last ran
	-- or if we have waited a sificiently long time
	local elapsed = os.time() - memory_last_run_time
	local waited_long = elapsed >= memory_long_collection_time
	local grew_enough = cur_memory > (memory_last_check_count * memory_growth_factor)
	if grew_enough or waited_long then
		collectgarbage("collect")
		collectgarbage("collect")
		memory_last_run_time = os.time()
	end
	-- even if we didn't clear all the memory we would have wanted
	-- update the current memory usage.
	-- slow growth is ok so long as it doesn't go unchecked
	memory_last_check_count = collectgarbage("count")
	return true
end)

beautiful.init(require("theme"))
require("core")
require("ui")

awful.spawn.with_shell(gfilesystem.get_configuration_dir() .. "autostart.sh")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")
