local icons = require("icons")

return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        marks = false,
        registers = false,
        spelling = {
          enabled = false,
        },
        presets = {
          operators = true,    -- adds help for operators like d, y, ... and registers them for motion / text object completion
          motions = true,      -- adds help for motions
          text_objects = true, -- help for text objects triggered after entering an operator
          windows = true,      -- default bindings on <c-w>
          nav = true,          -- misc bindings to work with windows
          z = true,            -- bindings for folds, spelling and others prefixed with z
          g = true,            -- bindings for prefixed with g
        },
      },
      icons = {
        group = icons.common.folder_open .. " ",
      },
    },
  },
  {
    'mrjones2014/legendary.nvim',
    opts = {
      which_key = { auto_register = true },
      select_prompt = ' Legendary > ',
      -- col_separator_char = '  ',
      icons = {
        keymap = nil,
        command = icons.common.terminal,
        fn = icons.kinds.Function,
        itemgroup = icons.common.folder_open,
      },
    },
  }
}
