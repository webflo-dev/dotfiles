local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")

local helperString = require("helpers.string")

local STATE = {
	IDLE = "idle",
	SELECTING = "selecting",
	RECORDING = "recording",
}

local __signals = {
	toggle = "signal::screenrecord",
	[STATE.IDLE] = "signal::screenrecord::idle",
	[STATE.SELECTING] = "signal::screenrecord::selecting",
	[STATE.RECORDING] = "signal::screenrecord::recording",
	tick = "signal::screenrecord:recording:tick",
}

local __state = STATE.IDLE

local stopwatch = {
	elapsed_time = 0,
	timer = nil,
}

function stopwatch:stop()
	if self.timer ~= nil and self.timer.started == true then
		self.timer:stop()
	else
		self.timer = nil
	end
	local time = self.elapsed_time
	self.elapsed_time = 0
	return time
end

function stopwatch:start()
	if self.timer ~= nil then
		if self.timer.started == true then
			self.timer:stop()
		end
		self.timer = nil
	end

	self.elapsed_time = 0
	self.timer = gears.timer({
		timeout = 1,
		call_now = true,
		autostart = true,
		callback = function()
			awesome.emit_signal(__signals.tick, self.elapsed_time)
			self.elapsed_time = self.elapsed_time + 1
		end,
	})
end

local function send_notification(message)
	naughty.notification({
		app_name = "Screen Recorder",
		timeout = 3,
		title = "<b>Video Recorder</b>",
		icon = beautiful.svg.video,
		message = message,
	})
end

local function select_area(callback)
	awful.spawn.easy_async_with_shell(
		[[ slop -b 4 -c 1,0,0 -f "%wx%h :0.0+%x,%y" || exit 1 ]],
		function(stdout, stderr, exit_reason, exit_code)
			if exit_code == 0 then
				local size, geometry = table.unpack(gears.string.split(stdout:sub(1, -2), " "))
				callback(true, size, geometry)
			else
				callback(false)
			end
		end
	)
end

local start_recording = function(size, geometry, callback)
	local filename = helperString.getTimestampeFileName("~/Videos/Recordings/screen_record_%s.mp4")
	local cmd = string.format([[ ffmpeg -f x11grab -r 60 -s %s -i %s -c:v libx264 -y %s ]], size, geometry, filename)

	stopwatch:start()
	awful.spawn.easy_async_with_shell(cmd, function(stdout, stderr, exit_reason, exit_code)
		callback(exit_code == 255)
	end)
end

local stop_recording = function()
	local elapsed_time = stopwatch:stop()
	awful.spawn.easy_async_with_shell(
		[[
		ps x | grep 'ffmpeg -f x11grab' | grep -v grep | awk '{print $1}' | xargs kill -2
		]],
		function(stdout) end
	)
	return elapsed_time
end

awesome.connect_signal(__signals.toggle, function()
	if __state == STATE.IDLE then
		__state = STATE.SELECTING
		awesome.emit_signal(__signals[__state])

		select_area(function(success, size, geometry)
			if success == true then
				__state = STATE.RECORDING
				awesome.emit_signal(__signals[__state])
				start_recording(size, geometry, function(success)
					if success == false then
						send_notification("recording failed")
					end
					__state = STATE.IDLE
					awesome.emit_signal(__signals[__state])
				end)
			else
				__state = STATE.IDLE
				send_notification("selection area cancelled")
				awesome.emit_signal(__signals[__state])
			end
		end)
	elseif __state == STATE.SELECTING then
		__state = STATE.IDLE
		send_notification("selection area cancelled")
		awesome.emit_signal(__signals[__state])
	elseif __state == STATE.RECORDING then
		__state = STATE.IDLE
		local elapsed_time = stop_recording()
		send_notification("recording finished!\n\nduration: " .. helperString.elapsedTimeToDuration(elapsed_time))
		awesome.emit_signal(__signals[__state], elapsed_time)
	end
end)

return __signals
