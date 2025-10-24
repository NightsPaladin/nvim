-- lua/plugins/ai.lua
-- AI Integration for Neovim with blink.cmp
-- Uses CodeCompanion with GitHub Copilot as primary AI (no API keys needed!)
-- CopilotChat.nvim available as alternative (commented out)
-- Place this file in your lua/plugins/ directory

return {
  -- ============================================================================
  -- GitHub Copilot with Smart blink.cmp Integration
  -- ============================================================================

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = true,
        -- Hide ghost text when blink.cmp menu is open
        hide_during_completion = true,
        keymap = {
          -- macOS-friendly keybindings (Ctrl-based, works everywhere)
          accept = "<C-g>", -- Ctrl+g to accept (inspired by GitHub Copilot)
          accept_word = false, -- Disabled by default
          accept_line = false, -- Disabled by default
          next = "<C-]>", -- Next suggestion (Ctrl+])
          prev = "<C-[>", -- Previous suggestion (Ctrl+[)
          dismiss = "<Esc><Esc>", -- Dismiss suggestion

          -- Alternative: If you configure your terminal for Option key
          -- (see instructions below), you can uncomment these:
          -- accept = "<M-CR>",     -- Option+Enter to accept
          -- accept_word = "<M-w>", -- Option+w to accept word
          -- accept_line = "<M-l>", -- Option+l to accept line
          -- next = "<M-]>",
          -- prev = "<M-[>",
        },
      },
      panel = { enabled = false }, -- Use CodeCompanion/CopilotChat instead
      filetypes = {
        ["*"] = true, -- Enable for all filetypes

        -- Only disable special buffers
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
        desc = "[T]oggle [A]I (Copilot)",
      },
    },
  },

  -- ============================================================================
  -- CodeCompanion (Multi-Provider AI) - PRIMARY CHAT INTERFACE
  -- ============================================================================
  -- Default: Uses your GitHub Copilot subscription (no API keys needed!)
  -- Includes access to GPT-4, Claude 3.5 Sonnet, and o1 models
  -- Optional: Can configure direct API access (see documentation below)
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
    opts = {
      -- Note: Default adapter is "copilot" - uses your existing GitHub Copilot subscription!
      -- No API keys needed - it uses the token from copilot.lua authentication
      strategies = {
        chat = {
          adapter = "copilot",
          -- Use snacks picker for slash commands to avoid conflicts with Telescope
          slash_commands = {
            ["file"] = {
              opts = {
                provider = "snacks",
              },
            },
            ["buffer"] = {
              opts = {
                provider = "snacks",
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
            -- MCP Tools - enables @server and @server__tool syntax
            make_tools = true,
            show_server_tools_in_chat = true,
            add_mcp_prefix_to_tool_names = false,
            show_result_in_chat = true,

            -- MCP Resources - enables #mcp:resource_name variables
            make_vars = true,

            -- MCP Prompts - enables /mcp:prompt_name slash commands
            make_slash_commands = true,
          },
        },
      },
      display = {
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
      {
        "<leader>aa",
        "<cmd>CodeCompanionChat Toggle<CR>",
        desc = "Toggle Chat (CodeCompanion)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        "<cmd>CodeCompanionChat Add<CR>",
        desc = "Add to Chat (CodeCompanion)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            vim.cmd("CodeCompanionChat " .. input)
          end
        end,
        desc = "Quick Chat (CodeCompanion)",
        mode = { "n", "v" },
      },
      {
        "<leader>am",
        "<cmd>CodeCompanionChat Adapter<CR>",
        desc = "Select Model (CodeCompanion)",
        mode = { "n", "v" },
      },

      -- Actions menu (gives access to predefined prompts)
      {
        "<leader>aC",
        "<cmd>CodeCompanionActions<CR>",
        desc = "Actions Menu (CodeCompanion)",
        mode = { "n", "v" },
      },

      -- Inline assistant
      {
        "<leader>aI",
        "<cmd>CodeCompanion<CR>",
        desc = "Inline Assistant (CodeCompanion)",
        mode = "v",
      },

      -- Code actions (visual mode)
      {
        "<leader>ae",
        "<cmd>CodeCompanionActions explain<CR>",
        desc = "Explain Code",
        mode = "v",
      },
      {
        "<leader>ar",
        "<cmd>CodeCompanionActions review<CR>",
        desc = "Review Code",
        mode = "v",
      },
      {
        "<leader>af",
        "<cmd>CodeCompanionActions fix<CR>",
        desc = "Fix Code",
        mode = "v",
      },
      {
        "<leader>ao",
        "<cmd>CodeCompanionActions optimize<CR>",
        desc = "Optimize Code",
        mode = "v",
      },
      {
        "<leader>ad",
        "<cmd>CodeCompanionActions docs<CR>",
        desc = "Add Documentation",
        mode = "v",
      },
      {
        "<leader>at",
        "<cmd>CodeCompanionActions tests<CR>",
        desc = "Generate Tests",
        mode = "v",
      },

      -- Git integration
      {
        "<leader>ac",
        "<cmd>CodeCompanionActions commit<CR>",
        desc = "Generate Commit Message",
      },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)

      -- Auto-insert mode for chat buffer + register keybindings
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "codecompanion",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false

          -- Explicitly register CodeCompanion keybindings with which-key
          local ok, wk = pcall(require, "which-key")
          if ok then
            wk.add({
              -- Adapter & Config
              { "ga", desc = "Change adapter", buffer = 0 },
              { "gs", desc = "Toggle system prompt", buffer = 0 },
              { "gS", desc = "Show usage stats", buffer = 0 },

              -- Code Blocks
              { "gy", desc = "Yank codeblock", buffer = 0 },
              { "gc", desc = "Insert codeblock", buffer = 0 },
              { "gf", desc = "Fold codeblocks", buffer = 0 },

              -- Context Management
              { "gp", desc = "Pin context", buffer = 0 },
              { "gw", desc = "Watch buffer", buffer = 0 },

              -- Debug & Advanced
              { "gd", desc = "Debug view", buffer = 0 },
              { "gD", desc = "Super Diff", buffer = 0 },
              { "gr", desc = "Regenerate", buffer = 0 },
              { "gR", desc = "Go to file", buffer = 0 },
              { "gx", desc = "Clear chat", buffer = 0 },
              { "gM", desc = "Clear memory", buffer = 0 },

              -- Tools
              { "gt", group = "Tools", buffer = 0 },
              { "gta", desc = "Toggle auto tools", buffer = 0 },
            })
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
        -- Built-in servers (automatically available)
        filesystem = {
          enabled = true,
        },
        fetch = {
          enabled = true,
        },

        -- Optional: Add GitHub integration
        -- Requires: export GITHUB_TOKEN=your_token
        -- github = {
        --   enabled = true,
        --   env = {
        --     GITHUB_PERSONAL_ACCESS_TOKEN = vim.env.GITHUB_TOKEN,
        --   },
        -- },
      },
    },
    keys = {
      {
        "<leader>aM",
        "<cmd>MCPHub<CR>",
        desc = "MCP Hub (manage servers)",
      },
    },
  },

  -- ============================================================================
  -- ALTERNATIVE: CopilotChat (GitHub Copilot Chat)
  -- ============================================================================
  -- Uncomment to use GitHub Copilot's chat instead of CodeCompanion
  -- Note: Uses Claude 3.5 Sonnet via GitHub Copilot subscription
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

  -- ============================================================================
  -- OPTIONAL: Copilot in Completion Menu
  -- ============================================================================
  -- By default, Copilot uses ghost text (recommended).
  -- Uncomment ONE of these if you want Copilot in blink.cmp menu:

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

  -- ============================================================================
  -- BONUS: Codeium (Free Copilot Alternative)
  -- ============================================================================
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

-- ============================================================================
-- SETUP INSTRUCTIONS
-- ============================================================================
--
-- ## File Organization Summary
--
-- **This file (ai.lua):**
-- - ✅ copilot.lua (AI suggestions via ghost text)
-- - ✅ CodeCompanion (Primary AI chat - uses GitHub Copilot by default!)
-- - ✅ CopilotChat.nvim (Alternative, commented out)
-- - ✅ blink-copilot (optional, commented out)
--
-- **Your cmp.lua file:**
-- - ✅ blink.cmp main configuration
-- - ✅ Path provider fix (recommended for chat buffers)
-- - ✅ Copilot source (only if using menu mode)
--
-- This keeps each plugin's config in ONE place!
--
--
-- ## Quick Start
--
-- 1. Save this file to: `~/.config/nvim/lua/plugins/ai.lua`
--
-- 2. Restart Neovim - lazy.nvim will auto-install plugins
--
-- 3. Authenticate Copilot (if not already done):
--    - In Neovim, run: `:Copilot auth`
--    - Follow the browser prompts
--
-- 4. Start using AI:
--    - Type code and see ghost text suggestions (Copilot)
--    - Press Ctrl+g to accept suggestions
--    - Press <Space>aa to open CodeCompanion chat (uses GitHub Copilot!)
--    - Press <Space>aC for actions menu
--    - Press `ga` in chat to switch between GPT-4, Claude 3.5, and o1 models
--
-- **That's it!** CodeCompanion uses your GitHub Copilot subscription by default.
-- No separate API keys needed!
--
-- **Note:** Keybindings use Ctrl instead of Alt/Option by default for macOS compatibility.
-- See "macOS Terminal Configuration" section below for details.
--
--
-- ## Using Other AI Providers (Optional)
--
-- Want to use Claude 4.5, OpenAI, or Gemini directly via API?
-- See "Adding Direct API Access" section below for instructions.
--
--
-- ## Adding Direct API Access (Optional)
--
-- **By default, CodeCompanion uses GitHub Copilot - no API keys needed!**
--
-- If you want to use other providers directly (Claude 4.5, OpenAI, Gemini), you'll need:
-- 1. API keys for those providers (separate from consumer subscriptions like Claude Pro)
-- 2. To configure the adapters and environment variables
--
-- ### Step 1: Get API Keys
--
-- **Important:** Consumer subscriptions (Claude Pro, ChatGPT Plus) don't include API access.
-- You need separate API accounts:
-- - Anthropic API: https://console.anthropic.com/ (separate from Claude Pro)
-- - OpenAI API: https://platform.openai.com/api-keys (separate from ChatGPT Plus)
-- - Google Gemini: https://makersuite.google.com/app/apikey
--
-- ### Step 2: Set Environment Variables
--
-- Add to ~/.bashrc or ~/.zshrc:
--
-- ```bash
-- # Only needed if using direct API access (not for GitHub Copilot)
-- export ANTHROPIC_API_KEY="sk-ant-xxxxx"
-- export OPENAI_API_KEY="sk-xxxxx"
-- export GEMINI_API_KEY="xxxxx"
-- ```
--
-- After adding, run: `source ~/.bashrc` (or restart terminal)
--
-- ### Step 3: Update Config
--
-- Add this to the `opts` section of CodeCompanion (around line 82):
--
-- ```lua
-- opts = {
--   adapters = {
--     anthropic = function()
--       return require("codecompanion.adapters").extend("anthropic", {
--         env = { api_key = "ANTHROPIC_API_KEY" },
--         schema = { model = { default = "claude-sonnet-4-5-20250929" } },
--       })
--     end,
--     openai = function()
--       return require("codecompanion.adapters").extend("openai", {
--         env = { api_key = "OPENAI_API_KEY" },
--         schema = { model = { default = "gpt-4o" } },
--       })
--     end,
--     gemini = function()
--       return require("codecompanion.adapters").extend("gemini", {
--         env = { api_key = "GEMINI_API_KEY" },
--         schema = { model = { default = "gemini-2.0-flash-exp" } },
--       })
--     end,
--   },
--   strategies = {
--     chat = { adapter = "anthropic" },  -- Change default from "copilot"
--     inline = { adapter = "anthropic" },
--   },
--   -- ... rest of config
-- }
-- ```
--
--
-- ## cmp.lua Configuration
--
-- Add this to your existing `lua/plugins/cmp.lua` file:
--
-- ```lua
-- {
--   "saghen/blink.cmp",
--   opts = {
--     sources = {
--       -- Add your existing sources here
--       default = { 'lsp', 'path', 'snippets', 'buffer' },
--
--       providers = {
--         -- Your existing provider config...
--
--         -- RECOMMENDED: Prevents path completion in chat buffers
--         path = {
--           enabled = function()
--             local ft = vim.bo.filetype
--             return ft ~= "copilot-chat" and ft ~= "codecompanion"
--           end,
--         },
--
--         -- OPTIONAL: Add Copilot to completion menu
--         -- Only add this if you uncommented blink-copilot in ai.lua
--         -- and want Copilot suggestions in the menu instead of just ghost text
--         --[[
--         copilot = {
--           name = "copilot",
--           module = "blink-copilot", -- or "blink-cmp-copilot"
--           score_offset = 100, -- Show Copilot above other sources
--           async = true,
--         },
--         ]]--
--       },
--     },
--
--     -- Your other blink.cmp settings...
--   },
-- }
-- ```
--
-- **If using Copilot in completion menu:**
-- 1. Uncomment ONE of the blink-copilot plugins in `ai.lua`
-- 2. Add `'copilot'` to your sources default array
-- 3. Uncomment the copilot provider config above
--
--
-- ## Quick Reference: AI Keybindings
--
-- ```
-- ┌─────────────────────────────────────────────────────────┐
-- │ All under <leader>a prefix (default: <Space>a)          │
-- ├─────────────────────────────────────────────────────────┤
-- │ CHAT & GENERAL                                           │
-- │ <Space>aa - Toggle CodeCompanion chat                    │
-- │ <Space>ax - Add selection to chat                        │
-- │ <Space>aq - Quick question                               │
-- │ <Space>am - Select model/adapter                         │
-- │ <Space>aC - Actions menu (predefined prompts)            │
-- │                                                          │
-- │ VISUAL MODE (select code first)                         │
-- │ <Space>ae - Explain code                                 │
-- │ <Space>ar - Review code                                  │
-- │ <Space>af - Fix code                                     │
-- │ <Space>ao - Optimize code                                │
-- │ <Space>ad - Add documentation                            │
-- │ <Space>at - Generate tests                               │
-- │ <Space>aI - Inline assistant (custom prompt)            │
-- │                                                          │
-- │ GIT                                                      │
-- │ <Space>ac - Generate commit message                      │
-- │                                                          │
-- │ INSERT MODE (ghost text suggestions)                    │
-- │ Ctrl+g - Accept suggestion                               │
-- │ Ctrl+] - Next suggestion                                 │
-- │ Ctrl+[ - Previous suggestion                             │
-- │                                                          │
-- │ OTHER                                                    │
-- │ <Space>ta - Toggle AI suggestions on/off                │
-- └─────────────────────────────────────────────────────────┘
-- ```
--
-- **Note on Keybinding Scope:**
-- - Leader key mappings (<Space>a*) are global
-- - CodeCompanion chat buffer has many buffer-local keybindings that ONLY work inside the chat
-- - These won't interfere with your other global shortcuts!
--
--
-- ## CodeCompanion Chat Buffer Keybindings
--
-- **IMPORTANT:** Press `?` in the chat buffer to see all available keybindings!
--
-- These keybindings are **buffer-local** (only active in CodeCompanion chat):
--
-- **Sending & Control:**
-- - `<CR>` (Enter in normal) - Send message
-- - `<C-s>` (Ctrl-s in insert) - Send message
-- - `q` - Stop current request
-- - `<C-c>` - Close chat buffer
--
-- **Navigation:**
-- - `]]` / `[[` - Next/previous message header
-- - `}` / `{` - Next/previous chat
--
-- **Adapter & Model:**
-- - `ga` - Change adapter (switch between Claude, GPT, etc.)
-- - `gs` - Toggle system prompt
-- - `gS` - Show usage stats
--
-- **Code & Context:**
-- - `gy` - Yank last codeblock
-- - `gc` - Insert codeblock
-- - `gf` - Fold codeblocks
-- - `gp` - Pin context (file/buffer stays updated)
-- - `gw` - Watch buffer (track changes only)
--
-- **Debug & Advanced:**
-- - `gd` - Debug view (see full message history)
-- - `gD` - Super Diff (view all file changes)
-- - `gr` - Regenerate last response
-- - `gR` - Go to file under cursor
-- - `gx` - Clear chat contents
-- - `gM` - Clear memory
-- - `gta` - Toggle auto tool mode
--
--
-- ## Integration Modes
--
-- **Mode 1: Ghost Text Only (Default, Recommended)**
-- - Copilot shows suggestions as ghost text
-- - blink.cmp shows LSP/buffer completions
-- - No conflicts, best UX
-- - **Setup:** Nothing extra needed, works out of the box!
--
-- **Mode 2: In Completion Menu**
-- - Uncomment ONE blink-copilot plugin in `ai.lua`
-- - Add copilot source to `cmp.lua` (see above)
-- - See Copilot suggestions in menu with LSP items
-- - **Setup:** Follow "cmp.lua Configuration" section above
--
--
-- ## Switching Between Chat Providers
--
-- **Current Setup:**
-- - Primary: GitHub Copilot (default - uses your subscription!)
-- - Alternative: CopilotChat (commented out)
-- - Optional: Direct API access (Anthropic, OpenAI, Gemini) - see above
--
-- **To switch to CopilotChat:**
-- 1. Comment out the CodeCompanion plugin block (lines ~75-115)
-- 2. Uncomment the CopilotChat plugin block (lines ~225-365)
-- 3. Restart Neovim
--
-- **To use direct API providers:**
-- 1. See "Adding Direct API Access" section above
-- 2. Configure adapters and set environment variables
-- 3. Change the `adapter` in strategies from "copilot" to your preferred provider
--
-- **GitHub Copilot Models Available:**
-- Through your GitHub Copilot subscription, you get access to:
-- - GPT-4 and GPT-4o
-- - Claude 3.5 Sonnet
-- - o1-preview and o1-mini
--
-- Switch models in chat by pressing `ga` and selecting from the list!
--
-- **Why use direct API access?**
-- - Access to Claude Sonnet 4.5 (latest and most capable)
-- - More control over model parameters
-- - Higher rate limits for heavy usage
--
-- **Why stick with Copilot?**
-- - Included with your GitHub Copilot subscription
-- - No separate API keys or billing needed
-- - Multiple models available (GPT-4, Claude 3.5, o1)
-- - Simpler setup
--
--
-- ## Troubleshooting
--
-- **Copilot not suggesting:**
-- - Run `:Copilot status` to check connection
-- - Run `:Copilot auth` to re-authenticate
--
-- **CodeCompanion chat not working:**
-- - Make sure Copilot is authenticated: `:Copilot status`
-- - If showing "No token found", run `:Copilot auth` first
-- - Check available models with `ga` in the chat buffer
--
-- **Want to use direct API access (Claude 4.5, etc.):**
-- - See "Adding Direct API Access" section above
-- - Check environment variables: `:echo $ANTHROPIC_API_KEY`
-- - Verify API key is valid on provider's website
--
-- **Ghost text conflicts:**
-- - Already handled! `hide_during_completion = true`
-- - Copilot disabled in special buffers
--
-- **Path completion in chat:**
-- - Update cmp.lua to disable path provider in codecompanion buffers
-- - See "cmp.lua Configuration" section above
--
-- **Want Tab to accept:**
-- - Change `accept = "<Tab>"` in copilot.lua opts
-- - Note: May conflict with blink.cmp and snippet jumping
-- - Consider using a leader-based mapping instead
--
-- **Ctrl+l not working for window navigation:**
-- - This config intentionally disables <C-l> in CopilotChat (when enabled)
-- - Use <leader>ax to reset/clear chat instead
-- - Your Ctrl+w l for window navigation should work normally
--
--
-- ## macOS Terminal Configuration
--
-- **Problem:** By default, macOS terminals use Option/Alt for special characters (é, ñ, etc.)
--
-- **Solution Options:**
--
-- ### Option 1: Use Ctrl Keybindings (Default, Recommended)
-- The config uses Ctrl-based keybindings by default:
-- - `Ctrl+g` - Accept suggestion (works everywhere)
-- - `Ctrl+]` / `Ctrl+[` - Navigate suggestions
-- - No terminal configuration needed!
--
-- ### Option 2: Configure iTerm2 for Option Key
-- If you use iTerm2 and want Option-based keybindings:
--
-- 1. Open iTerm2 Preferences (⌘+,)
-- 2. Go to: Profiles → Keys → General
-- 3. Set "Left Option Key" to: **Esc+**
-- 4. (Optional) Set "Right Option Key" to: **Normal** (for typing special chars)
-- 5. Uncomment the Option-based keybindings in the config
--
-- ### Option 3: Configure Alacritty/Kitty
-- These modern terminals handle Alt better. Add to config:
--
-- **Alacritty** (`~/.config/alacritty/alacritty.toml`):
-- ```toml
-- [keyboard]
-- # Make Option work as Alt
-- [keyboard.bindings]
-- { key = "Return", mods = "Alt", chars = "\u001b\r" }
-- ```
--
-- **Kitty** (`~/.config/kitty/kitty.conf`):
-- ```
-- macos_option_as_alt yes
-- ```
--
-- ### Option 4: Use Leader-Based Mappings
-- If neither Ctrl nor Option works well, use leader mappings:
--
-- ```lua
-- keymap = {
--   accept = false,  -- Disable default
--   next = false,
--   prev = false,
--   dismiss = false,
-- }
-- ```
--
-- Then add in your keymaps:
-- ```lua
-- vim.keymap.set('i', '<leader><leader>', function()
--   if require("copilot.suggestion").is_visible() then
--     require("copilot.suggestion").accept()
--   end
-- end)
-- ```
--
-- ### Recommended Setup for macOS:
-- 1. **Start with Ctrl keybindings** (current default)
-- 2. Try them for a few days
-- 3. If you want Option, configure iTerm2
-- 4. Keep Right Option normal for special characters
--
--
-- ## Optional Integrations
--
-- **Lualine Status** (add to your lualine config):
-- ```lua
-- sections = {
--   lualine_x = {
--     {
--       function()
--         local icon = " "
--         if package.loaded["copilot"] then
--           local status = require("copilot.api").status.data.status
--           if status == "InProgress" then return icon .. "..." end
--           if status == "Warning" then return icon .. "!" end
--           return icon
--         end
--         return ""
--       end,
--     },
--   },
-- }
-- ```
--
--
-- ## Why This Approach?
--
-- This config combines best practices from both LazyVim and CodeCompanion:
-- 1. Uses ghost text by default (better UX)
-- 2. Proper lazy-loading (faster startup)
-- 3. Non-conflicting keybindings
-- 4. Works perfectly with blink.cmp
-- 5. Minimal but complete
-- 6. Clean file organization
-- 7. Access to latest AI models (Claude 4.5)
-- 8. Multi-provider flexibility
--
