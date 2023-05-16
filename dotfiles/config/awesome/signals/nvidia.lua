-- nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits
local awful = require("awful")

awful.widget.watch("nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits", 1, function(_, stdout)
  if (stdout and stdout ~= '') then
    awesome.emit_signal("nvidia::update", stdout:sub(1, -2))
  end
  collectgarbage("collect")
end)
