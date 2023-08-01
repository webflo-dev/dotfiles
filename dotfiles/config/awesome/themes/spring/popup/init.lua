require(... .. ".volume")
require(... .. ".mic")

local app_launcher = require(... .. ".app-launcher")()

awesome.connect_signal("signal::app-launcher", function()
	app_launcher:toggle()
end)
