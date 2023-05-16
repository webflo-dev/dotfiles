local awful = require("awful")

awful.widget.watch("rfkill list bluetooth", 2, function(_, stdout)
  if (stdout and stdout ~= '') then
    awesome.emit_signal("bluetooth::state", stdout:match("Soft blocked: yes") and "off" or "on")
  end
  collectgarbage("collect")
end)
