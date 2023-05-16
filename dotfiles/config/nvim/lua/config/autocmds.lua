local custom_group = vim.api.nvim_create_augroup("custom_group_for_autocmds", { clear = true })

-- vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
-- 	group = custom_group,
-- 	command = "checktime",
-- 	desc = "Check if we need to reload the file when it changed",
-- })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = custom_group,
	callback = function()
		vim.highlight.on_yank()
	end,
	desc = "Hihglight on yank",
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = custom_group,
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
	desc = "Resize splits if window got resized",
})

vim.api.nvim_create_autocmd("BufReadPost", {
	group = custom_group,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
	desc = "Go to last loc when opening a buffer",
})

vim.api.nvim_create_autocmd("FileType", {
	group = custom_group,
	pattern = {
		"qf",
		"help",
		"man",
		"notify",
		"lspinfo",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"PlenaryTestPopup",
		"gitsigns",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
	desc = "Close some filetypes with <q>",
})
vim.api.nvim_create_autocmd("BufEnter", {
	group = custom_group,
	pattern = "*",
	callback = function(params)
		-- Map q to exit in non-filetype/non-listed buffer
		if vim.bo.buftype == "nofile" or not vim.bo.buflisted then
			vim.keymap.set("n", "q", ":q<CR>", { buffer = params.buf, silent = true })
		end
	end,
	desc = "Maps <q> to exit on non-filetypes",
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = custom_group,
	pattern = "term://*",
	callback = function()
		vim.cmd([[
      setlocal nonu
      setlocal nornu
      setlocal nolist
      setlocal signcolumn=no
      setlocal foldcolumn=0
      setlocal statuscolumn=
      setlocal nocursorline
      setlocal scrolloff=0
      startinsert
    ]])
	end,
	desc = "Set options for terminal buffers",
})

vim.api.nvim_create_autocmd("FileType", {
	group = custom_group,
	pattern = { "json", "jsonc" },
	callback = function()
		vim.wo.conceallevel = 0
	end,
	desc = "Disable conceal for json files",
})

vim.api.nvim_create_autocmd("FileType", {
	group = custom_group,
	pattern = { "lspinfo", "null-ls-info" },
	callback = function()
		-- Add border to `:LspInfo` and `:NullLsInfo` commands
		-- https://github.com/neovim/nvim-lspconfig/issues/1717
		vim.api.nvim_win_set_config(0, { border = "rounded" })
	end,
	desc = "Set borders to few floating windows",
})

-- vim.api.nvim_create_autocmd("FileType", {
-- 	group = custom_group,
-- 	pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
-- 	callback = function()
-- 		vim.opt_local.spell = true
-- 		-- When a word is CamelCased, assume "Cased" is a separate word
-- 		vim.opt_local.spelloptions:append("camel")
-- 	end,
-- 	desc = "ECMA specific file settings",
-- })
