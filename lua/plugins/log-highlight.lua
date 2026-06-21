-- lua/plugins/log-highlight.lua
-- Generic syntax highlighting for log files (.log, syslog, /var/log/*).
return {
  {
    "fei6409/log-highlight.nvim",
    -- load only when a log file is opened
    ft = "log",
    -- the plugin registers its own filetype detection on setup
    opts = {},
  },
}
