local utils = require("utils")

local has_words_before = function()
	-- if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function get_lsp_completion_context(completion, source)
	local ok, source_name = pcall(function()
		return source.source.client.config.name
	end)
	if not ok then
		return nil
	end
	if source_name == "tsserver" then
		return completion.detail
	end
end

return {
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			-- snippet engine
			"dcampos/nvim-snippy",
			-- sources
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			-- "petertriho/cmp-git",
			-- "David-Kunz/cmp-npm",
			-- "hrsh7th/cmp-emoji",
			-- {
			-- 	"zbirenbaum/copilot-cmp",
			-- 	dependencies = "copilot.lua",
			-- 	opts = {},
			-- 	config = function(_, opts)
			-- 		local copilot_cmp = require("copilot_cmp")
			-- 		copilot_cmp.setup(opts)
			-- 	end,
			-- },
		},
		opts = function()
			local cmp = require("cmp")
			local has_copilot_cmp = utils.has_plugin("copilot-cmp")

			local format_menu = {
				buffer = "BUFFER",
				nvim_lsp = "LSP",
				path = "PATH",
				snippy = "SNIPPET",
				emoji = "EMOJI",
				codeium = " ",
				copilot = " ",
			}

			local border_opts = {
				border = "single",
				-- winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
				winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel",
			}

			-- require("cmp").setup({
			-- 	window = {
			-- 		completion = cmp.config.window.bordered(border_opts),
			-- 		documentation = cmp.config.window.bordered(border_opts),
			-- 	},
			-- })

			local sources = {
				{ name = "nvim_lsp" },
				{ name = "nvim_lsp_signature_help" },
				{ name = "nvim_lsp_document_symbol" },
				{ name = "copilot" },
				{ name = "codeium" },
				{ name = "buffer", keyword_length = 5 },
				{ name = "path" },
				-- { name = "vim-dadbod-completion" },
				-- { name = "git" },
				-- { name = 'npm',                     keyword_length = 4 },
				-- { name = "emoji" },
			}

			local comparators = {
				-- Below is the default comparitor list and order for nvim-cmp
				cmp.config.compare.offset,
				-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
				cmp.config.compare.exact,
				cmp.config.compare.score,
				cmp.config.compare.recently_used,
				cmp.config.compare.locality,
				cmp.config.compare.kind,
				cmp.config.compare.sort_text,
				cmp.config.compare.length,
				cmp.config.compare.order,
			}

			if has_copilot_cmp then
				table.insert(sources, 1, { name = "copilot" })
				table.insert(comparators, 1, require("copilot_cmp.comparators").prioritize)
			end

			return {
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						require("snippy").expand_snippet(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-u>"] = cmp.mapping.scroll_docs(4),
					["<CR>"] = cmp.mapping.confirm({
						-- select = false,
						select = true,
						behavior = cmp.ConfirmBehavior.Replace,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources(sources),
				sorting = {
					comparators = comparators,
				},
				formatting = {
					fields = { "abbr", "kind", "menu" },
					format = function(entry, item)
						local icons = require("icons").kinds
						if icons[item.kind] then
							item.kind = icons[item.kind] .. item.kind
						end
						item.menu = format_menu[entry.source.name]

						local completion_context = get_lsp_completion_context(entry.completion_item, entry.source)
						if completion_context ~= nil and completion_context ~= "" then
							item.menu = item.menu .. " ・" .. completion_context
						end

						return item
					end,
				},
				window = {
					completion = cmp.config.window.bordered(border_opts),
					documentation = cmp.config.window.bordered(border_opts),
				},
				-- window = {
				--   completion = { border = "rounded", },
				--   documentation = { border = "rounded", },
				-- },
				experimental = {
					ghost_text = {
						hl_group = "LspCodeLens",
					},
				},
			}
		end,
	},
}
