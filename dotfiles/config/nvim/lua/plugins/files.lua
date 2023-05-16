return {

	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	{
		"Sonicfury/scretch.nvim",
		opts = {
			-- backend = "telescope.builtin"
			backend = "fzf-lua",
		},
	},

	{
		"kelly-lin/ranger.nvim",
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
}
