local awful = require("awful")
local gtimer = require("gears.timer")

local cmd = [[ top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}' ]]

local instance = nil
local function new()

  gtimer { timeout = 1, autostart = true, call_now = true, callback = function()
    awful.spawn.easy_async_with_shell(cmd
      , function(stdout)
      stdout = stdout:gsub("%%", "")
      awesome.emit_signal("cpu::update", math.floor(tonumber(stdout)))
    end)
  end }
end

if not instance then
  instance = new()
end
return instance
