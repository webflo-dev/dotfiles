local M = {}

function M.getTimestampeFileName(filename_format)
	local filename = os.date("%Y-%m-%d_%H:%M:%S")
	local full_path = string.format(filename_format, filename)
	return full_path:gsub("~", os.getenv("HOME") or "~")
end

return M
