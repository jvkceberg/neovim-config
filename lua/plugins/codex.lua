return {
  {
    dir = vim.fn.stdpath "config",
    name = "codex.nvim-local",
    cmd = {
      "Codex",
      "CodexFocus",
      "CodexResume",
      "CodexFork",
      "CodexPrompt",
      "CodexAdd",
      "CodexSend",
    },
    config = function()
      require("codex").setup()
    end,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      {
        "<leader>ag",
        function()
          require("codex").toggle()
        end,
        desc = "Toggle Codex",
      },
    },
  },
}
