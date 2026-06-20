---@type NoiceConfig
local opts = {
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },

  cmdline = {
    enabled = true,
    view = "cmdline_popup", -- floating cmdline instead of the bottom one
    -- format/icons are inherited from noice defaults
  },

  popupmenu = {
    enabled = true,
    backend = "nui", -- render the completion popupmenu with nui
  },

  presets = {
    bottom_search = false, -- show search in the floating cmdline, not at the bottom
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = false,
  },
}

return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = opts,
  },
}
