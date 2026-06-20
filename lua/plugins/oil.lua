---@type oil.SetupOpts
local opts = {
  -- make oil the default file explorer (replaces netrw)
  default_file_explorer = true,

  ---@type oil.ColumnSpec[]
  columns = {
    "icon",
  },

  ---@type oil.SetupViewOptions
  view_options = {
    show_hidden = false,
  },

  ---@type table<string, any>
  keymaps = {
    ["g?"] = "actions.show_help",
    -- hjkl navigation: l/<CR> enter or open, h goes up to the parent dir
    ["l"] = "actions.select",
    ["<CR>"] = "actions.select",
    ["h"] = "actions.parent",
    ["q"] = "actions.close",
  },
}

return {
  {
    "stevearc/oil.nvim",
    ---@module "oil"
    ---@type oil.SetupOpts
    opts = opts,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- lazy=false: oil must load eagerly to intercept directory args (`nvim .`)
    lazy = false,
    ---@type LazyKeysSpec[]
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory (oil)" },
    },
  },
}
