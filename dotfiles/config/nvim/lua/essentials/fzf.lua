local icons = require("icons")

local function starts_with(str, start)
  return str:sub(1, #start) == start
end

local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local git_exec = function(selected, opts, cmd)
  local path = require("fzf-lua.path")
  local utils = require("fzf-lua.utils")
  for _, e in ipairs(selected) do
    local file = path.relative(path.entry_to_file(e, opts).path, opts.cwd)
    local _cmd = vim.deepcopy(cmd)
    table.insert(_cmd, file)
    local output = utils.io_systemlist(_cmd)
    if utils.shell_error() then
      ---@diagnostic disable-next-line: deprecated
      utils.err(unpack(output))
      -- elseif not vim.tbl_isempty(output) then
      --   utils.info(unpack(output))
    end
  end
end

local function git_discard(selected, opts)
  local path = require("fzf-lua.path")

  local cmd = path.git_cwd({ "git", "restore", "--staged", "--" }, opts)
  git_exec(selected, opts, cmd)

  cmd = path.git_cwd({ "git", "restore", "--" }, opts)
  git_exec(selected, opts, cmd)
end

local function git_fetch(selected, opts)
  local utils = require("fzf-lua.utils")
  for _, e in ipairs(selected) do
    if not starts_with(e, "*") then
      local branch = trim(e)
      local output = utils.io_systemlist({ "git", "fetch", "origin", branch .. ":" .. branch })
      if utils.shell_error() then
        ---@diagnostic disable-next-line: deprecated
        utils.err(unpack(output))
      else
        vim.notify("branch <" .. branch .. "> fetched successfully")
      end
    end
  end
end

local function git_branch_delete_merged()
  local utils = require("fzf-lua.utils")
  local output = utils.io_systemlist("git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d")
  if utils.shell_error() then
    ---@diagnostic disable-next-line: deprecated
    utils.err(unpack(output))
  else
    vim.notify("merged branches are deleted")
  end
end

return {
  {
    'ibhagwan/fzf-lua',
    event = { "VeryLazy" },
    config = function()
      local utils = require("fzf-lua").utils
      local actions = require("fzf-lua").actions

      local function hl_validate(hl)
        return not utils.is_hl_cleared(hl) and hl or nil
      end

      local function git_status_header()
        local stage = utils.ansi_codes.yellow("<left>")
        local unstage = utils.ansi_codes.yellow("<right>")
        local discard = utils.ansi_codes.yellow("<ctrl-x>")
        return vim.fn.shellescape(
          ("+ - :: %s to stage, %s to unstage, %s to discard"):format(stage, unstage, discard))
      end

      local function git_branches_header()
        local fetch = utils.ansi_codes.magenta("<ctrl-r>")
        local delete_merged = utils.ansi_codes.magenta("<ctrl-x>")
        return vim.fn.shellescape(
          ("%s to fetch\n%s to delete merged branches\n\n"):format(fetch, delete_merged))
      end

      local opts = {
        desc         = "match telescope default highlights|keybinds",
        fzf_bin      = "sk",
        fzf_opts     = {
          -- ["--marker"] = "+",
          ["--keep-right"] = "",
        },
        winopts      = {
          width   = 0.8,
          height  = 0.9,
          preview = {
            hidden       = "nohidden",
            vertical     = "up:45%",
            horizontal   = "right:50%",
            layout       = "flex",
            flip_columns = 120,
          },
          hl      = {
            normal       = hl_validate "TelescopeNormal",
            border       = hl_validate "TelescopeBorder",
            help_normal  = hl_validate "TelescopeNormal",
            help_border  = hl_validate "TelescopeBorder",
            -- builtin preview only
            cursor       = hl_validate "Cursor",
            cursorline   = hl_validate "TelescopePreviewLine",
            cursorlinenr = hl_validate "TelescopePreviewLine",
            search       = hl_validate "IncSearch",
            title        = hl_validate "TelescopeTitle",
          },
        },
        fzf_colors   = {
          ["fg"] = { "fg", "TelescopeNormal" },
          ["bg"] = { "bg", "TelescopeNormal" },
          ["hl"] = { "fg", "TelescopeMatching" },
          ["fg+"] = { "fg", "TelescopeSelection" },
          ["bg+"] = { "bg", "TelescopeSelection" },
          ["hl+"] = { "fg", "TelescopeMatching" },
          ["info"] = { "fg", "TelescopeMultiSelection" },
          ["border"] = { "fg", "TelescopeBorder" },
          ["gutter"] = { "bg", "TelescopeNormal" },
          ["prompt"] = { "fg", "TelescopePromptPrefix" },
          ["pointer"] = { "fg", "TelescopeSelectionCaret" },
          ["marker"] = { "fg", "TelescopeSelectionCaret" },
          ["header"] = { "fg", "TelescopeTitle" },
        },
        colorschemes = {
          -- winopts = { height = 0.33, width = 0.33, },
          winopts = { height = 0.33, width = 0.20, },
        },
        lsp          = {
          symbols = {
            symbol_icons = icons.kinds
          },
        },
        keymap       = {
          builtin = {
            ["<F1>"] = "toggle-help",
            ["<F2>"] = "toggle-fullscreen",
            -- Only valid with the 'builtin' previewer
            ["<F3>"] = "toggle-preview-wrap",
            ["<F4>"] = "toggle-preview",
            ["<F5>"] = "toggle-preview-ccw",
            ["<F6>"] = "toggle-preview-cw",
            ["<C-d>"] = "preview-page-down",
            ["<C-u>"] = "preview-page-up",
            ["<S-left>"] = "preview-page-reset",
          },
          fzf = {
            ["ctrl-z"] = "abort",
            ["ctrl-f"] = "half-page-down",
            ["ctrl-b"] = "half-page-up",
            ["ctrl-a"] = "beginning-of-line",
            ["ctrl-e"] = "end-of-line",
            ["alt-a"] = "toggle-all",
            -- Only valid with fzf previewers (bat/cat/git/etc)
            ["f3"] = "toggle-preview-wrap",
            ["f4"] = "toggle-preview",
            ["ctrl-d"] = "preview-page-down",
            ["ctrl-u"] = "preview-page-up",
            ["ctrl-q"] = "select-all+accept",
          },
        },
        actions      = {
          files = {
            ["default"] = actions.file_edit_or_qf,
            ["ctrl-s"] = actions.file_split,
            ["ctrl-v"] = actions.file_vsplit,
            ["ctrl-t"] = actions.file_tabedit,
            ["alt-q"] = actions.file_sel_to_qf,
            ["alt-l"] = actions.file_sel_to_ll,
          },
          buffers = {
            ["default"] = actions.buf_edit,
            ["ctrl-d"] = actions.buf_split,
            ["ctrl-s"] = actions.buf_split,
            ["ctrl-v"] = actions.buf_vsplit,
            ["ctrl-t"] = actions.buf_tabedit,
          },
        },
        files        = {
          prompt = 'Files❯ ',
        },
        buffers      = {
          keymap = { builtin = { ["<C-d>"] = false } },
          actions = { ["ctrl-x"] = false,["ctrl-d"] = { actions.buf_del, actions.resume } },
        },
        git          = {
          status = {
            no_header = true,
            fzf_opts = {
              ["--header"] = git_status_header()
            },
            actions = {
              ["ctrl-x"] = { git_discard, actions.resume },
            }
          },
          branches = {
            prompt   = 'Branches❯ ',
            cmd      = "git branch --all --color",
            preview  = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
            fzf_opts = {
              ["--header"] = git_branches_header()
            },
            actions  = {
              ["ctrl-r"] = { git_fetch, actions.resume },
              ["ctrl-x"] = { git_branch_delete_merged, actions.resume },
            },
          }
        },
      }

      require("fzf-lua").setup(opts)

      local fzf_config = require("fzf-lua.config")
      fzf_config.set_action_helpstr(git_discard, "git-discard")
      fzf_config.set_action_helpstr(git_fetch, "git-fetch")
      fzf_config.set_action_helpstr(git_branch_delete_merged, "git-delete-merged")

      require("fzf-lua").register_ui_select();
    end
  },
}
