-- AI/LLM Integration for Neovim
-- Copilot: Ghost text suggestions (toggleable)
-- CodeCompanion: Multi-provider AI chat & code actions (Copilot, LM Studio, Anthropic, etc.)

return {
    -- GitHub Copilot (ghost text, toggleable)
    {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
      opts = {
        suggestion = {
          enabled = false, -- Off by default; toggle with <leader>ta
          auto_trigger = true,
          hide_during_completion = true,
          keymap = {
            accept = "<C-g>",
            accept_word = false,
            accept_line = false,
            next = "<C-]>",
            prev = "<C-[>",
            dismiss = "<Esc><Esc>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          ["*"] = true,
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

    -- CodeCompanion: Multi-provider AI chat & code actions (Copilot, LM Studio, Anthropic, etc.)
    {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
      opts = {
        adapters = {
          http = {
            ollama = function()
              return require("codecompanion.adapters").extend("openai_compatible", {
                env = {
                  url = "http://localhost:1234", -- LM Studio default port
                },
              })
            end,
          },
        },
        -- Default: Copilot (uses your GitHub Copilot subscription, no API keys required)
        strategies = {
          chat = {
            adapter = "copilot",
            slash_commands = {
              ["file"] = { opts = { provider = "snacks", auto_insert = true } },
              ["buffer"] = { opts = { provider = "snacks", auto_insert = true } },
              ["help"] = { opts = { provider = "snacks" } },
              ["symbols"] = { opts = { provider = "snacks" } },
            },
          },
          inline = { adapter = "copilot" },
        },
      -- extensions = {
      --   mcphub = {
      --     callback = "mcphub.extensions.codecompanion",
      --     opts = {
      --       make_tools = true, -- Enable MCP tools
      --       show_server_tools_in_chat = true,
      --       add_mcp_prefix_to_tool_names = false,
      --       show_result_in_chat = true,
      --       make_vars = true, -- Enable MCP resources
      --       make_slash_commands = true, -- Enable MCP prompts
      --     },
      --   },
      -- },
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
          
          -- Enable render-markdown for codecompanion buffers
          local has_render_markdown, render_markdown = pcall(require, "render-markdown")
          if has_render_markdown then
            vim.treesitter.language.register('markdown', 'codecompanion')
            render_markdown.enable()
          end
          
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

        --[[
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
                  -- Force normal mode if coming from codecompanion chat
                  if vim.api.nvim_get_mode().mode:find('i') then
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
                  end
                end
              end)
            end
          end,
        })
        ]]--

        -- Force normal mode when leaving codecompanion chat for a file buffer (even if not redirected)
        -- Also handle window focus changes (for splits)
        vim.api.nvim_create_autocmd("WinEnter", {
          pattern = "*",
          callback = function()
            local cur_win = vim.api.nvim_get_current_win()
            local cur_buf = vim.api.nvim_win_get_buf(cur_win)
            local cur_ft = vim.bo[cur_buf].filetype
            -- Find the previously focused window (if any)
            local prev_win = vim.fn.win_getid(vim.fn.winnr('#'))
            if prev_win and vim.api.nvim_win_is_valid(prev_win) then
              local prev_buf = vim.api.nvim_win_get_buf(prev_win)
              local prev_ft = vim.bo[prev_buf].filetype
              if prev_ft == "codecompanion" and cur_ft ~= "codecompanion" then
                vim.schedule(function()
                  if vim.api.nvim_get_mode().mode:find('i') then
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
                  end
                end)
              end
            end
          end,
        })

        -- (Retain BufEnter for edge cases)
        vim.api.nvim_create_autocmd("BufEnter", {
          pattern = "*",
          callback = function()
            local prev_buf = vim.fn.bufnr('#')
            if prev_buf > 0 and vim.bo[prev_buf].filetype == "codecompanion" and vim.bo.filetype ~= "codecompanion" then
              vim.schedule(function()
                if vim.api.nvim_get_mode().mode:find('i') then
                  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
                end
              end)
            end
          end,
        })
      end,
  },

    -- mcphub.nvim: Optional, for advanced multi-provider orchestration
    -- {
    --   "ravitemer/mcphub.nvim",
    --   dependencies = { "olimorris/codecompanion.nvim" },
    --   build = "npm install -g mcp-hub@latest",
    --   cmd = { "MCPHub" },
    --   opts = {},
    -- },

    -- CopilotChat.nvim: Optional, alternative chat interface (commented out)
    -- {
    --   "CopilotC-Nvim/CopilotChat.nvim",
    --   dependencies = { { "zbirenbaum/copilot.lua" }, { "nvim-lua/plenary.nvim" } },
    --   build = "make tiktoken",
    --   cmd = "CopilotChat",
    --   opts = function() return {} end,
    -- },

  -- Optional: Copilot in Completion Menu
  -- By default, Copilot uses ghost text. Uncomment ONE below for menu integration:

    -- Completion menu integration (optional, commented out)
    -- {
    --   "giuxtaposition/blink-cmp-copilot",
    --   dependencies = { "zbirenbaum/copilot.lua" },
    --   opts = {},
    -- },
    -- {
    --   "fang2hou/blink-copilot",
    --   dependencies = { "zbirenbaum/copilot.lua" },
    --   opts = {},
    -- },

    -- Codeium: Free Copilot alternative (optional, commented out)
    -- {
    --   "Exafunction/codeium.nvim",
    --   dependencies = { "nvim-lua/plenary.nvim" },
    --   cmd = "Codeium",
    --   event = "InsertEnter",
    --   opts = { enable_chat = true },
    -- },
}

--
-- Keybindings (normal/visual mode):
-- <leader>aa: Toggle CodeCompanion chat
-- <leader>ax: Add to chat
-- <leader>aq: Quick chat
-- <leader>aC: Actions menu
-- <leader>ae/ar/af/ao/ad/at: Code actions (visual)
-- <leader>aI: Inline assistant
-- <leader>ac: Generate commit message
-- <leader>ta: Toggle Copilot ghost text
--
-- Copilot: Authenticate with :Copilot auth
-- CodeCompanion: Uses Copilot by default, supports local/remote LLMs
--
-- For API providers (Anthropic, OpenAI, Gemini): set env vars and update adapters in CodeCompanion opts.
--
