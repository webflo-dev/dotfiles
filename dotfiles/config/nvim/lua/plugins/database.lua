return {
	{
		"kndndrj/nvim-dbee",
		enabled = false,
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		build = function()
			require("dbee").install()
		end,
		opts = {
			lazy = true,
			connections = {
				{
					name = "castor",
					type = "postgres",
					url = "postgres://postgres:postgres@localhost:5432/castor?sslmode=disable",
				},
			},
		},
	},

	{
		"kristijanhusak/vim-dadbod-ui",
		enabled = true,
		dependencies = {
			"tpope/vim-dadbod",
			"kristijanhusak/vim-dadbod-completion",
		},
		-- init = function()
		-- 	vim.g.db_ui_env_variable_url = "postgres://postgres:postgres@localhost:5432/castor"
		-- 	vim.g.db_ui_env_variable_name = "castor"
		-- end,
	},
}
