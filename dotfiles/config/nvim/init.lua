require("config.options")

require("_lazy")

-- order matter! Cannot automatically require these files
require("config.autocmds")
require("config.filetypes")
require("config.keymaps")
require("config.user_commands")

-- local config_path = vim.fn.stdpath("config")
-- for _, file in ipairs(vim.fn.readdir(config_path .. "/lua/config", [[v:val =~ '\.lua$']])) do
--   require("config." .. file:gsub("%.lua$", ""))
-- end

vim.cmd.colorscheme("tokyonight")
