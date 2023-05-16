local utils = require("utils")

return {
  { "folke/twilight.nvim" },

  {
    "folke/zen-mode.nvim",
    cmd = {
      "ZenMode",
    },
    opts = {
      window = {
        width = 150
      },
      plugins = {
        twilight = { enabled = false },
        gitsigns = { enabled = true },
        kitty = {
          enabled = true,
          -- font = "+4",
        },
        alacritty = {
          enabled = true,
          font = "14",
        },
      },
      -- callback where you can add custom code when the Zen window opens
      on_open = function(win)
        if utils.has_plugin("pets.nvim") then
          vim.cmd("PetsHideToggle")
        end
      end,
      -- callback where you can add custom code when the Zen window closes
      on_close = function()
        if utils.has_plugin("pets.nvim") then
          vim.cmd("PetsHideToggle")
        end
      end,
    },
  },
}
