local function project_root()
  local root = require("config.root")
  return root.buf_project_root(0) or root.start_dir
end

local function input_executable()
  return vim.fn.input("Path to executable: ", project_root() .. "/", "file")
end

local function input_args()
  local args = vim.fn.input("Arguments: ")
  return vim.split(args, "%s+", { trimempty = true })
end

local function python_path()
  local candidates = {
    vim.fs.joinpath(project_root(), ".venv", "bin", "python"),
    vim.fn.exepath("python3"),
    vim.fn.exepath("python"),
  }

  for _, candidate in ipairs(candidates) do
    if candidate and candidate ~= "" and vim.uv.fs_stat(candidate) then
      return candidate
    end
  end

  return "python3"
end

local function setup_codelldb(dap)
  local command = vim.fn.exepath("codelldb")
  if command == "" then
    command = "codelldb"
  end

  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      command = command,
      args = { "--port", "${port}" },
    },
  }

  dap.configurations.c = {
    {
      name = "Launch executable",
      type = "codelldb",
      request = "launch",
      program = input_executable,
      args = input_args,
      cwd = project_root,
      stopOnEntry = false,
      terminal = "integrated",
    },
  }
  dap.configurations.cpp = dap.configurations.c
  dap.configurations.rust = dap.configurations.c
end

local function setup_delve(dap)
  dap.adapters.delve = {
    type = "server",
    port = "${port}",
    executable = {
      command = vim.fn.exepath("dlv") ~= "" and vim.fn.exepath("dlv") or "dlv",
      args = { "dap", "-l", "127.0.0.1:${port}" },
    },
  }

  dap.configurations.go = {
    {
      name = "Debug file",
      type = "delve",
      request = "launch",
      program = "${file}",
    },
    {
      name = "Debug package",
      type = "delve",
      request = "launch",
      program = "${fileDirname}",
    },
  }
end

local function setup_python(dap)
  local adapter = vim.fn.exepath("debugpy-adapter")
  if adapter ~= "" then
    dap.adapters.python = {
      type = "executable",
      command = adapter,
    }
  else
    dap.adapters.python = {
      type = "executable",
      command = python_path(),
      args = { "-m", "debugpy.adapter" },
    }
  end

  dap.configurations.python = {
    {
      name = "Debug file",
      type = "python",
      request = "launch",
      program = "${file}",
      cwd = project_root,
      pythonPath = python_path,
      justMyCode = false,
    },
  }
end

local function setup_dap_ui(dap, dapui)
  dapui.setup({
    controls = {
      enabled = true,
      element = "repl",
    },
    floating = {
      border = "rounded",
      mappings = {
        close = { "q", "<Esc>" },
      },
    },
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.35 },
          { id = "watches", size = 0.25 },
          { id = "stacks", size = 0.25 },
          { id = "breakpoints", size = 0.15 },
        },
        size = require("config.layout").right_width(),
        position = "right",
      },
      {
        elements = {
          { id = "repl", size = 0.5 },
          { id = "console", size = 0.5 },
        },
        size = require("config.layout").bottom_height(),
        position = "bottom",
      },
    },
  })

  dap.listeners.after.event_initialized["dapui"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui"] = function()
    dapui.close()
  end
end

return {
  {
    "mfussenegger/nvim-dap",
    cmd = {
      "DapContinue",
      "DapDisconnect",
      "DapRestartFrame",
      "DapSetLogLevel",
      "DapShowLog",
      "DapStepInto",
      "DapStepOut",
      "DapStepOver",
      "DapTerminate",
      "DapToggleBreakpoint",
      "DapToggleRepl",
    },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "nvim-neotest/nvim-nio",
        },
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
          "williamboman/mason.nvim",
        },
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "C", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticOk", linehl = "Visual" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "R", texthl = "DiagnosticError" })

      require("mason-nvim-dap").setup({
        ensure_installed = {
          "codelldb",
          "delve",
          "python",
        },
        automatic_installation = true,
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      })

      setup_codelldb(dap)
      setup_delve(dap)
      setup_python(dap)
      setup_dap_ui(dap, dapui)
    end,
    keys = {
      {
        "<F6>",
        function()
          require("dap").continue()
        end,
        desc = "Debug continue",
      },
      {
        "<F7>",
        function()
          require("dap").terminate()
        end,
        desc = "Debug terminate",
      },
      {
        "<F8>",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle breakpoint",
      },
      {
        "<F9>",
        function()
          require("dap").step_into()
        end,
        desc = "Step into",
      },
      {
        "<F10>",
        function()
          require("dap").step_out()
        end,
        desc = "Step out",
      },
      {
        "<F11>",
        function()
          require("dap").step_over()
        end,
        desc = "Step over",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
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
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Conditional breakpoint",
      },
      {
        "<leader>dl",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end,
        desc = "Log point",
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
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle UI",
      },
      {
        "<leader>dL",
        function()
          require("dap").run_last()
        end,
        desc = "Run last",
      },
    },
  },
}
