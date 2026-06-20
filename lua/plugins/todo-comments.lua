return {
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- highlight todos as soon as a file is loaded
    event = { "BufReadPost", "BufNewFile" },
    -- todo-comments exposes its setup via `opts`
    opts = {},
    ---@type LazyKeysSpec[]
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find todo comments (telescope)" },
      { "<leader>fT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Find TODO/FIX/FIXME" },
    },
  },
}
