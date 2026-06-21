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
    show_hidden = true,
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
    config = function(_, o)
      require("oil").setup(o)
      -- disable nvim-cmp completion in oil buffers (it pops up while editing names)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "oil",
        callback = function()
          require("cmp").setup.buffer { enabled = false }
        end,
      })
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    -- lazy=false: oil must load eagerly to intercept directory args (`nvim .`)
    lazy = false,
    ---@type LazyKeysSpec[]
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory (oil)" },
    },
  },
}
