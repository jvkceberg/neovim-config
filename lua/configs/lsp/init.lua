require("nvchad.configs.lspconfig").defaults()

local path = vim.fn.stdpath("config") .. "/lua/configs/lsp"
local servers = {}

for _, file in ipairs(vim.fn.readdir(path, [[v:val =~ '\.lua$']])) do
  local server = file:gsub("%.lua$", "")

  if server ~= "init" then
    -- merge each server's config table (return value of the file) into vim.lsp.config
    vim.lsp.config(server, require("configs.lsp." .. server))
    table.insert(servers, server)
  end
end

vim.lsp.enable(servers)
