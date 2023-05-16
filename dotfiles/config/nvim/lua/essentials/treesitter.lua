return {
	{ "JoosepAlviste/nvim-ts-context-commentstring" },

	{
		"echasnovski/mini.comment",
		version = false,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			hooks = {
				pre = function()
					require("ts_context_commentstring.internal").update_commentstring({})
				end,
			},
		},
		config = function(_, opts)
			require("mini.comment").setup(opts)
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		version = false, -- last release is way too old and doesn't work on Windows
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
			{ "nvim-treesitter/nvim-treesitter-context" },
			-- { "nvim-treesitter/playground", lazy = true },
		},
		keys = {
			-- { "<c-space>", desc = "Increment selection" },
			-- { "<bs>",      desc = "Schrink selection",  mode = "x" },

			-- Repeat movement with ; and ,
			-- ensure ; goes forward and , goes backward regardless of the last direction
			-- { ";",         require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move_next },
			-- { ",",         require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move_previous },

			-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
			-- { "f",         require("nvim-treesitter.textobjects.repeatable_move").builtin_f },
			-- { "F",         require("nvim-treesitter.textobjects.repeatable_move").builtin_F },
			-- { "t",         require("nvim-treesitter.textobjects.repeatable_move").builtin_t },
			-- { "T",         require("nvim-treesitter.textobjects.repeatable_move").builtin_T },
		},
		opts = {
			ensure_installed = {
				"awk",
				"bash",
				"cmake",
				"css",
				"diff",
				"dockerfile",
				"git_rebase",
				"gitattributes",
				"gitcommit",
				"gitignore",
				"go",
				"gomod",
				"gosum",
				"graphql",
				"html",
				"http",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"jsonnet",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"prisma",
				"python",
				"query",
				"regex",
				"rust",
				"scss",
				"sql",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"yaml",
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
				use_languagetree = true,
			},
			indent = {
				enable = true,
			},
			autopairs = {
				enable = true,
			},
			autotag = {
				enable = true,
			},
			context_commentstring = {
				enable = true,
				enable_autocmd = false, -- use for Commnet.nvim integration
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					-- init_selection = "<C-space>",
					-- node_incremental = "<C-space>",
					init_selection = "<M-space>",
					node_incremental = "<M-space>",
					scope_incremental = "<nop>",
					node_decremental = "<bs>",
				},
			},
			textobjects = {
				lsp_interop = {
					enable = false,
					border = "rounded",
					peek_definition_code = {
						{ "brenoprata10/nvim-highlight-colors" },
						["<leader>pf"] = "@function.outer",
						["<leader>pF"] = "@class.outer",
					},
				},
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["if"] = "@function.inner",
						["ic"] = "@class.inner",
						["ia"] = "@parameter.inner",
						["af"] = "@function.outer",
						["ac"] = "@class.outer",
						["aa"] = "@parameter.outer",
					},
					--selection_modes = {
					--  ['@parameter.outer'] = 'v', -- charwise
					--  ['@function.outer'] = 'V', -- linewise
					--  ['@class.outer'] = '<C-v>', --blockwise
					-- },
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]o"] = "@loop.*",
						-- [']]'] = '@class.outer',
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						-- [']['] = '@class.outer',
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						-- ['[['] = '@class.outer',
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						-- ['[]'] = '@class.outer',
					},
					goto_next = {
						["]g"] = "@conditional.outer",
					},
					goto_previous = {
						["[g"] = "@conditional.outer",
					},
				},
				swap = {
					enable = false,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
}
