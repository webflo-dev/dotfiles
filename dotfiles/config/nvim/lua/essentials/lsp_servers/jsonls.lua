local M = {}

function M.on_new_config(new_config)
  new_config.settings.json.schemas = new_config.settings.json.schemas or {}
  vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
end

M.settings = {
  json = {
    schemas = {
      {
        fileMatch = { ".prettierrc.js" },
        url = "https://json.schemastore.org/prettierrc.json"
      },
    },
    format = {
      enable = true,
    },
    validate = {
      enable = true
    },
  },
}

return M
