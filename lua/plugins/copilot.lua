-- lua/plugins/copilot.lua
-- GitHub Copilot as inline suggestions (ghost text) only.
-- Not wired into nvim-cmp; this is suggestion-only on purpose.
-- Keymaps avoid Alt (used by zellij) and Tab/Enter (used by nvim-cmp).
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    panel = { enabled = false },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = true, -- hide ghost text while cmp menu is open
      keymap = {
        accept = "<C-f>",
        accept_word = "<C-Right>",
        accept_line = false,
        next = "<C-;>",
        prev = "<C-,>",
        dismiss = "<C-]>",
      },
    },
    filetypes = {
      -- enable everywhere except a few noisy/secret-prone buffers
      ["."] = true,
      gitcommit = false,
      gitrebase = false,
      help = false,
      markdown = true,
    },
  },
}
