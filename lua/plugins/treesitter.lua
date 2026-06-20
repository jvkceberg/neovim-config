-- lua/plugins/treesitter.lua
-- Extend NvChad's default `ensure_installed` with parsers for the languages
-- actually used here (research python, hyprland configs, Quickshell QML, notes).
return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- second arg is the opts already accumulated by NvChad's spec, so append
    -- rather than replace its defaults (lua, luadoc, printf, vim, vimdoc)
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "python",
        "bash",
        "markdown",
        "markdown_inline",
        "toml",
        "yaml",
        "json",
        "rust",
        "c",
        "qmljs", -- Quickshell / Qt QML
      })
      return opts
    end,
  },
}
