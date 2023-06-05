local gears = require("gears")

local player = { mt = {} }

local function new(args)
	args = args or {}

	local ret = gears.object({})
	gears.table.crush(ret, player, true)

	ret._private = {}

	return ret
end

function player.mt:__call(...)
	return new(...)
end

return setmetatable(player, player.mt)
