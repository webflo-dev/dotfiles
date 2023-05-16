local awful = require("awful")
local gears = require("gears")
local helperString = require("helpers.string")

local emit_volume_info = function()
  awful.spawn.easy_async_with_shell("printf \"%s|%s\" $(pactl get-sink-volume @DEFAULT_SINK@ | grep '^Volume:' | cut -d / -f 2 | tr -d ' ' | sed 's/%//') $(pactl get-sink-mute @DEFAULT_SINK@ | cut -d: -f2 | tr -d ' ')"
    , function(stdout)
    local values = gears.string.split(helperString.remove_linebreaks(stdout), "|")
    awesome.emit_signal("signal::volume", values[1], values[2] == "yes" and true or false)
  end)
end

-- Run once to initialize widgets
emit_volume_info()

-- Sleeps until pactl detects an event (volume change and/or mute)
local volume_script = [[
    bash -c "
    LANG=C pactl subscribe 2> /dev/null | grep --line-buffered \"Event 'change' on sink\"
    "]]

-- Kill old pactl subscribe processes
awful.spawn.easy_async({
  'pkill', '--full', '--uid', os.getenv('USER'), '^pactl subscribe'
}, function()
  -- Run emit_volume_info() with each line printed
  awful.spawn.with_line_callback(volume_script, {
    stdout = function(line) emit_volume_info() end
  })
end)
