local M = {}

local opts = {
	-- underline = true,
	underline = {
		-- Do not underline text when severity is low (INFO or HINT).
		severity = { min = vim.diagnostic.severity.WARN },
	},
	update_in_insert = false,
	-- virtual_text = {
	--   only_current_line = true
	-- },
	virtual_text = {
		spacing = 4,
		prefix = "■",
	},
	severity_sort = true,
	signs = true,
	float = {
		focusable = false,
		-- style = "minimal",
		border = "rounded",
		scope = "line",
		source = "always",
		header = "",
		prefix = "",
	},
}

local diagnostics_float_config = {
	focusable = false,
	close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
	border = "rounded",
	source = "always",
	prefix = " ",
	scope = "cursor",
}

function M.setup()
	for name, icon in pairs(require("icons").diagnostics) do
		name = "DiagnosticSign" .. name
		vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
	end
	vim.diagnostic.config(opts)
end

function M.diagnostics_float_handler()
	-- Immediately return if the screen width can show virtual text
	-- Mostly done for window splits and termux
	if vim.fn.winwidth(0) > 100 then
		return
	end

	local cword = vim.fn.expand("<cword>")
	if cword ~= vim.w.lsp_diagnostics_cword then
		vim.w.lsp_diagnostics_cword = cword

		local _, winnr = vim.diagnostic.open_float(diagnostics_float_config)
		if winnr ~= nil then
			vim.api.nvim_win_set_option(winnr, "winblend", 20)
		end
	end
end

return M
