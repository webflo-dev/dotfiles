return {
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			search = {
				mode = "search",
			},
		},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					-- default options: exact mode, multi window, all directions, with a backdrop
					require("flash").jump()
				end,
			},
			{
				"S",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
			},
		},
	},
	-- {
	-- 	"ggandor/flit.nvim",
	-- 	keys = function()
	-- 		local ret = {}
	-- 		for _, key in ipairs({ "f", "F", "t", "T" }) do
	-- 			ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
	-- 		end
	-- 		return ret
	-- 	end,
	-- 	opts = { labeled_modes = "nx" },
	-- },
	--
	-- {
	-- 	"ggandor/leap.nvim",
	-- 	keys = {
	-- 		{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
	-- 		{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
	-- 		{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
	-- 	},
	-- 	config = function(_, opts)
	-- 		local leap = require("leap")
	-- 		for k, v in pairs(opts) do
	-- 			leap.opts[k] = v
	-- 		end
	-- 		leap.add_default_mappings(true)
	-- 		vim.keymap.del({ "x", "o" }, "x")
	-- 		vim.keymap.del({ "x", "o" }, "X")
	-- 	end,
	-- },
	--
	{ "chrisgrieser/nvim-spider", lazy = true },

	-- { "echasnovski/mini.jump2d", version = false },

	-- {
	--   "drybalka/tree-climber.nvim",
	--   init = function()
	--     local keyopts = { noremap = true, silent = true }
	--     vim.keymap.set({ "n", "v", "o" }, "H", require("tree-climber").goto_parent, keyopts)
	--     vim.keymap.set({ "n", "v", "o" }, "L", require("tree-climber").goto_child, keyopts)
	--     vim.keymap.set({ "n", "v", "o" }, "J", require("tree-climber").goto_next, keyopts)
	--     vim.keymap.set({ "n", "v", "o" }, "K", require("tree-climber").goto_prev, keyopts)
	--     vim.keymap.set({ "v", "o" }, "in", require("tree-climber").select_node, keyopts, { desc = "select node" })
	--     vim.keymap.set("n", "<c-k>", require("tree-climber").swap_prev, keyopts)
	--     vim.keymap.set("n", "<c-j>", require("tree-climber").swap_next, keyopts)
	--     vim.keymap.set("n", "<c-h>", require("tree-climber").highlight_node, keyopts)
	--   end,
	-- },
}
