local awful = require("awful")
local gobject = require("gears.object")
local gtable = require("gears.table")
local gmath = require("gears.math")
local gstring = require("gears.string")

local audio = {}

function audio:set_default_sink(sink)
	awful.spawn(string.format("pactl set-default-sink %d", sink), false)
end

function audio:sink_toggle_mute(sink)
	local sink_id = (sink and "--ID " .. sink) or ""
	awful.spawn(string.format("pulsemixer %s --toggle-mute", sink_id), false)
end

function audio:sink_volume_up(sink, step)
	local sink_id = (sink and "--ID " .. sink) or ""
	awful.spawn(string.format("pulsemixer --max-volume 100 %s --change-volume +%d", sink_id, step or 5), false)
end

function audio:sink_volume_down(sink, step)
	local sink_id = (sink and "--ID " .. sink) or ""
	awful.spawn(string.format("pulsemixer --max-volume 100 %s --change-volume -%d", sink_id, step or 5), false)
end

function audio:sink_set_volume(sink, volume)
	volume = gmath.round(math.max(100, volume))
	local sink_id = (sink and "--ID " .. sink) or ""
	awful.spawn(string.format("pulsemixer --max-volume 100 %s --set-volume %d", sink_id, volume), false)
end

-- function audio:set_default_source(source)
-- 	awful.spawn(string.format("pactl set-default-source %d", source), false)
-- end
--
-- function audio:source_toggle_mute(source)
-- 	if source == 0 or source == nil then
-- 		awful.spawn(string.format("pactl set-source-mute @DEFAULT_SOURCE@ toggle", source), false)
-- 	else
-- 		awful.spawn(string.format("pactl set-source-mute %d toggle", source), false)
-- 	end
-- end
--
-- function audio:source_volume_up(source, step)
-- 	if source == 0 or source == nil then
-- 		awful.spawn(string.format("pactl set-source-volume @DEFAULT_SOURCE@ +%d%%", step), false)
-- 	else
-- 		awful.spawn(string.format("pactl set-source-volume %d +%d%%", source, step), false)
-- 	end
-- end
--
-- function audio:source_volume_down(source, step)
-- 	if source == 0 or source == nil then
-- 		awful.spawn(string.format("pactl set-source-volume @DEFAULT_SOURCE@ -%d%%", step), false)
-- 	else
-- 		awful.spawn(string.format("pactl set-source-volume %d -%d%%", source, step), false)
-- 	end
-- end
--
-- function audio:source_set_volume(source, volume)
-- 	volume = gmath.round(volume)
--
-- 	if source == 0 or source == nil then
-- 		awful.spawn(string.format("pactl set-source-volume @DEFAULT_SOURCE@ %d%%", volume), false)
-- 	else
-- 		awful.spawn(string.format("pactl set-source-volume %d %d%%", source, volume), false)
-- 	end
-- end
--
-- function audio:sink_input_toggle_mute(sink_input)
-- 	awful.spawn(string.format("pactl set-sink-input-mute %d toggle", sink_input), false)
-- end
--
-- function audio:sink_input_set_volume(sink_input, volume)
-- 	volume = gmath.round(volume)
--
-- 	awful.spawn(string.format("pactl set-sink-input-volume %d %d%%", sink_input, volume), false)
-- end
--
-- function audio:source_output_toggle_mute(source_output)
-- 	awful.spawn(string.format("pactl set-source-output-mute %d toggle", source_output), false)
-- end
--
-- function audio:source_output_set_volume(source_output, volume)
-- 	volume = gmath.round(volume)
--
-- 	awful.spawn(string.format("pactl set-source-output-volume %d %d%%", source_output, volume), false)
-- end

local function on_device_updated(self, type, id)
	local default_device = "@DEFAULT_" .. string.upper(type) .. "@"

	local device = {
		id = id or default_device,
		type = type,
		default = id == default_device,
	}

	local cmd = string.format(
		[[ pactl get-%s-volume %s | grep '^Volume:' | cut -d/ -f2 | sed 's/%%//'; pactl get-%s-mute %s | cut -d: -f2 | sed 's/ //' ]],
		device.type,
		device.id,
		device.type,
		device.id
	)
	awful.spawn.easy_async_with_shell(cmd, function(stdout)
		local info = gstring.split(stdout, "\n")
		device.volume = tonumber(info[1])
		device.mute = (info[2] == "yes" and true) or false

		local signal = string.format("%s::%s::updated", device.type, device.id)
		self:emit_signal(signal, device)
		if device.default == true then
			self:emit_signal(string.format("%s::default::updated", device.type), device)
		end
	end)
end

local function new()
	local ret = gobject({})
	gtable.crush(ret, audio, true)

	ret._private = {}

	on_device_updated(ret, "sink", "@DEFAULT_SINK@")
	on_device_updated(ret, "source", "@DEFAULT_SOURCE@")

	awful.spawn.easy_async("pkill --full --uid " .. os.getenv("USER") .. " 'pactl subscribe'", function()
		awful.spawn.with_line_callback(
			[[ pactl subscribe | grep --line-buffered "Event 'change' on sink\|Event 'change' on source" ]],
			{
				stdout = function(line)
					if line:match("Event 'change' on sink #") then
						-- local id = line:match("Event 'change' on sink #(.*)")
						on_device_updated(ret, "sink", "@DEFAULT_SINK@")
					elseif line:match("Event 'change' on source #") then
						-- local id = line:match("Event 'change' on source #(.*)")
						on_device_updated(ret, "source", "@DEFAULT_SOURCE@")
					end
				end,
			}
		)
	end)

	return ret
end

return new()
