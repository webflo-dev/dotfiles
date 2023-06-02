-- nap.vim (https://github.com/liangxianzhe/nap.nvim)
local Nap = {}

-- Record the last navigation operation.
local _next = nil
local _prev = nil

-- Catch and print the error when executing the command.
---@param command string|function Command to execute.
local call = function(command)
  local ok, result
  if type(command) == "string" then
    ok, result = pcall(vim.cmd, command)
  else
    ok, result = pcall(command)
  end
  if not ok then
    vim.notify(string.format(result), vim.log.levels.WARN, { title = "nap.nvim" })
  end
end

-- Execute either next or prev command based on parameter norp (next_or_prev).
---@param next string|function Command to jump next.
---@param prev string|function Command to jump prev.
---@param norp boolean Next or prev.
local exec = function(next, prev, norp)
  -- Save both command so that we can jump forth and back.
  _next = next
  _prev = prev
  if norp then call(next) else call(prev) end
end

-- Execute the last navigation operation based on parameter norp (next_or_prev).
---@param norp boolean Next or prev.
local exec_last = function(norp)
  if norp and _next ~= nil then
    call(_next)
  elseif not norp and _prev ~= nil then
    call(_prev)
  else
    vim.notify(
      string.format('[nap.nvim] [%s] Nothing to repeat.', norp and 'Next' or 'Previous'),
      vim.log.levels.INFO,
      { title = "nap.nvim", icon = norp and '-->' or '<--' }
    )
  end
end

-- Add keymaps to navigate between Next And Previous.
---@param key string Operator key, usually is a single character.
---@param next string|function Command to jump next.
---@param prev string|function Command to jump next.
---@param next_desc string Description of jump next.
---@param prev_desc string Description of jump next.
---@param modes table|nil Mode for the keybindings.
function Nap.nap(key, next, prev, next_desc, prev_desc, modes)
  local next_prefix = '<c-n>'
  local prev_prefix = '<c-p>'
  local next_key = next_prefix .. key
  local prev_key = prev_prefix .. key
  modes = modes or { "n" }
  for _, mode in pairs(modes) do
    vim.keymap.set(mode, next_key, function() exec(next, prev, true) end, { desc = next_desc })
    vim.keymap.set(mode, prev_key, function() exec(next, prev, false) end, { desc = prev_desc })
  end
end

-- map({ "n", "v", "o" }, "<C-n>", function() exec_last(true) end, { desc = "Repeat next" })
-- map({ "n", "v", "o" }, "<C-p>", function() exec_last(false) end, { desc = "Repeat previous" })

Nap.nap("a", "tabnext", "tabprevious", "Next tab", "Previous tab")
Nap.nap("A", "tablast", "tabfirst", "Last tab", "First tab")

Nap.nap("b", "bnext", "bprevious", "Next buffer", "Previous buffer")
Nap.nap("B", "blast", "bfirst", "Last buffer", "First buffer")

Nap.nap("c", "normal! g,", "normal! g;", "Next change-list item", "Previous change-list item")

Nap.nap("d", vim.diagnostic.goto_next, vim.diagnostic.goto_prev, "Next diagnostic", "Previous diagnostic",
  { "n", "v", "o" })

Nap.nap("f", Nap.next_file, Nap.prev_file, "Next file", "Previous file")
Nap.nap("F", Nap.last_file, Nap.first_file, "Last file", "First file")

Nap.nap("j", Nap.next_jump_list, Nap.prev_jump_list, "Next jump-list item", "Previous jump-list item")

Nap.nap("l", "lnext", "lprevious", "Next item in location list", "Previous item in location list")
Nap.nap("L", "llast", "lfist", "Last item in location list", "First item in location list")
Nap.nap("<C-l>", "lnfile", "lpfile", "Next item in different file in location list",
  "Previous item in different file in location list")

Nap.nap("m", "normal! ]`", "normal [`", "Next lowercase mark", "Previous lowercase mark")

Nap.nap("q", "cnext", "cprevious", "Next item in quickfix list", "Previous item in quickfix list")
Nap.nap("Q", "clast", "cfirst", "Last item in quickfix list", "First item in quickfix list")
Nap.nap("<C-q>", "cnfile", "cpfile", "Next item in different file in quickfix list",
  "Previous item in different file in quickfix list")

Nap.nap("s", "normal! ]s", "normal! [s", "Next spell error", "Previous spell error", { "n", "v", "o" })

Nap.nap("t", "tnext", "tprevious", "Next tag", "Previous tag")
Nap.nap("T", "tlast", "tfirst", "Last tag", "First tag")
Nap.nap("<C-t>", "ptnext", "ptprevious", "Next tag in previous window", "Previous tag in previous window")

Nap.nap("z", "normal! zj", "normal! zk", "Next fold", "Previous fold", { "n", "v", "o" })
