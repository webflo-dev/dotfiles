local utils = require("utils")

return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = "Mason",
		opts = {
			ensure_installed = {
				"prettier",
				"prettierd",
				-- "shellcheck",
				"stylua",
				-- "luacheck",
				-- "luaformatter",
			},
			ui = {
				border = "rounded",
			},
		},
		config = function(plugin, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end,
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"b0o/SchemaStore.nvim",
		},
		opts = {
			autoformat = true,
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			servers = {
				"awk_ls",
				"bashls",
				"cssls",
				"cssmodules_ls",
				"dockerls",
				"eslint",
				"gopls",
				"graphql",
				"html",
				"jsonls",
				"lua_ls",
				-- "lua-language-server",
				"prismals",
				"rust_analyzer",
				-- "tsserver",
				-- "vtsls",
				"yamlls",
			},
		},
		config = function(plugin, opts)
			local lsp_autocmd_group = vim.api.nvim_create_augroup("LspAutocmds", { clear = true })
			local custom_attach_files = utils.get_lua_files_from_dir("essentials/lsp_attach")

			-- setup lsconfig
			require("mason-lspconfig").setup({ ensure_installed = opts.servers })

			require("essentials.lsp.diagnostics").setup()
			require("essentials.lsp.handlers").setup()

			-- setup formatting and keymaps
			vim.api.nvim_create_autocmd("LspAttach", {
				group = lsp_autocmd_group,
				callback = function(args)
					local buffer = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)

					require("essentials.lsp.autocmds").attach(client, buffer, lsp_autocmd_group)
					require("essentials.lsp.formatting").attach(client, buffer, lsp_autocmd_group)
					require("essentials.lsp.keymaps").attach(client, buffer, lsp_autocmd_group)
					for _, file in ipairs(custom_attach_files) do
						require("essentials.lsp_attach." .. file).attach(client, buffer, lsp_autocmd_group)
					end
				end,
			})

			-- setup LSP servers
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			if utils.has_plugin("cmp-nvim-lsp") then
				capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
			end

			local function setup(server)
				local custom_config_exists, custom_config = pcall(require, "essentials.lsp_servers." .. server)
				local server_opts = {
					capabilities = capabilities,
				}

				if custom_config_exists then
					if type(custom_config) == "function" then
						custom_config = custom_config()
					end
					server_opts = vim.tbl_deep_extend("force", server_opts, custom_config)
				end

				if utils.has_plugin("coq_nvim") then
					server_opts = require("coq").lsp_ensure_capabilities(server_opts)
				end

				require("lspconfig")[server].setup(server_opts)
			end

			-- require("lspconfig.configs").vtsls = require("vtsls").lspconfig
			require("mason-lspconfig").setup_handlers({ setup })
		end,
	},

	-- {
	-- 	"yioneko/nvim-vtsls",
	-- 	ft = {
	-- 		"javascript",
	-- 		"javascriptreact",
	-- 		"typescript",
	-- 		"typescriptreact",
	-- 	},
	-- 	dependencies = { "nvim-lspconfig" },
	-- },

	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {
			on_attach = function(client, buffer)
				-- client.server_capabilities.documentFormattingProvider = false
				vim.api.nvim_buf_set_option(buffer, "omnifunc", "v:lua.vim.lsp.omnifunc")
			end,
			settings = {
				tsserver_file_preferences = {
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
		},
	},

	{
		"lvimuser/lsp-inlayhints.nvim",
		lazy = true,
		config = true,
		-- init = function() end,
	},
}
