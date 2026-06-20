-- lua/plugins/render-markdown.lua
-- Inline rendering for markdown: headings, code blocks, lists, tables, callouts.
-- Pairs with the marksman LSP already configured for markdown.
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- treesitter parsers (markdown, markdown_inline) come from plugins/treesitter.lua
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    ---@module "render-markdown"
    ---@type render.md.UserConfig
    opts = {
      -- render in normal/command mode; switch back to raw text in insert mode so
      -- editing stays unambiguous
      render_modes = { "n", "c" },
      completions = { lsp = { enabled = true } },
    },
  },
}
