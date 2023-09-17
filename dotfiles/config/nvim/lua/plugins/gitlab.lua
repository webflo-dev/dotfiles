return {
	{
		"harrisoncramer/gitlab.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
		},
		build = function()
			require("gitlab").build()
		end, -- Builds the Go binary
		keys = function(gitlab)
			return {
				{
					"<leader>gls",
					gitlab.summary,
				},
				{
					"<leader>glA",
					gitlab.approve,
				},
				{
					"<leader>glR",
					gitlab.revoke,
				},
				{
					"<leader>glc",
					gitlab.create_comment,
				},
				{
					"<leader>gld",
					gitlab.list_discussions,
				},
			}
		end,
		-- config = function()
		-- 	require("gitlab").setup()
		-- end,
	},
}
