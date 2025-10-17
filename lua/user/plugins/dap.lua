return {
  -- Core DAP
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      -- UI for DAP
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        lazy = true,
        opts = {},
        config = function(_, opts)
          local dap = require("dap")
          local dapui = require("dapui")
          dapui.setup(opts)

          -- Auto-open/close UI
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

      -- Go-specific DAP configuration
      {
        "leoluz/nvim-dap-go",
        lazy = true,
        opts = {},
      },
      {
        "mfussenegger/nvim-dap-python",
        lazy = true,
        config = function()
          -- Use the python from your current environment
          -- If you use virtualenvs, this will automatically use the right one
          require("dap-python").setup("python")

          -- Optional: Add configurations for common Python debugging scenarios
          table.insert(require("dap").configurations.python, {
            type = "python",
            request = "launch",
            name = "Django",
            program = vim.fn.getcwd() .. "/manage.py",
            args = { "runserver", "--noreload" },
          })
        end,
      },
    },

    keys = {
      -- F-key alternatives (comment these out or remove them)
      -- { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
      -- { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      -- { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      -- { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },

      -- Core debugging flow (optimized for rapid use)
      {
        "<leader>dd",
        function()
          require("dap").continue()
        end,
        desc = "[D]ebug: Start/Continue",
      },
      {
        "<leader>ds",
        function()
          require("dap").terminate()
        end,
        desc = "[D]ebug: [S]top",
      },
      {
        "<leader>dr",
        function()
          require("dap").restart()
        end,
        desc = "[D]ebug: [R]estart",
      },

      -- Stepping (using common vim-style navigation intuitions)
      {
        "<leader>dn",
        function()
          require("dap").step_over()
        end,
        desc = "[D]ebug: Step [N]ext (over)",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "[D]ebug: Step [I]nto",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "[D]ebug: Step [O]ut",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "[D]ebug: Run to [C]ursor",
      },

      -- Breakpoints
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "[D]ebug: Toggle [B]reakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "[D]ebug: Conditional [B]reakpoint",
      },
      {
        "<leader>dE",
        function()
          require("dap").set_exception_breakpoints()
        end,
        desc = "[D]ebug: [E]xception Breakpoints",
      },

      -- UI & Information
      {
        "<leader>du",
        function()
          require("dapui").toggle()
        end,
        desc = "[D]ebug: Toggle [U]I",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "[D]ebug: [E]val Expression",
        mode = { "n", "v" },
      },
      {
        "<leader>dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "[D]ebug: [H]over Variables",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "[D]ebug: [P]ause",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "[D]ebug: Run [L]ast",
      },

      -- REPL & Advanced
      {
        "<leader>dR",
        function()
          require("dap").repl.toggle()
        end,
        desc = "[D]ebug: Toggle [R]EPL",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "[D]ebug: Up Stack",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "[D]ebug: Down Stack",
      },
    },
  },
}
