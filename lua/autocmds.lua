require "nvchad.autocmds"

-- fcitx5 auto IME toggle: force English in Normal/terminal-normal mode, restore
-- the previous (Korean) state when entering Insert mode or terminal mode.
local fcitx_group = vim.api.nvim_create_augroup("Fcitx5AutoToggle", { clear = true })

-- Remember whether the IME was active (Korean) when leaving Insert mode.
local last_im_active = false

-- On startup nvim begins in Normal mode, so force English if the IME is active.
vim.api.nvim_create_autocmd("VimEnter", {
  group = fcitx_group,
  callback = function()
    if vim.fn.system("fcitx5-remote"):gsub("%s+", "") == "2" then
      last_im_active = true
      vim.fn.system "fcitx5-remote -c"
    end
  end,
})

-- Leaving Insert mode or terminal-insert mode -> force English.
vim.api.nvim_create_autocmd({ "InsertLeave", "TermLeave" }, {
  group = fcitx_group,
  callback = function()
    -- Save current state, then switch to English.
    last_im_active = vim.fn.system("fcitx5-remote"):gsub("%s+", "") == "2"
    if last_im_active then
      vim.fn.system "fcitx5-remote -c"
    end
  end,
})

-- Entering Insert mode or terminal-insert mode -> restore Korean.
vim.api.nvim_create_autocmd({ "InsertEnter", "TermEnter" }, {
  group = fcitx_group,
  callback = function()
    -- Restore Korean input if it was active before leaving Insert mode.
    if last_im_active then
      vim.fn.system "fcitx5-remote -o"
    end
  end,
})
