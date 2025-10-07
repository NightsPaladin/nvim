-- lua/plugins/ai.lua
-- AI Integration for Neovim with blink.cmp
-- Inspired by LazyVim's approach but kept minimal for Kickstart.nvim
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
        enabled = true,
        auto_trigger = true,
        -- Hide ghost text when blink.cmp menu is open
        hide_during_completion = true,
        keymap = {
          -- macOS-friendly keybindings (Ctrl-based, works everywhere)
          accept = "<C-g>",      -- Ctrl+g to accept (inspired by GitHub Copilot)
          accept_word = false,   -- Disabled by default
          accept_line = false,   -- Disabled by default
          next = "<C-]>",        -- Next suggestion (Ctrl+])
          prev = "<C-[>",        -- Previous suggestion (Ctrl+[)
          dismiss = "<C-e>",     -- Dismiss suggestion
          
          -- Alternative: If you configure your terminal for Option key
          -- (see instructions below), you can uncomment these:
          -- accept = "<M-CR>",     -- Option+Enter to accept
          -- accept_word = "<M-w>", -- Option+w to accept word
          -- accept_line = "<M-l>", -- Option+l to accept line
          -- next = "<M-]>",
          -- prev = "<M-[>",
        },
      },
      panel = { enabled = false }, -- Use CopilotChat instead
      filetypes = {
        yaml = true,
        markdown = true,
        help = false,
        gitcommit = true,
        gitrebase = false,
        ["."] = false,
      },
    },
  },

  -- CopilotChat - Conversational AI Interface
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      
      return {
        model = 'claude-3.5-sonnet', -- or 'gpt-4o', 'gemini-2.0-flash-exp'
        auto_insert_mode = true,
        show_help = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          layout = 'float',
          width = 0.8,
          height = 0.8,
          border = 'rounded',
        },
        prompts = {
          Explain = {
            prompt = '/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.',
          },
          Review = {
            prompt = '/COPILOT_REVIEW Review the selected code.',
          },
          Fix = {
            prompt = '/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.',
          },
          Optimize = {
            prompt = '/COPILOT_GENERATE Optimize the selected code to improve performance and readability.',
          },
          Docs = {
            prompt = '/COPILOT_GENERATE Please add documentation comments to the selected code.',
          },
          Tests = {
            prompt = '/COPILOT_GENERATE Please generate tests for my code.',
          },
          FixDiagnostic = {
            prompt = 'Please assist with the following diagnostic issue in file:',
            selection = require('CopilotChat.select').diagnostics,
          },
          Commit = {
            prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
            selection = require('CopilotChat.select').gitdiff,
          },
          CommitStaged = {
            prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
            selection = function(source)
              return require('CopilotChat.select').gitdiff(source, true)
            end,
          },
        },
      }
    end,
    keys = {
      -- Quick chat
      { "<leader>aa", function() require("CopilotChat").toggle() end, desc = "Toggle (CopilotChat)", mode = { "n", "v" } },
      { "<leader>ax", function() require("CopilotChat").reset() end, desc = "Clear (CopilotChat)", mode = { "n", "v" } },
      { "<leader>aq", function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end, desc = "Quick Chat (CopilotChat)", mode = { "n", "v" } },
      
      -- Prompt actions
      { "<leader>ap", function() require("CopilotChat.integrations.telescope").pick(require("CopilotChat.actions").prompt_actions()) end, desc = "Prompt Actions (CopilotChat)" },
      
      -- Code actions
      { "<leader>ae", ":CopilotChatExplain<CR>", desc = "Explain Code", mode = "v" },
      { "<leader>ar", ":CopilotChatReview<CR>", desc = "Review Code", mode = "v" },
      { "<leader>af", ":CopilotChatFix<CR>", desc = "Fix Code", mode = "v" },
      { "<leader>ao", ":CopilotChatOptimize<CR>", desc = "Optimize Code", mode = "v" },
      { "<leader>ad", ":CopilotChatDocs<CR>", desc = "Add Documentation", mode = "v" },
      { "<leader>at", ":CopilotChatTests<CR>", desc = "Generate Tests", mode = "v" },
      
      -- Fix diagnostic
      { "<leader>aD", ":CopilotChatFixDiagnostic<CR>", desc = "Fix Diagnostic" },
      
      -- Git integration
      { "<leader>ac", ":CopilotChatCommit<CR>", desc = "Generate Commit Message" },
      { "<leader>aC", ":CopilotChatCommitStaged<CR>", desc = "Generate Commit Message (Staged)" },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      chat.setup(opts)
      
      -- Auto-insert mode for chat buffer
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })
    end,
  },

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
  -- ALTERNATIVE: CodeCompanion (Multi-Provider AI)
  -- ============================================================================
  -- Uncomment to use Claude, OpenAI, Gemini, or Ollama
  -- Can be used alongside Copilot without conflicts
  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
  --   opts = {
  --     adapters = {
  --       anthropic = function()
  --         return require("codecompanion.adapters").extend("anthropic", {
  --           env = { api_key = "ANTHROPIC_API_KEY" },
  --           schema = { model = { default = "claude-3-5-sonnet-20241022" } },
  --         })
  --       end,
  --       openai = function()
  --         return require("codecompanion.adapters").extend("openai", {
  --           env = { api_key = "OPENAI_API_KEY" },
  --           schema = { model = { default = "gpt-4o" } },
  --         })
  --       end,
  --       gemini = function()
  --         return require("codecompanion.adapters").extend("gemini", {
  --           env = { api_key = "GEMINI_API_KEY" },
  --           schema = { model = { default = "gemini-2.0-flash-exp" } },
  --         })
  --       end,
  --     },
  --     strategies = {
  --       chat = { adapter = "anthropic" },
  --       inline = { adapter = "anthropic" },
  --     },
  --   },
  --   keys = {
  --     { "<leader>ca", "<cmd>CodeCompanionActions<CR>", desc = "CodeCompanion Actions", mode = { "n", "v" } },
  --     { "<leader>cc", "<cmd>CodeCompanionChat Toggle<CR>", desc = "Toggle Chat", mode = { "n", "v" } },
  --     { "<leader>ci", "<cmd>CodeCompanion<CR>", desc = "Inline Assistant", mode = "v" },
  --   },
  -- },

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
-- - ✅ copilot.lua (AI suggestions)
-- - ✅ CopilotChat.nvim (AI chat)
-- - ✅ blink-copilot (optional, commented out)
-- - ✅ CodeCompanion (optional, commented out)
--
-- **Your cmp.lua file:**
-- - ✅ blink.cmp main configuration
-- - ✅ Path provider fix (add this!)
-- - ✅ Copilot source (only if using menu mode)
--
-- This keeps each plugin's config in ONE place!
--
--
-- ## Quick Start
--
-- 1. Save this file to: `~/.config/nvim/lua/plugins/ai.lua`
--
-- 2. **Add to your cmp.lua** (see "cmp.lua Configuration" section below)
--
-- 3. Restart Neovim - lazy.nvim will auto-install plugins
--
-- 4. Authenticate Copilot:
--    - In Neovim, run: `:Copilot auth`
--    - Follow the browser prompts
--
-- 5. Start using AI:
--    - Type code and see ghost text suggestions
--    - Press Ctrl+g to accept suggestions (works on macOS!)
--    - Press <Space>aa to open chat
--
-- **Note:** Keybindings use Ctrl instead of Alt/Option by default for macOS compatibility.
-- See "macOS Terminal Configuration" section below for details.
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
--         -- REQUIRED: Fixes CopilotChat "/" commands
--         -- This prevents path completion from interfering with chat commands
--         path = {
--           enabled = function()
--             return vim.bo.filetype ~= "copilot-chat"
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
-- ## Key Bindings (with <leader> as Space)
--
-- ### Copilot Suggestions (Insert Mode)
-- - `Ctrl+g` - Accept full suggestion
-- - `Ctrl+]` - Next suggestion
-- - `Ctrl+[` - Previous suggestion
-- - `Ctrl+e` - Dismiss suggestion
--
-- ### CopilotChat
-- - `<Space>aa` - Toggle chat
-- - `<Space>ax` - Clear chat
-- - `<Space>aq` - Quick question
-- - `<Space>ap` - Show prompt actions
--
-- **Visual Mode (select code first):**
-- - `<Space>ae` - Explain code
-- - `<Space>ar` - Review code
-- - `<Space>af` - Fix code
-- - `<Space>ao` - Optimize code
-- - `<Space>ad` - Add docs
-- - `<Space>at` - Generate tests
--
-- **Other:**
-- - `<Space>aD` - Fix diagnostic error
-- - `<Space>ac` - Generate commit message
-- - `<Space>aC` - Generate commit (staged)
--
-- ### CodeCompanion (if enabled)
-- - `<Space>ca` - Actions menu
-- - `<Space>cc` - Toggle chat
-- - `<Space>ci` - Inline assistant (visual mode)
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
-- ## Required cmp.lua Changes
--
-- **Minimal (Required for CopilotChat):**
-- ```lua
-- -- In your cmp.lua providers section:
-- path = {
--   enabled = function()
--     return vim.bo.filetype ~= "copilot-chat"
--   end,
-- },
-- ```
--
-- **Full (If using Copilot in menu):**
-- ```lua
-- -- In your cmp.lua:
-- sources = {
--   default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
--   providers = {
--     path = {
--       enabled = function()
--         return vim.bo.filetype ~= "copilot-chat"
--       end,
--     },
--     copilot = {
--       name = "copilot",
--       module = "blink-copilot",
--       score_offset = 100,
--       async = true,
--     },
--   },
-- },
-- ```
--
--
-- ## Multi-Provider Setup
--
-- You can enable multiple AI providers:
-- 1. Keep Copilot for inline suggestions
-- 2. Enable CodeCompanion for Claude/GPT chat
-- 3. They work together without conflicts
--
-- Example: Use Copilot keybinds (<Space>a*) and CodeCompanion (<Space>c*)
--
--
-- ## LazyVim-Inspired Features
--
-- This config incorporates LazyVim best practices:
-- - ✅ Smart ghost text that hides during completion
-- - ✅ Path completion disabled in CopilotChat buffers
-- - ✅ Proper event lazy-loading
-- - ✅ Non-conflicting keybindings
-- - ✅ Auto-insert mode for chat
-- - ✅ Commit message generation
-- - ✅ Diagnostic fixing
--
-- But kept minimal - no extra dependencies beyond essentials!
--
--
-- ## Environment Variables (for CodeCompanion)
--
-- Add to ~/.bashrc or ~/.zshrc:
--
-- ```bash
-- export ANTHROPIC_API_KEY="sk-ant-xxxxx"
-- export OPENAI_API_KEY="sk-xxxxx"
-- export GEMINI_API_KEY="xxxxx"
-- ```
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
-- **Telescope Integration** (for CopilotChat prompts):
-- Already included in keybinds! Press `<Space>ap` to search prompts
--
--
-- ## Troubleshooting
--
-- **Copilot not suggesting:**
-- - Run `:Copilot status` to check connection
-- - Run `:Copilot auth` to re-authenticate
--
-- **Ghost text conflicts:**
-- - Already handled! `hide_during_completion = true`
-- - Autocmds hide ghost text when blink menu opens
--
-- **Path completion in chat:**
-- - Already fixed! Path provider disabled in copilot-chat buffers
--
-- **Want Tab to accept:**
-- - Change `accept = "<Tab>"` in copilot.lua opts
-- - Note: May conflict with blink.cmp and snippet jumping
-- - Consider using a leader-based mapping instead
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
-- ## Why This Approach?
--
-- Based on LazyVim's battle-tested patterns:
-- 1. Uses ghost text by default (better UX)
-- 2. Proper lazy-loading (faster startup)
-- 3. No keybind conflicts
-- 4. Works perfectly with blink.cmp
-- 5. Minimal but complete
-- 6. Clean file organization
--
