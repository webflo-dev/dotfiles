local gtimer = require("gears.timer")

local function toDuration(elapsed_time)
	local hours = math.floor(elapsed_time / 3600)
	local minutes = math.floor((elapsed_time - (hours * 3600)) / 60)
	local seconds = math.floor(elapsed_time - (hours * 3600) - (minutes * 60))
	if hours == 0 then
		return string.format("%02d:%02d", minutes, seconds)
	end
	return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local M = {}

function M.new()
	local stopwatch = {
		elapsed_time = nil,
		duration = nil,
		timer = nil,
	}

	function stopwatch:stop()
		if self.timer ~= nil and self.timer.started == true then
			self.timer:stop()
		else
			self.timer = nil
		end
	end

	function stopwatch:start(callback)
		if self.timer ~= nil then
			if self.timer.started == true then
				self.timer:stop()
			end
			self.timer = nil
		end

		self.elapsed_time = 0
		self.duration = toDuration(self.elapsed_time)
		self.timer = gtimer({
			timeout = 1,
			call_now = true,
			autostart = true,
			callback = function()
				if callback ~= nil then
					callback(self.elapsed_time, self.duration)
				end
				self.elapsed_time = self.elapsed_time + 1
				self.duration = toDuration(self.elapsed_time)
			end,
		})
	end

	return stopwatch
end

return M
