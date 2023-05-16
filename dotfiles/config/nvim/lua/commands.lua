local utils = require("utils")

local M = {}

local function diagnostic_goto(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end

function M.get_commands()
	local actions = {
		lsp = {
			references = vim.lsp.buf.references,
			source_definition = "VtsExec goto_source_definition",
			definition = vim.lsp.buf.definition,
			type_definition = vim.lsp.buf.type_definition,
			implementation = vim.lsp.buf.implementation,
			declaration = vim.lsp.buf.declaration,
			incoming_calls = vim.lsp.buf.incoming_calls,
			outgoing_calls = vim.lsp.buf.outgoing_calls,
			document_symbol = vim.lsp.buf.document_symbol,
			workspace_symbol = vim.lsp.buf.workspace_symbol,
			code_action = vim.lsp.buf.code_action,
			rename = vim.lsp.buf.rename,
			hover = vim.lsp.buf.hover,
			signature_help = vim.lsp.buf.signature_help,
		},
		lists = {
			files = nil,
			oldfiles = nil,
			buffers = "buffers",
			tabs = "tabs",
			command_history = nil,
		},
		search = {
			search_string = nil,
			search_word = nil,
			colorschemes = nil,
		},
		git = {
			commits = nil,
			branch_commits = nil,
			status = nil,
			stash = nil,
			branches = nil,
		},
		diagnostics = {
			show_diagnostic = vim.diagnostic.open_float,
			next_diagnostic = diagnostic_goto(true),
			previous_diagnostic = diagnostic_goto(false),
		},
	}

	if utils.has_plugin("fzf-lua") then
		actions.lsp.references = "FzfLua lsp_references"
		actions.lsp.definition = "FzfLua lsp_definitions"
		actions.lsp.type_definition = "FzfLua lsp_type_definitions"
		actions.lsp.implementation = "FzfLua lsp_implementations"
		actions.lsp.declaration = "FzfLua lsp_declarations"
		actions.lsp.incoming_calls = "FzfLua incoming_calls"
		actions.lsp.outgoing_calls = "FzfLua outgoing_calls"
		actions.lsp.document_symbol = "FzfLua lsp_document_symbols"
		actions.lsp.code_action = "FzfLua lsp_code_actions"

		actions.lists.files = "FzfLua files"
		actions.lists.oldfiles = "FzfLua oldfiles"
		actions.lists.buffers = "FzfLua buffers"
		actions.lists.tabs = "FzfLua tabs"
		actions.lists.command_history = "FzfLua command_history"

		actions.search.search_string = "FzfLua live_grep_resume"
		actions.search.search_word = "FzfLua grep_cword"
		actions.search.colorschemes = "FzfLua colorschemes"

		actions.git.commits = "FzfLua git_commits"
		actions.git.branch_commits = "FzfLua git_bcommits"
		actions.git.status = "FzfLua git_status"
		actions.git.stash = "FzfLua git_stash"
		actions.git.branches = "FzfLua git_branches"
	elseif utils.has_plugin("telescope.nvim") then
		actions.lsp.references = "Telescope lsp_references"
		actions.lsp.definition = "Telescope lsp_definitions"
		actions.lsp.type_definition = "Telescope lsp_type_definitions"
		actions.lsp.implementation = "Telescope lsp_implementations"
		actions.lsp.incoming_calls = "Telescope incoming_calls"
		actions.lsp.outgoing_calls = "Telescope outgoing_calls"
		actions.lsp.document_symbol = "Telescope lsp_document_symbols"

		actions.lists.files = "Telescope find_files hidden=true"
		actions.lists.oldfiles = "Telescope oldfiles"
		actions.lists.buffer = "Telescope buffers show_all_buffers=true"
		actions.lists.command_history = "Telescope command_history"

		actions.search.search_string = "Telescope live_grep"
		actions.search.search_word = "Telescope grep_string"
		actions.search.colorschemes = "Telescope colorscheme enable_preview=true"

		actions.git.commits = "Telescope git_commits"
		actions.git.branch_commits = "Telescope git_bcommits"
		actions.git.status = "Telescope git_status"
		actions.git.stash = "Telescope git_stash"
		actions.git.branches = "Telescope git_branches"
	end

	return actions
end

return M
