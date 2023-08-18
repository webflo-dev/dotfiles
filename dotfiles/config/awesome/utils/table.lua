local M = {}

function M.omit(source, keys)
	for _, key in ipairs(keys) do
		source[key] = nil
	end
	return source
end

return M
