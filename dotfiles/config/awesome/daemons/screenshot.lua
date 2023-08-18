local awful = require("awful")
local gobject = require("gears.object")
local gtable = require("gears.table")
local naughty = require("naughty")
local beautiful = require("beautiful")

local getTimestampeFileName = require("utils.string").getTimestampeFileName

local STATE = {
	idle = "idle",
	selecting_area = "selecting_area",
}

local SIGNALS = {
	[STATE.idle] = "idle",
	[STATE.selecting_area] = "selecting_area",
}

local function send_notification(message)
	naughty.notification({
		app_name = "Screenshot",
		timeout = 3,
		title = "<b>Screenshot</b>",
		icon = beautiful.svg.camera,
		message = message,
	})
end

local take_screenshot = function(filename, callback)
	local cmd = string.format([[ maim -f png -s -b 4 -c 1,0,0 %s ]], filename)
	awful.spawn.easy_async_with_shell(cmd, function(_, _, _, exit_code)
		callback(exit_code == 0)
	end)
end

local screenshot = {}

function screenshot:take_screenshot()
	if self._private.state == STATE.idle then
		self._private.state = STATE.selecting_area
		self:emit_signal(SIGNALS[self._private.state])
		local filename = getTimestampeFileName(self._private.folder .. "screenshot_%s.png")
		take_screenshot(filename, function(success)
			if success == true then
				send_notification("screenshot taken")
			else
				send_notification("screenshot cancelled")
			end
			self._private.state = STATE.idle
			self:emit_signal(SIGNALS[self._private.state])
		end)
	else
		self._private.state = STATE.idle
		send_notification("screenshot cancelled")
		self:emit_signal(SIGNALS[self._private.state])
	end
end

local function new()
	local ret = gobject({})
	gtable.crush(ret, screenshot, true)

	ret._private = {}

	ret._private.state = STATE.idle
	ret._private.folder = "~/Pictures/Screenshots/"

	return ret
end

return new()
