local awful = require("awful")

local function emit()
	awful.spawn.easy_async_with_shell("brightnessctl -m | awk -F, '{print substr($4, 0, length($4)-1)}'", function(out)
		local brightness = math.floor(tonumber(out) or 0)
		awesome.emit_signal("signal::brightness", brightness)
	end)
end

emit()

local subscribe = [[ bash -c "while (inotifywait -e modify /sys/class/backlight/?*/brightness -qq) do echo; done" ]]

awful.spawn.easy_async_with_shell(
	"ps x | grep \"inotifywait -e modify /sys/class/backlight\" | grep -v grep | awk '{print $1}' | xargs kill",
	function()
		awful.spawn.with_line_callback(subscribe, {
			stdout = function()
				emit()
			end,
		})
	end
)

-------------------------------------------

-- Subscribe to backlight changes
-- Requires inotify-tools
local brightness_subscribe_script = [[
   bash -c "
   while (inotifywait -e modify /sys/class/backlight/?*/brightness -qq) do echo; done
"]]

local brightness_script = [[
   sh -c "
   light -G
"]]

local emit_brightness_info = function()
	awful.spawn.with_line_callback(brightness_script, {
		stdout = function(line)
			local percentage = math.floor(tonumber(line) or 0)
			awesome.emit_signal("evil::brightness", percentage)
		end,
	})
end

-- Run once to initialize widgets
emit_brightness_info()

-- Kill old inotifywait process
awful.spawn.easy_async_with_shell(
	"ps x | grep \"inotifywait -e modify /sys/class/backlight\" | grep -v grep | awk '{print $1}' | xargs kill",
	function()
		-- Update brightness status with each line printed
		awful.spawn.with_line_callback(brightness_subscribe_script, {
			stdout = function(_)
				emit_brightness_info()
			end,
		})
	end
)
