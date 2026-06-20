-- lua/plugins/dap.lua
-- Debugging via DAP.
--
-- The debugpy *adapter* runs from Mason's debugpy (install once via
-- `:MasonInstall debugpy`), so projects don't need their own debugpy. The
-- *debuggee* is launched in the project's uv `.venv` by nvim-dap-python's
-- default pythonPath resolver (VIRTUAL_ENV / .venv / venv in cwd).
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
      },
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
    },
    ---@type LazyKeysSpec[]
    keys = {
      { "<leader>d", nil, desc = "Debug" },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
        end,
        desc = "Conditional breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue / start",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step out",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle DAP UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        mode = { "n", "v" },
        desc = "Eval expression",
      },
      {
        "<leader>dn",
        function()
          require("dap-python").test_method()
        end,
        desc = "Debug nearest test (python)",
      },
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      dapui.setup()
      require("nvim-dap-virtual-text").setup {}

      -- Adapter runs from Mason's debugpy; the debuggee interpreter is resolved
      -- per-session to the project .venv by dap-python's default pythonPath.
      local debugpy_python = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(debugpy_python)

      -- auto open/close the UI around a debug session
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
