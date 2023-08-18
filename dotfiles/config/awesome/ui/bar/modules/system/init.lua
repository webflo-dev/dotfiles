local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local daemon = require("daemons.system")

local tpl = require("ui.templates")

local system_widget = require(... .. ".base")
local cpu = system_widget({ image = beautiful.svg.cpu })
local memory = system_widget({ image = beautiful.svg.memory })
local gpu = system_widget({ image = beautiful.svg.gpu })

daemon:connect_signal("CPU", function(_, data)
	local value = tonumber(data.usage)
	cpu:update(value)
end)

daemon:connect_signal("MEMORY", function(_, data)
	local value = math.floor(data.used / data.total * 100)
	memory:update(value)
end)

daemon:connect_signal("GPU", function(_, data)
	local value = tonumber(data.usage)
	gpu:update(value)
end)

return tpl.wibar_module({
	cpu,
	memory,
	gpu,
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(20),
})
