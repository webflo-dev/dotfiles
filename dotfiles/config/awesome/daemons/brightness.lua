local gobject = require("gears.object")
local gtable = require("gears.table")
local awful = require("awful")

local brightness = {}

function brightness:up()
	awful.spawn("light -A 5", false)
end

function brightness:down()
	awful.spawn("light -U 5", false)
end

function brightness:set(value)
	awful.spawn("light -S " .. value, false)
end

local function new()
	local ret = gobject({})
	gtable.crush(ret, brightness, true)

	ret._private = {}

	return ret
end

return new()
