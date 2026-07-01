require "nvchad.options"

-- Indentation: use a 4-space-wide tab everywhere.
local o = vim.o
o.tabstop = 4 -- a tab counts for 4 columns
o.shiftwidth = 4 -- >> / << and auto-indent use 4
o.softtabstop = 4 -- <Tab>/<BS> in insert mode feel like 4
o.expandtab = true -- insert spaces instead of a literal tab

-- Line numbers: show relative numbers with the absolute number on the current line.
o.number = true
o.relativenumber = true

-- Built-in ftplugins (go, make, python, ...) run after this file and can reset
-- tabstop/expandtab (e.g. Go switches to noexpandtab with an 8-wide tab), which
-- is what makes <CR> indent jump to 8 columns. Re-apply our width afterwards.
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("IndentWidth", { clear = true }),
  callback = function()
    -- Makefiles genuinely require real tabs; leave them alone.
    if vim.bo.filetype == "make" then
      return
    end
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
  end,
})

-- Python indent (runtime/autoload/python.vim) tweaks to match black/ruff:
--   * hanging/continuation lines inside parens default to shiftwidth() * 2,
--     so <CR> after an open paren over-indents. Use a single shiftwidth.
--   * closing brackets default to aligning with the last content line; black
--     aligns them with the opening statement instead.
-- The shiftwidth ones have g:pyindent_* shims and must be set before the script
-- loads (its extend() reads them). closed_paren_align_last_line has no shim and
-- would be clobbered by that same extend(), so we force the autoload to run once
-- (baking in the pyindent_* values) and then override the dict key afterwards.
vim.g.pyindent_open_paren = "shiftwidth()"
vim.g.pyindent_nested_paren = "shiftwidth()"
vim.g.pyindent_continue = "shiftwidth()"

vim.cmd "runtime autoload/python.vim"
if type(vim.g.python_indent) == "table" then
  local pi = vim.g.python_indent
  pi.closed_paren_align_last_line = false
  vim.g.python_indent = pi
end
