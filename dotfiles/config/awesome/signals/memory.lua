local awful = require("awful")

awful.widget.watch(
  [[sh -c "
		free -m | grep 'Mem:' | awk '{printf \"%d@@%d@\", $7, $2}'
		"]],
  1,
  function(_, stdout)
    local available = tonumber(stdout:match("(.*)@@"))
    local total = tonumber(stdout:match("@@(.*)@"))
    local used = total - available

    local used_ram_percentage = (used / total) * 100
    awesome.emit_signal("memory::update", used, used_ram_percentage, total, available)
    collectgarbage("collect")
  end
)
