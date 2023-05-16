local M = {}

function M.attach(client, buffer, autocmd_group)
	vim.api.nvim_create_autocmd("CursorHold", {
		group = autocmd_group,
		buffer = buffer,
		callback = require("essentials.lsp.diagnostics").diagnostics_float_handler,
		desc = "Shows diagnostic in floating window on smaller windows",
	})

	if client.server_capabilities.documentHighlightProvider then
		vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
			group = autocmd_group,
			buffer = buffer,
			callback = vim.lsp.buf.document_highlight,
			desc = "Highlights symbol under cursor",
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			group = autocmd_group,
			buffer = buffer,
			callback = vim.lsp.buf.clear_references,
			desc = "Clears symbol highlighting under cursor",
		})
	end
end

return M
