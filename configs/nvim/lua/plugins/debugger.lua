return {
  {
    'mfussenegger/nvim-dap',
    name = "dap",
    config = function()
      local dap = require("dap")
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
      }
      dap.configurations.cpp = {
        {
          name = "Launch",
          type = "gdb",
          request = "launch",
          program = function()
            return 'out/Debug/chrome' 
          end,
          args = {"--no-sandbox", "--enable-logging"}, -- provide arguments if needed
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
        },
      }
    end
  },
  {
    "igorlfs/nvim-dap-view",
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {},
    config = function()
      local wk = require("which-key")
      wk.add({
        {"<Leader>d", group = "Debugger", desc = "Debug your project"},
        {"<Leader>dv", ":DapViewToggle<CR>", desc = "Toggle Debugger view"},
        {"<Leader>db", ":DapToggleBreakpoint<CR>", desc = "Toggle Breakpoint"},
        {"<Leader>ds", ":DapNew<CR>", desc = "Start Debugging"},
      })
    end
  },
}
