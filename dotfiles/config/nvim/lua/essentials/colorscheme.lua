return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
      transparent = true,
      dim_inactive = false,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(highlights, colors)
        highlights.CursorLineNr = {
          fg = "#FFFFFF",
        }
        highlights.LineNr = {
          fg = colors.dark5,
        }
        highlights.TreesitterContextLineNumber = {
          fg = highlights.CursorLineNr.fg,
        }

        -- vim.api.nvim_set_hl(0, 'WinSeparator', { fg = 'black', bold = true })
        highlights.VertSplit = {
          fg = "#FFFFFF",
        }
        highlights.WinSeparator = {
          bold = true,
          fg = colors.fg_gutter,
          -- fg = colors.fg_dark
        }

        -- highlights.TreesitterContextBottom = {
        --   underline = true,
        -- }
      end,
    },
  },
  { "decaycs/decay.nvim",   as = "decay" },
  { "Yazeed1s/minimal.nvim" },
  {
    "EdenEast/nightfox.nvim",
    opts = {
      options = {
        transparent = true,
        colorblind = {
          enable = true,
        },
      },
    },
  },
  { "kaiuri/nvim-juliana" },
  { "yazeed1s/oh-lucy.nvim" },
}
