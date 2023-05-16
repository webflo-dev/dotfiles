local M = {}

function M.float_term(cmd, opts)
	opts = vim.tbl_deep_extend("force", {
		size = { width = 0.9, height = 0.9 },
	}, opts or {})
	require("lazy.util").float_term(cmd, opts)
end

function M.has_plugin(name)
	return require("lazy.core.config").plugins[name] ~= nil
end

function M.functionOrCommand(functionOrCmd)
	if type(functionOrCmd) == "function" then
		return functionOrCmd
	end

	if type(functionOrCmd) == "string" then
		return "<cmd>" .. functionOrCmd .. "<cr>"
	end
end

function M.get_lua_files_from_dir(dir)
	local files = {}
	for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/" .. dir, [[v:val =~ '\.lua$']])) do
		files[#files + 1] = file:gsub("%.lua$", "")
	end
	return files
end

return M
