local M = {}

local state = {
  buf = nil,
  job = nil,
  initialized = false,
}

local defaults = {
  command = "codex",
  args = { "--no-alt-screen" },
  split = {
    position = "botright",
    size = 15,
  },
  startinsert = true,
}

local config = nil

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Codex" })
end

local function get_config()
  if not config then
    config = vim.tbl_deep_extend("force", defaults, vim.g.codex_nvim or {})
  end

  return config
end

local function buf_valid(buf)
  return buf and vim.api.nvim_buf_is_valid(buf)
end

local function find_win()
  if not buf_valid(state.buf) then
    return nil
  end

  for _, win in ipairs(vim.fn.win_findbuf(state.buf)) do
    if vim.api.nvim_win_is_valid(win) then
      return win
    end
  end

  return nil
end

local function job_running()
  if not state.job then
    return false
  end

  return vim.fn.jobwait({ state.job }, 0)[1] == -1
end

local function enter_terminal()
  if get_config().startinsert then
    vim.cmd.startinsert()
  end
end

local function build_cmd(extra_args, prompt)
  local cmd = { get_config().command }

  vim.list_extend(cmd, get_config().args)

  if extra_args then
    vim.list_extend(cmd, extra_args)
  end

  if prompt and prompt ~= "" then
    table.insert(cmd, prompt)
  end

  return cmd
end

local function open_split()
  local split = get_config().split
  vim.cmd(("%s %dsplit"):format(split.position, split.size))
  return vim.api.nvim_get_current_win()
end

local function show_existing_terminal()
  local win = find_win()

  if win then
    vim.api.nvim_set_current_win(win)
  else
    win = open_split()
    vim.api.nvim_win_set_buf(win, state.buf)
  end

  enter_terminal()
end

local function start_session(extra_args, prompt)
  local win = open_split()
  local cmd = build_cmd(extra_args, prompt)
  local buf = vim.api.nvim_get_current_buf()
  local job = vim.fn.termopen(cmd, {
    cwd = vim.fn.getcwd(),
    on_exit = function(_, code)
      state.job = nil

      if code ~= 0 then
        notify(("Codex session exited with code %d"):format(code), vim.log.levels.WARN)
      end
    end,
  })

  if job <= 0 then
    notify("Failed to start Codex CLI", vim.log.levels.ERROR)
    return
  end

  state.buf = buf
  state.job = job

  vim.bo[buf].buflisted = false
  vim.bo[buf].bufhidden = "hide"
  vim.wo[win].winfixheight = true

  enter_terminal()
end

local function ensure_session()
  if job_running() and buf_valid(state.buf) then
    show_existing_terminal()
    return true
  end

  start_session()
  return job_running()
end

local function current_buffer_path()
  local path = vim.api.nvim_buf_get_name(0)

  if path == "" then
    return nil
  end

  return vim.fn.fnamemodify(path, ":.")
end

local function send_text(text)
  if not text or text == "" then
    return
  end

  if not ensure_session() then
    return
  end

  vim.api.nvim_chan_send(state.job, text:gsub("\r?\n?$", "") .. "\n")
  enter_terminal()
end

local function selection_text()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local start_line = start_pos[2]
  local end_line = end_pos[2]

  if start_line == 0 or end_line == 0 then
    return nil
  end

  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  return {
    text = table.concat(lines, "\n"),
    start_line = start_line,
    end_line = end_line,
  }
end

function M.toggle(prompt)
  local win = find_win()

  if win then
    vim.api.nvim_win_close(win, true)
    return
  end

  if job_running() and buf_valid(state.buf) then
    show_existing_terminal()
    return
  end

  start_session(nil, prompt)
end

function M.focus()
  if job_running() and buf_valid(state.buf) then
    show_existing_terminal()
    return
  end

  start_session()
end

function M.resume(prompt)
  if job_running() then
    notify("A Codex session is already running; focusing it instead.", vim.log.levels.INFO)
    M.focus()
    return
  end

  start_session({ "resume", "--last" }, prompt)
end

function M.fork(prompt)
  if job_running() then
    notify("A Codex session is already running; focusing it instead.", vim.log.levels.INFO)
    M.focus()
    return
  end

  start_session({ "fork", "--last" }, prompt)
end

function M.send(text)
  send_text(text)
end

function M.prompt()
  vim.ui.input({ prompt = "Codex > " }, function(input)
    if input and input ~= "" then
      send_text(input)
    end
  end)
end

function M.add(path)
  local target = path ~= "" and path or current_buffer_path()

  if not target then
    notify("No file to add from the current buffer.", vim.log.levels.WARN)
    return
  end

  local message = ("Please inspect `%s` in the current workspace."):format(target)

  if path == "" and vim.bo.modified then
    message = message .. "\nNote: the current buffer has unsaved changes in Neovim."
  end

  send_text(message)
end

function M.send_current_selection()
  local selection = selection_text()

  if not selection then
    notify("No visual selection found.", vim.log.levels.WARN)
    return
  end

  local path = current_buffer_path() or "[No Name]"
  local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "text"
  local message = table.concat({
    ("From `%s` lines %d-%d:"):format(path, selection.start_line, selection.end_line),
    ("```%s"):format(filetype),
    selection.text,
    "```",
  }, "\n")

  send_text(message)
end

local function create_commands()
  vim.api.nvim_create_user_command("Codex", function(opts)
    M.toggle(opts.args)
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("CodexFocus", function()
    M.focus()
  end, {})

  vim.api.nvim_create_user_command("CodexResume", function(opts)
    M.resume(opts.args)
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("CodexFork", function(opts)
    M.fork(opts.args)
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("CodexPrompt", function()
    M.prompt()
  end, {})

  vim.api.nvim_create_user_command("CodexAdd", function(opts)
    M.add(opts.args)
  end, {
    nargs = "?",
    complete = "file",
  })

  vim.api.nvim_create_user_command("CodexSend", function(opts)
    if opts.range > 0 then
      local lines = vim.api.nvim_buf_get_lines(0, opts.line1 - 1, opts.line2, false)
      local path = current_buffer_path() or "[No Name]"
      local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "text"
      local message = table.concat({
        ("From `%s` lines %d-%d:"):format(path, opts.line1, opts.line2),
        ("```%s"):format(filetype),
        table.concat(lines, "\n"),
        "```",
      }, "\n")

      send_text(message)
      return
    end

    if opts.args ~= "" then
      send_text(opts.args)
      return
    end

    M.prompt()
  end, {
    nargs = "*",
    range = true,
  })
end

function M.setup(opts)
  if state.initialized then
    return
  end

  if opts then
    config = vim.tbl_deep_extend("force", get_config(), opts)
  else
    get_config()
  end

  create_commands()

  state.initialized = true
end

return M
