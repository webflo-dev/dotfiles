local M = {}

function M.on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = true

  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    command = "EslintFixAll",
  })
end

M.settings = {
  autoFixOnSave = true,
  format = {
    enable = true,
  },
  codeActionOnSave = {
    enable = true,
    mode = "all",
    showDocumentation = true,
  },
  validate = "on",
  workingDirectory = {
    mode = "location",
  },
}

return M
