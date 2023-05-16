local awful = require("awful")
local gears = require("gears")

-- awful.widget.watch(
--   [[ nmcli g | tail -n 1 | awk '{ print $1 }' ]],
--   5,
--   function(_, stdout)
--     local net_ssid = stdout
--     net_ssid = string.gsub(net_ssid, "^%s*(.-)%s*$", "%1")

--     local connected = not net_ssid:match("disconnected")

--     if connected then
--       local strength_cmd = [[
--         awk '/^\s*w/ { print  int($3 * 100 / 70) }' /proc/net/wireless
--         ]]
--       awful.spawn.easy_async_with_shell(strength_cmd, function(stdout)
--         local strength = tonumber(stdout)
--         awesome.emit_signal("network::update", connected, strength)
--       end)
--     else
--       awesome.emit_signal("network::update", connected, nil)
--     end
--   end
-- )

awful.widget.watch([[ 
 sh -c "nmcli -get-values DEVICE,TYPE,STATE device status | grep -E \":(wifi|ethernet):(dis)?(connected|connecting)\" "
]], 5,
  function(_, stdout)
    local devices = gears.string.split(stdout:sub(1, -2), "\n")
    local values = {}
    for i, device in ipairs(devices) do
      local name, type, state = table.unpack(gears.string.split(device, ':'))
      values[i] = {
        name = name,
        type = type,
        state = gears.string.split(state, " ")[1]
      }
    end
    awesome.emit_signal("network::update", values)
  end)
