return {
	-- fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			-- { 'nvim-telescope/telescope-live-grep-args.nvim' },
		},
		cmd = "Telescope",
		opts = {
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				path_display = {
					truncate = 1,
				},
				file_ignore_patterns = { "^./.git/", "^node_modules/" },
				layout_strategy = "horizontal",
				sorting_strategy = "ascending",
				winblend = 0,
				color_devicons = true,
				layout_config = {
					prompt_position = "top",
					horizontal = {
						preview_width = function(_, cols, _)
							if cols > 200 then
								return math.floor(cols * 0.4)
							else
								return math.floor(cols * 0.6)
							end
						end,
					},
					vertical = { width = 0.9, height = 0.95, preview_height = 0.5 },
					flex = { horizontal = { preview_width = 0.9 } },
				},
				mappings = {
					i = {
						-- ["<c-t>"] = function(...)
						--   return require("trouble.providers.telescope").open_with_trouble(...)
						-- end,
						["<a-i>"] = function()
							require("telescope.builtin").find_files({ no_ignore = true })
						end,
						["<a-h>"] = function()
							require("telescope.builtin").find_files({ hidden = true })
						end,
						["<C-Down>"] = function(...)
							return require("telescope.actions").cycle_history_next(...)
						end,
						["<C-Up>"] = function(...)
							return require("telescope.actions").cycle_history_prev(...)
						end,
						["<C-f>"] = function(...)
							return require("telescope.actions").preview_scrolling_down(...)
						end,
						["<C-b>"] = function(...)
							return require("telescope.actions").preview_scrolling_up(...)
						end,
					},
					n = {
						["q"] = function(...)
							return require("telescope.actions").close(...)
						end,
					},
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
				buffers = {
					ignore_current_buffer = true,
					sort_lastused = true,
					layout_config = {
						width = 120,
					},
				},
				oldfiles = {
					prompt_title = "History",
				},
				lsp_references = {
					previewer = false,
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)
			telescope.load_extension("fzf")
			telescope.load_extension("notify")
			-- telescope.load_extension('live_grep_args')
		end,
	},
}
