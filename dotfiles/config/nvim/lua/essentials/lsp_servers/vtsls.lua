local default_config = require("vtsls").lspconfig
-- vim.print(require("vtsls").lspconfig)

local M = default_config

M.default_config.on_attach = function(client, buffer)
	-- client.server_capabilities.documentFormattingProvider = false
	vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

M.default_config.settings = {
	completions = {
		completeFunctionCalls = true,
	},
	typescript = {
		inlayHints = {
			includeInlayParameterNameHints = "literals",
			-- includeInlayParameterNameHints = 'all',
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayVariableTypeHintsWhenTypeMatchesName = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		},
	},
	javascript = {
		inlayHints = {
			includeInlayParameterNameHints = "literals",
			-- includeInlayParameterNameHints = 'all',
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayVariableTypeHintsWhenTypeMatchesName = true,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayEnumMemberValueHints = true,
		},
	},
}

-- vim.print(M)

return M
