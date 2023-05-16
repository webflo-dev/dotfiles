local utils = require("utils")

local M = {}

function M.attach(client, buffer, autocmd_group)
	if client.name == "copilot" and utils.has_plugin("copilot_cmp") then
		require("copilot_cmp")._on_insert_enter()
	end
end

return M
