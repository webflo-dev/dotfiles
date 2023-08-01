local M = {}

function M.attach(client, buffer, autocmd_group)
	local functionOrCommand = require("utils").functionOrCommand

	local function map(mode, key, cmd, desc)
		vim.keymap.set(mode, key, functionOrCommand(cmd), { buffer = buffer, desc = desc })
	end

	local keymaps = require("commands").get_commands()

	map("n", "<leader>cd", keymaps.diagnostics.show_diagnostic, "Show line diagnostics")
	map("n", "]d", keymaps.diagnostics.next_diagnostic, "Next diagnostic")
	map("n", "[d", keymaps.diagnostics.previous_diagnostic, "Previous diagnostic")

	map("n", "K", keymaps.lsp.hover, "Hover")
	map("n", "gK", keymaps.lsp.signature_help, "Signature Help")
	map("n", "<localleader>ca", keymaps.lsp.code_action, "Code action")
	map("n", "<localleader>crw", keymaps.lsp.rename, "Rename")
	map("n", "gd", keymaps.lsp.definition, "Go to definition")
	map("n", "gs", keymaps.lsp.source_definition, "Go to source definition")
	map("n", "gD", keymaps.lsp.declaration, "Go to declaration")
	map("n", "gr", keymaps.lsp.references, "Go to reference")
	map("n", "gt", keymaps.lsp.type_definition, "Go to type definition")
	map("n", "gi", keymaps.lsp.implementation, "Go to implementation")
	map("n", "gci", keymaps.lsp.incoming_calls, "Incoming calls")
	map("n", "gco", keymaps.lsp.outgoing_calls, "Outgoing calls")
	map("n", "gS", keymaps.lsp.document_symbol, "Document symbols")
	map("n", "gSw", keymaps.lsp.workspace_symbol, "Workspace symbols")

	map("n", "<LocalLeader>pa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
	map("n", "<LocalLeader>pr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
	map("n", "<LocalLeader>pl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "Print workspace folders")

	if client.name == "vtsls" then
		-- map("n", "<LocalLeader>coi", "VtsExec organize_imports", "Organize Imports")
		map("n", "<LocalLeader>crf", "VtsExec rename_file", "Rename File")
		-- map("n", "<LocalLeader>cmi", "VtsExec add_missing_imports", "Add Missing Imports")
		map("n", "<LocalLeader>cxu", "VtsExec remove_unused_imports", "Remove Unused")
	end

	require("which-key").register({ ["<localleader>c"] = { name = "Code", buffer = buffer } })
	require("which-key").register({ ["<localleader>cr"] = { name = "Rename", buffer = buffer } })
	require("which-key").register({ ["<localleader>cx"] = { name = "Remove", buffer = buffer } })
	require("which-key").register({ ["<localleader>p"] = { name = "Workspace", buffer = buffer } })
end

return M
