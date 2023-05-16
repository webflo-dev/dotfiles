local utils = require("utils")

return {
	{
		"theprimeagen/harpoon",
		config = function()
			if utils.has_plugin("telescope.nvim") then
				require("telescope").load_extension("harpoon")
			end
		end,
	},
}
