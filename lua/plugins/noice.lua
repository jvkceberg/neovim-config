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

  routes = {
    {
      filter = { event = "notify", find = "No signature help available" },
      opts = { skip = true },
    },
    -- K on a symbol with no hover docs spams "No information available"
    {
      filter = { event = "notify", find = "No information available" },
      opts = { skip = true },
    },
    -- basedpyright re-analyses on every keystroke (diagnosticMode = openFilesOnly)
    -- and emits an LSP progress done message each time; drop just its progress.
    {
      filter = {
        event = "lsp",
        kind = "progress",
        cond = function(message)
          local client = vim.tbl_get(message.opts, "progress", "client")
          return client == "basedpyright"
        end,
      },
      opts = { skip = true },
    },
  },
}

return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        -- transparency clears Normal's bg, so notify can't derive a colour to
        -- composite against; set it explicitly to silence the startup warning
        opts = {
          background_colour = "#000000",
        },
      },
    },
    opts = opts,
  },
}
