return {

	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = {
			"Oil",
		},
	},

	{
		"Sonicfury/scretch.nvim",
		cmd = {
			"Scretch",
		},
		opts = {
			-- backend = "telescope.builtin"
			backend = "fzf-lua",
		},
	},

	{
		"kelly-lin/ranger.nvim",
		lazy = true,
		opts = {
			replace_netrw = true,
			-- keybinds = {
			-- 	["ov"] = ranger_nvim.OPEN_MODE.vsplit,
			-- 	["oh"] = ranger_nvim.OPEN_MODE.split,
			-- 	["ot"] = ranger_nvim.OPEN_MODE.tabedit,
			-- 	["or"] = ranger_nvim.OPEN_MODE.rifle,
			-- },
		},
	},

	{
		"echasnovski/mini.files",
		opts = {
			windows = {
				preview = true,
				width_focus = 100,
				width_preview = 200,
			},
			options = {
				-- Whether to use for editing directories
				-- Disabled by default in LazyVim because neo-tree is used for that
				use_as_default_explorer = false,
			},
		},
		keys = {
			{
				"<leader>z",
				function()
					require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
				end,
				desc = "Open mini.files (directory of current file)",
			},
			{
				"<leader>Z",
				function()
					require("mini.files").open(vim.loop.cwd(), true)
				end,
				desc = "Open mini.files (cwd)",
			},
		},
		config = function(_, opts)
			require("mini.files").setup(opts)
		end,
	},
}
