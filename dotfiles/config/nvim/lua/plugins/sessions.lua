return {
	{
		"webflo-dev/nvim-sessions",
		config = true,
		commands = {
			"Session",
		},
	},

	{
		"aaditeynair/conduct.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		cmd = {
			"ConductNewProject",
			"ConductLoadProject",
			"ConductLoadLastProject",
			"ConductLoadProjectConfig",
			"ConductReloadProjectConfig",
			"ConductDeleteProject",
			"ConductRenameProject",
			"ConductProjectNewSession",
			"ConductProjectLoadSession",
			"ConductProjectDeleteSession",
			"ConductProjectRenameSession",
		},
	},

	-- {
	--   "folke/persistence.nvim",
	--   event = "BufReadPre",
	--   keys = {
	--     {
	--       "<leader>po",
	--       function()
	--         require("persistence").load()
	--       end,
	--       desc = "Load session for current directory",
	--     },
	--     {
	--       "<leader>pl",
	--       function()
	--         require("persistence").load({ last = true })
	--       end,
	--       desc = "Load last session",
	--     },
	--     {
	--       "<leader>pq",
	--       function()
	--         require("persistence").stop()
	--       end,
	--       desc = "Stop session",
	--     },
	--   },
	--   config = true,
	-- },
}
