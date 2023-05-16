local M = {}

local function lsp_format(buffer)
	if vim.b.format_on_save == false then
		vim.notify("format_on_save is disabled")
		return
	end

	local ft = vim.bo[buffer].filetype
	local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0
	vim.lsp.buf.format({
		bufnr = buffer,
		filter = function(client)
			-- Restrict formatting to client matching this name
			if have_nls then
				return client.name == "null-ls"
			end
			return client.name ~= "null-ls"
		end,
	})
end

function M.attach(client, buffer, autocmd_group)
	if
		client.config
		and client.config.capabilities
		and client.config.capabilities.documentFormattingProvider == false
	then
		vim.notify("not formatting provider:" .. client.name)
		return
	end

	local function format()
		lsp_format(buffer)
	end

	vim.b.format_on_save = true

	vim.api.nvim_buf_create_user_command(buffer, "LspAutoFormatToggle", function()
		if not vim.b.format_on_save then
			vim.notify("Enabling format on save")
		else
			vim.notify("Disabling format on save")
		end
		vim.b.format_on_save = not vim.b.format_on_save
	end, { desc = "Toggle format on save" })

	vim.keymap.set({ "n", "v" }, "<LocalLeader>cf", format, { buffer = buffer, desc = "Format document" })

	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = autocmd_group,
			buffer = buffer,
			callback = format,
			desc = "Format file on save (setup by vim.b.format_on_save)",
		})
	end
end

return M
