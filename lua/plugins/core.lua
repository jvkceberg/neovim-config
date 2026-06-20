-- lua/plugins/core.lua
return {
  {
    "stevearc/conform.nvim",
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lsp"
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "nvim-lspconfig", words = { "lspconfig" } },
        { path = "noice.nvim", words = { "noice", "Noice" } },
        { path = "lazy.nvim" },
      },
    },
  },
}
