local utils = require("utils")

local M = {}

function M.attach(client, buffer, autocmd_group)
	if not utils.has_plugin("lsp-inlayhints.nvim") then
		return
	end

	vim.api.nvim_buf_create_user_command(buffer, "LspInlayhintsShow", function()
		require("lsp-inlayhints").show()
	end, { desc = "Show LSP inlay hints" })

	vim.api.nvim_buf_create_user_command(buffer, "LspInlayhintsReset", function()
		require("lsp-inlayhints").reset()
	end, { desc = "Hide LSP inlay hints" })

	vim.keymap.set("n", "<LocalLeader>ch", function()
		require("lsp-inlayhints").toggle()
	end, { buffer = buffer, desc = "Toggle LSP inlay hints" })

	require("lsp-inlayhints").on_attach(client, buffer, false)
end

return M
