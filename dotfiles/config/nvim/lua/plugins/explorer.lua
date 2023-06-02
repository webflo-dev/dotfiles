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
}
