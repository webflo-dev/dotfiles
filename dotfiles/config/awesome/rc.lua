local awful = require "awful"
local gears = require("gears")
local user_variables = require("user_variables")

require("core")
require("themes." .. user_variables.theme)
require("signals")

-- Autorun at startup
awful.spawn.with_shell(gears.filesystem.get_configuration_dir() .. "autostart.sh")


-- Enable sloppy focus, so that focus follows mouse.
-- client.connect_signal("mouse::enter", function(c)
--     c:activate { context = "mouse_enter", raise = false }
-- end)


-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
-- require("awful.hotkeys_popup.keys")


require("awful.autofocus")

--- Enable for lower memory consumption
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
gears.timer({
  timeout = 5,
  autostart = true,
  call_now = true,
  callback = function()
    collectgarbage("collect")
  end,
})
