local awful = require("awful")
local gobject = require("gears.object")
local gtable = require("gears.table")
local gstring = require("gears.string")
local naughty = require("naughty")
local beautiful = require("beautiful")

local getTimestampeFileName = require("utils.string").getTimestampeFileName
local stopwatch = require("utils.stopwatch")

local STATE = {
	idle = "idle",
	selecting_area = "selecting_area",
	recording = "recording",
}

local SIGNALS = {
	[STATE.idle] = "idle",
	[STATE.selecting_area] = "selecting_area",
	[STATE.recording] = "recording",
	tick = "tick",
}

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
		function(stdout, _, _, exit_code)
			if exit_code == 0 then
				local values = gstring.split(stdout:sub(1, -2), " ")
				callback(true, values[1], values[2])
			else
				callback(false)
			end
		end
	)
end

local start_recording = function(size, geometry, filename, callback)
	local cmd = string.format([[ ffmpeg -f x11grab -r 60 -s %s -i %s -c:v libx264 -y %s ]], size, geometry, filename)
	awful.spawn.easy_async_with_shell(cmd, function(_, _, _, exit_code)
		callback(exit_code == 255)
	end)
end

local stop_recording = function()
	awful.spawn.easy_async_with_shell(
		[[ ps x | grep 'ffmpeg -f x11grab' | grep -v grep | awk '{print $1}' | xargs kill -2 ]],
		function() end
	)
end

local recorder = {}

function recorder:is_recording()
	return self._private.state == STATE.recording
end

function recorder:toggle_recording()
	if self._private.state == STATE.idle then
		self._private.state = STATE.selecting_area
		self:emit_signal(SIGNALS[self._private.state])

		select_area(function(success, size, geometry)
			if success == true then
				self._private.state = STATE.recording
				self:emit_signal(SIGNALS[self._private.state])
				self._private.stopwatch:start(function(elapsed_time, duration)
					self:emit_signal(SIGNALS.tick, elapsed_time, duration)
				end)

				local filename = getTimestampeFileName(self._private.folder .. "screen_record_%s.mp4")
				start_recording(size, geometry, filename, function(recording_success)
					if recording_success == false then
						send_notification("recording failed")
					end
					self._private.state = STATE.idle
					self:emit_signal(SIGNALS[self._private.state])
				end)
			else
				self._private.state = STATE.idle
				send_notification("selection area cancelled")
				self:emit_signal(SIGNALS[self._private.state])
			end
		end)
	elseif self._private.state == STATE.selecting_area then
		self._private.state = STATE.idle
		send_notification("selection area cancelled")
		self:emit_signal(SIGNALS[self._private.state])
	elseif self._private.state == STATE.recording then
		self._private.state = STATE.idle
		stop_recording()
		self._private.stopwatch:stop()
		send_notification("recording finished!\n\nduration: " .. self._private.stopwatch.duration)
		self:emit_signal(SIGNALS[self._private.state], {
			elapsed = self._private.stopwatch.elapsed_time,
			duration = self._private.stopwatch.duration,
		})
	end
end

local function new()
	local ret = gobject({})
	gtable.crush(ret, recorder, true)

	ret._private = {}

	ret._private.state = STATE.idle
	ret._private.folder = "~/Videos/Recordings/"
	ret._private.stopwatch = stopwatch.new()

	return ret
end

return new()
