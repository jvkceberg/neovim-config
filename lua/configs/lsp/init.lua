require("nvchad.configs.lspconfig").defaults()

local path = vim.fn.stdpath("config") .. "/lua/configs/lsp"

for _, file in ipairs(vim.fn.readdir(path, [[v:val =~ '\.lua$']])) do
  local server = file:gsub("%.lua$", "")

  if server ~= "init" then
    require("configs.lsp." .. server)
  end
end
