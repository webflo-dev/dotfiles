local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")

local helperString = require("helpers.string")

local STATE = {
	IDLE = "idle",
	SELECTING = "selecting",
}

local __signals = {
	toggle = "signal::screenshot",
	[STATE.IDLE] = "signal::screenshot::idle",
	[STATE.SELECTING] = "signal::screenshot::selecting",
}

local __state = STATE.IDLE

local function send_notification(message)
	naughty.notification({
		app_name = "Screenshot",
		timeout = 3,
		title = "<b>Screenshot</b>",
		icon = beautiful.svg.camera,
		message = message,
	})
end

local take_screenshot = function(callback)
	local filename = helperString.getTimestampeFileName("~/Pictures/Screenshots/screenshot_%s.mp4")
	local cmd = string.format([[ maim -f png -s -b 4 -c 1,0,0 %s ]], filename)

	awful.spawn.easy_async_with_shell(cmd, function(stdout, stderr, exit_reason, exit_code)
		callback(exit_code == 0)
	end)
end

awesome.connect_signal(__signals.toggle, function()
	if __state == STATE.IDLE then
		__state = STATE.SELECTING
		awesome.emit_signal(__signals[__state])
		take_screenshot(function(success)
			if success == true then
				send_notification("screenshot taken")
			else
				send_notification("screenshot cancelled")
			end
			__state = STATE.IDLE
			awesome.emit_signal(__signals[__state])
		end)
	elseif __state == STATE.SELECTING then
		__state = STATE.IDLE
		send_notification("screenshot cancelled")
		awesome.emit_signal(__signals[__state])
	end
end)

return __signals
