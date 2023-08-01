local helpers = {}

function helpers.remove_linebreaks(str)
	return string.gsub(str, "\n", "")
end

function helpers.getTimestampeFileName(filename_format)
	local filename = os.date("%d-%m-%Y-%H:%M:%S")
	local full_path = string.format(filename_format, filename)
	return full_path:gsub("~", os.getenv("HOME"))
end

function helpers.elapsedTimeToDuration(elapsed_time)
	local hours = math.floor(elapsed_time / 3600)
	local minutes = math.floor((elapsed_time - (hours * 3600)) / 60)
	local seconds = math.floor(elapsed_time - (hours * 3600) - (minutes * 60))
	if hours == 0 then
		return string.format("%02d:%02d", minutes, seconds)
	end
	return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

return helpers
