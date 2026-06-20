local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    rust = { "rustfmt", lsp_format = "fallback" },
    -- ruff replaces black + isort; ruff_organize_imports runs before ruff_format
    python = { "ruff_organize_imports", "ruff_format" },
  },

  -- format on save; fall back to the LSP formatter for filetypes without a
  -- dedicated formatter above
  format_on_save = {
    timeout_ms = 500,
    lsp_format = "fallback",
  },
}

return options
