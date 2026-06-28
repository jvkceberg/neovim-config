require "nvchad.autocmds"

-- fcitx5 auto IME toggle: force English in Normal/terminal-normal mode, restore
-- the previous (Korean) state when entering Insert mode or terminal mode.
local fcitx_group = vim.api.nvim_create_augroup("Fcitx5AutoToggle", { clear = true })

-- Remember whether the IME was active (Korean) when leaving Insert mode.
local last_im_active = false

-- On startup nvim begins in Normal mode, so force English if the IME is active.
-- Use the async vim.system() instead of the blocking vim.fn.system(): a blocking
-- call here stalls the main loop while nvim is still settling its initial
-- terminal input, which makes the very first keypress get swallowed.
vim.api.nvim_create_autocmd("VimEnter", {
  group = fcitx_group,
  callback = function()
    vim.system({ "fcitx5-remote" }, { text = true }, function(obj)
      if vim.trim(obj.stdout) == "2" then
        last_im_active = true
        vim.system { "fcitx5-remote", "-c" }
      end
    end)
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

-- Keep Codex/Claude terminal buffers out of the top tabufline (bufferline) by
-- unlisting them. Their native terminal buffers would otherwise show up as
-- normal tabs in NvChad's tabufline.
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("AgentTerminalUnlist", { clear = true }),
  pattern = { "term://*:*claude*", "term://*:*codex*" },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
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
