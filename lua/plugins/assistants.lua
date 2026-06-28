return {
  -- Claude Code integration
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim", optional = true },
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSend",
      "ClaudeCodeAdd",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeSelectModel",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
    },
    opts = {
      terminal = {
        provider = "native",
        show_native_term_exit_tip = false,
      },
      diff_opts = {
        keep_terminal_focus = true,
      },
    },
    keys = {
      { "<leader>a", nil, desc = "Assistants" },
      { "<leader>ac", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    },
  },
  -- Local Codex terminal integration
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
