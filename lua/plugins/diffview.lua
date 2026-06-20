return {
  {
    "sindrets/diffview.nvim",
    -- single-tabpage interface for cycling through diffs, file history, merges
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewFileHistory",
    },
    ---@type LazyKeysSpec[]
    keys = {
      {
        "<leader>gd",
        "<cmd>DiffviewOpen<cr>",
        desc = "Open diff view",
      },
      {
        "<leader>gD",
        "<cmd>DiffviewClose<cr>",
        desc = "Close diff view",
      },
      {
        "<leader>gh",
        "<cmd>DiffviewFileHistory<cr>",
        desc = "File history (repo)",
      },
      {
        "<leader>gf",
        "<cmd>DiffviewFileHistory %<cr>",
        desc = "File history (current file)",
      },
    },
    opts = {},
  },
}
