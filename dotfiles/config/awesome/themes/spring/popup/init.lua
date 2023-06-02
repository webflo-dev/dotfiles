require(... .. ".volume")
require(... .. ".mic")

local app_launcher = require(... .. ".app-launcher")()

awesome.connect_signal("popup::app-launcher:show", function()
	app_launcher:toggle()
end)
