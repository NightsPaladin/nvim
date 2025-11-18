-- AI Integration for Neovim
-- Primary: CodeCompanion (uses GitHub Copilot, no API keys required)
-- Alternative: CopilotChat.nvim (commented out)
-- Place in your lua/plugins/ directory

return {
  -- GitHub Copilot with blink.cmp integration

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = true,
        hide_during_completion = true, -- Hide ghost text during completion
        keymap = {
          accept = "<C-g>", -- Accept suggestion
          accept_word = false,
          accept_line = false,
          next = "<C-]>", -- Next suggestion
          prev = "<C-[>", -- Previous suggestion
          dismiss = "<Esc><Esc>", -- Dismiss suggestion
          -- Option keybindings available if configured in terminal
        },
      },
      panel = { enabled = false }, -- Use chat plugins for panel
      filetypes = {
        ["*"] = true, -- Enable everywhere except special buffers
        help = false,
        gitrebase = false,
        [""] = false,
        ["."] = false,
        TelescopePrompt = false,
        NvimTree = false,
        ["neo-tree"] = false,
        Trouble = false,
        lazy = false,
        mason = false,
        ["copilot-chat"] = false,
        ["codecompanion"] = false,
      },
    },
    keys = {
      {
        "<leader>ta",
        "<cmd>Copilot toggle<CR>",
        -- function()
        --   require("copilot.suggestion").toggle_auto_trigger()
        -- end,
        desc = "Toggle Copilot AI",
      },
    },
  },

  -- CodeCompanion: Multi-provider AI chat (primary interface)
  -- Uses GitHub Copilot subscription by default
  -- Supports GPT-4, Claude 3.5, o1 models; direct API access optional
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    opts = {
      -- Default adapter: "copilot" (uses your GitHub Copilot subscription)
      -- No API keys required
      strategies = {
        chat = {
          adapter = "copilot",
          -- Use snacks picker for slash commands to avoid conflicts with Telescope
          slash_commands = {
            ["file"] = {
              opts = {
                provider = "snacks",
                auto_insert = true, -- Auto insert file into existing window
              },
            },
            ["buffer"] = {
              opts = {
                provider = "snacks",
                auto_insert = true,
              },
            },
            ["help"] = {
              opts = {
                provider = "snacks",
              },
            },
            ["symbols"] = {
              opts = {
                provider = "snacks",
              },
            },
          },
        },
        inline = { adapter = "copilot" },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_tools = true, -- Enable MCP tools
            show_server_tools_in_chat = true,
            add_mcp_prefix_to_tool_names = false,
            show_result_in_chat = true,
            make_vars = true, -- Enable MCP resources
            make_slash_commands = true, -- Enable MCP prompts
          },
        },
      },
      display = {
        action_palette = {
          width = 95,
          height = 10,
        },
        diff = {
          provider = "mini_diff",
        },
        chat = {
          window = {
            layout = "vertical",
            width = 0.4,
            height = 1,
          },
        },
      },
    },
    keys = {
      -- Main chat interface
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle Chat", mode = { "n", "v" } },
      { "<leader>ax", "<cmd>CodeCompanionChat Add<CR>", desc = "Add to Chat", mode = { "n", "v" } },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            vim.cmd("CodeCompanionChat " .. input)
          end
        end,
        desc = "Quick Chat",
        mode = { "n", "v" },
      },
      { "<leader>aC", "<cmd>CodeCompanionActions<CR>", desc = "Actions Menu", mode = { "n", "v" } },
      { "<leader>aI", "<cmd>CodeCompanion<CR>", desc = "Inline Assistant", mode = "v" },
      { "<leader>ae", "<cmd>CodeCompanionActions explain<CR>", desc = "Explain Code", mode = "v" },
      { "<leader>ar", "<cmd>CodeCompanionActions review<CR>", desc = "Review Code", mode = "v" },
      { "<leader>af", "<cmd>CodeCompanionActions fix<CR>", desc = "Fix Code", mode = "v" },
      { "<leader>ao", "<cmd>CodeCompanionActions optimize<CR>", desc = "Optimize Code", mode = "v" },
      { "<leader>ad", "<cmd>CodeCompanionActions docs<CR>", desc = "Add Documentation", mode = "v" },
      { "<leader>at", "<cmd>CodeCompanionActions tests<CR>", desc = "Generate Tests", mode = "v" },
      { "<leader>ac", "<cmd>CodeCompanionActions commit<CR>", desc = "Generate Commit Message" },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)

      -- Auto-insert mode for chat buffer and register keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "codecompanion",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
          -- Fix window width to prevent resize events from changing it
          vim.wo.winfixwidth = true
          -- Register buffer-local keybindings with which-key
          local ok, wk = pcall(require, "which-key")
          if ok then
            wk.add({
              { "ga", desc = "Change adapter", buffer = 0 },
              { "gs", desc = "Toggle system prompt", buffer = 0 },
              { "gS", desc = "Show usage stats", buffer = 0 },
              { "gy", desc = "Yank codeblock", buffer = 0 },
              { "gc", desc = "Insert codeblock", buffer = 0 },
              { "gf", desc = "Fold codeblocks", buffer = 0 },
              { "gp", desc = "Pin context", buffer = 0 },
              { "gw", desc = "Watch buffer", buffer = 0 },
              { "gd", desc = "Debug view", buffer = 0 },
              { "gD", desc = "Super Diff", buffer = 0 },
              { "gr", desc = "Regenerate", buffer = 0 },
              { "gR", desc = "Go to file", buffer = 0 },
              { "gx", desc = "Clear chat", buffer = 0 },
              { "gM", desc = "Clear memory", buffer = 0 },
              { "gt", group = "Tools", buffer = 0 },
              { "gta", desc = "Toggle auto tools", buffer = 0 },
            })
          end
        end,
      })

      -- Prevent CodeCompanion from opening files in the chat window itself
      -- Redirect file buffers to existing non-chat windows
      vim.api.nvim_create_autocmd("BufWinEnter", {
        pattern = "*",
        callback = function(args)
          local buf = args.buf
          local current_win = vim.api.nvim_get_current_win()

          -- Get buffer info
          local ft = vim.bo[buf].filetype
          local bt = vim.bo[buf].buftype

          -- Only handle regular file buffers (skip special buffers like pickers, terminals, etc.)
          if bt ~= "" then
            return
          end
          if ft == "codecompanion" then
            return
          end

          -- Check if current window is a codecompanion window
          local current_win_buf = vim.api.nvim_win_get_buf(current_win)
          if vim.bo[current_win_buf].filetype ~= "codecompanion" then
            return
          end

          -- We're trying to open a file in the codecompanion window - redirect it
          -- Find the first non-codecompanion window
          local target_win = nil
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            if win ~= current_win and vim.api.nvim_win_is_valid(win) then
              local win_buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[win_buf].filetype ~= "codecompanion" then
                target_win = win
                break
              end
            end
          end

          -- If we found a target window, open the buffer there instead
          if target_win then
            vim.schedule(function()
              if vim.api.nvim_win_is_valid(target_win) and vim.api.nvim_buf_is_valid(buf) then
                vim.api.nvim_win_set_buf(target_win, buf)
                vim.api.nvim_set_current_win(target_win)
              end
            end)
          end
        end,
      })
    end,
  },

  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "olimorris/codecompanion.nvim",
    },
    build = "npm install -g mcp-hub@latest",
    cmd = { "MCPHub" },
    opts = {
      servers = {
        filesystem = {
          enabled = true,
        },
        fetch = {
          enabled = true,
        },
      },
    },
    keys = {
      {
        "<leader>am",
        "<cmd>MCPHub<CR>",
        desc = "MCP Hub (manage servers)",
      },
    },
  },

  -- Alternative: CopilotChat (GitHub Copilot Chat)
  -- Uncomment to use instead of CodeCompanion
  -- Uses Claude 3.5 Sonnet via Copilot subscription
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   dependencies = {
  --     { "zbirenbaum/copilot.lua" },
  --     { "nvim-lua/plenary.nvim" },
  --   },
  --   build = "make tiktoken",
  --   cmd = "CopilotChat",
  --   opts = function()
  --     local user = vim.env.USER or "User"
  --     user = user:sub(1, 1):upper() .. user:sub(2)
  --
  --     return {
  --       model = "gpt-4o", -- 'claude-3.5-sonnet', -- or 'gpt-4o', 'gemini-2.0-flash-exp'
  --       auto_insert_mode = true,
  --       show_help = true,
  --       question_header = "  " .. user .. " ",
  --       answer_header = "  Copilot ",
  --       window = {
  --         layout = "vertical",
  --         width = 0.4,
  --         height = 1,
  --         border = "none",
  --       },
  --       prompts = {
  --         Explain = {
  --           prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.",
  --         },
  --         Review = {
  --           prompt = "/COPILOT_REVIEW Review the selected code.",
  --         },
  --         Fix = {
  --           prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.",
  --         },
  --         Optimize = {
  --           prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readability.",
  --         },
  --         Docs = {
  --           prompt = "/COPILOT_GENERATE Please add documentation comments to the selected code.",
  --         },
  --         Tests = {
  --           prompt = "/COPILOT_GENERATE Please generate tests for my code.",
  --         },
  --         FixDiagnostic = {
  --           prompt = "Please assist with the following diagnostic issue in file:",
  --           selection = require("CopilotChat.select").diagnostics,
  --         },
  --         Commit = {
  --           prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
  --           selection = require("CopilotChat.select").gitdiff,
  --         },
  --         CommitStaged = {
  --           prompt = "Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.",
  --           selection = function(source)
  --             return require("CopilotChat.select").gitdiff(source, true)
  --           end,
  --         },
  --       },
  --     }
  --   end,
  --   keys = {
  --     -- NOTE: <C-l> binding removed to avoid conflict with window navigation (Ctrl+w l)
  --     -- Use <leader>ax to clear/reset the chat instead
  --
  --     -- Quick chat
  --     {
  --       "<leader>aa",
  --       function()
  --         require("CopilotChat").toggle()
  --       end,
  --       desc = "Toggle (CopilotChat)",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "<leader>ax",
  --       function()
  --         require("CopilotChat").reset()
  --       end,
  --       desc = "Clear (CopilotChat)",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "<leader>aq",
  --       function()
  --         local input = vim.fn.input("Quick Chat: ")
  --         if input ~= "" then
  --           require("CopilotChat").ask(input)
  --         end
  --       end,
  --       desc = "Quick Chat (CopilotChat)",
  --       mode = { "n", "v" },
  --     },
  --     {
  --       "<leader>am",
  --       function ()
  --         require("CopilotChat").select_model()
  --       end,
  --       desc = "Select Model (CopilotChat)",
  --       mode = { "n", "v" },
  --     },
  --
  --     -- Code actions
  --     { "<leader>ae", ":CopilotChatExplain<CR>", desc = "Explain Code", mode = "v" },
  --     { "<leader>ar", ":CopilotChatReview<CR>", desc = "Review Code", mode = "v" },
  --     { "<leader>af", ":CopilotChatFix<CR>", desc = "Fix Code", mode = "v" },
  --     { "<leader>ao", ":CopilotChatOptimize<CR>", desc = "Optimize Code", mode = "v" },
  --     { "<leader>ad", ":CopilotChatDocs<CR>", desc = "Add Documentation", mode = "v" },
  --     { "<leader>at", ":CopilotChatTests<CR>", desc = "Generate Tests", mode = "v" },
  --
  --     -- Fix diagnostic
  --     { "<leader>aD", ":CopilotChatFixDiagnostic<CR>", desc = "Fix Diagnostic" },
  --
  --     -- Git integration
  --     { "<leader>ac", ":CopilotChatCommit<CR>", desc = "Generate Commit Message" },
  --     { "<leader>as", ":CopilotChatCommitStaged<CR>", desc = "Generate Commit Message (Staged)" },
  --   },
  --   config = function(_, opts)
  --     local chat = require("CopilotChat")
  --     chat.setup(opts)
  --
  --     -- Auto-insert mode for chat buffer
  --     vim.api.nvim_create_autocmd("BufEnter", {
  --       pattern = "copilot-chat",
  --       callback = function()
  --         vim.opt_local.relativenumber = false
  --         vim.opt_local.number = false
  --       end,
  --     })
  --   end,
  -- },

  -- Optional: Copilot in Completion Menu
  -- By default, Copilot uses ghost text. Uncomment ONE below for menu integration:

  -- Option A: giuxtaposition/blink-cmp-copilot (simpler)
  -- {
  --   "giuxtaposition/blink-cmp-copilot",
  --   dependencies = { "zbirenbaum/copilot.lua" },
  --   opts = {},
  -- },

  -- Option B: fang2hou/blink-copilot (more configurable)
  -- {
  --   "fang2hou/blink-copilot",
  --   dependencies = { "zbirenbaum/copilot.lua" },
  --   opts = {},
  -- },

  -- NOTE: If you uncomment either blink-copilot plugin above,
  -- add the copilot source to your cmp.lua file.
  -- See documentation at the end of this file for details.

  -- Bonus: Codeium (Free Copilot Alternative)
  -- {
  --   "Exafunction/codeium.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --   },
  --   cmd = "Codeium",
  --   event = "InsertEnter",
  --   opts = {
  --     enable_chat = true,
  --   },
  -- },
}

-- =============================
-- Setup Instructions (Summary)
-- =============================
--
-- 1. Save this file to: ~/.config/nvim/lua/plugins/ai.lua
-- 2. Restart Neovim (lazy.nvim will auto-install plugins)
-- 3. Authenticate Copilot: :Copilot auth
-- 4. Use AI features:
--    - Ghost text suggestions (Copilot)
--    - <Space>aa: Toggle CodeCompanion chat
--    - <Space>aC: Actions menu
--    - ga (in chat): Switch models
--
-- CodeCompanion uses your GitHub Copilot subscription by default (no API keys required).
--
-- Keybindings use Ctrl by default for macOS compatibility.
--
-- =============================
-- Direct API Access (Optional)
-- =============================
-- To use Claude 4.5, OpenAI, or Gemini via API:
-- 1. Get API keys from providers
-- 2. Set environment variables in ~/.bashrc or ~/.zshrc
-- 3. Update adapters in CodeCompanion opts
--
-- =============================
-- cmp.lua Configuration
-- =============================
-- Add Copilot source to completion menu only if using menu integration.
--
-- =============================
-- Keybindings Reference
-- =============================
-- <Space>aa - Toggle chat
-- <Space>ax - Add to chat
-- <Space>aq - Quick question
-- <Space>aC - Actions menu
-- <Space>ae/ar/af/ao/ad/at - Code actions (visual mode)
-- <Space>aI - Inline assistant
-- <Space>ac - Generate commit message
-- Ctrl+g - Accept suggestion
-- Ctrl+] / Ctrl+[ - Next/previous suggestion
-- <Space>ta - Toggle AI suggestions
--
-- =============================
-- Troubleshooting
-- =============================
-- Copilot: :Copilot status / :Copilot auth
-- CodeCompanion: Ensure Copilot is authenticated
-- Direct API: Check environment variables
-- Ghost text: hide_during_completion = true
-- Path completion: Disable in chat buffers via cmp.lua
--
-- =============================
-- macOS Terminal Configuration
-- =============================
-- Ctrl keybindings work by default. For Option key, configure your terminal.
--
-- =============================
-- Optional Integrations
-- =============================
-- See lualine config for Copilot status indicator.
--
-- =============================
-- Approach
-- =============================
-- - Ghost text by default
-- - Lazy-loading for performance
-- - Non-conflicting keybindings
-- - Multi-provider support
-- - Clean organization
--
