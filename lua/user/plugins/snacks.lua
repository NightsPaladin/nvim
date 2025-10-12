-- lua/user/plugins/snacks.lua
-- Comprehensive snacks.nvim configuration
-- Replaces: toggleterm, lazygit keybindings, and adds quality-of-life features

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- Core modules
    bigfile = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
      -- Filter out notifications for non-file buffers (prevents Copilot errors in special buffers)
      filter = function(notif)
        local bufnr = vim.api.nvim_get_current_buf()
        return vim.bo[bufnr].buftype == ""
      end,
    },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {},

    -- Dashboard (optional, disable if you prefer a different dashboard)
    dashboard = { enabled = false },

    -- Input (better vim.ui.input)
    input = { enabled = true },

    -- Indent guides (using mini.indentscope instead, so disabled)
    indent = { enabled = false },

    -- Picker (optional, using Telescope as primary picker)
    picker = { enabled = true },

    -- Terminal configuration (replaces toggleterm)
    terminal = {
      enabled = true,
      win = {
        style = "terminal",
      },
    },

    -- LazyGit integration (replaces toggleterm lazygit setup)
    lazygit = {
      enabled = true,
      configure = true,
      -- Theme settings
      theme = {
        [241] = { fg = "Special" },
        activeBorderColor = { fg = "MatchParen", bold = true },
        cherryPickedCommitBgColor = { fg = "Identifier" },
        cherryPickedCommitFgColor = { fg = "Function" },
        defaultFgColor = { fg = "Normal" },
        inactiveBorderColor = { fg = "FloatBorder" },
        optionsTextColor = { fg = "Function" },
        searchingActiveBorderColor = { fg = "MatchParen", bold = true },
        selectedLineBgColor = { bg = "Visual" },
        unstagedChangesColor = { fg = "DiagnosticError" },
      },
      win = {
        style = "lazygit",
      },
    },

    -- Git utilities
    git = { enabled = true },
    gitbrowse = { enabled = true },

    -- Buffer deletion (already using mini.bufremove, but keeping for compatibility)
    bufdelete = { enabled = true },

    -- Scratch buffers
    scratch = { enabled = true },

    -- Toggle utilities
    toggle = { enabled = true },

    -- Zen mode
    zen = { enabled = true },

    -- File renaming
    rename = { enabled = true },

    -- Scroll (smooth scrolling)
    scroll = { enabled = true },
  },

  keys = {
    -- ==================== Terminal Keymaps (replaces toggleterm) ====================
    -- Per-directory terminals: Each directory gets its own set of terminals
    -- <Leader>1 - Horizontal terminal (per directory)
    -- <Leader>2 - Vertical terminal (per directory)
    -- <Leader>3 - Float terminal (per directory)
    -- <C-\> - Toggle last used terminal

    -- Helper function to get or create a terminal for a specific directory and type
    -- This is defined inline so it's available when keys are evaluated

    -- Horizontal terminal per directory
    {
      "<leader>1",
      function()
        -- Check if we're already in one of our managed terminals
        local current_buf = vim.api.nvim_get_current_buf()
        local current_win = vim.api.nvim_get_current_win()

        -- Check if current buffer is a managed terminal
        for key, buf in pairs(_G.snacks_terminals) do
          if buf == current_buf and key:match("^horizontal_") then
            -- We're in the terminal, just close the window
            vim.api.nvim_win_close(current_win, true)
            return
          end
        end

        -- Not in a terminal, so open/toggle one
        local dir = vim.fn.expand("%:p:h")
        -- Fallback to cwd if current buffer has no valid directory
        if dir == "" or vim.fn.isdirectory(dir) == 0 then
          dir = vim.fn.getcwd()
        end
        local key = "horizontal_" .. dir

        -- Get or create terminal instance
        if not _G.snacks_terminals[key] or not vim.api.nvim_buf_is_valid(_G.snacks_terminals[key]) then
          _G.snacks_terminals[key] = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_call(_G.snacks_terminals[key], function()
            vim.fn.jobstart(vim.o.shell, {
              term = true,
              cwd = dir,
              on_exit = function()
                -- Close all windows displaying this terminal buffer
                local wins = vim.fn.win_findbuf(_G.snacks_terminals[key])
                for _, win in ipairs(wins) do
                  if vim.api.nvim_win_is_valid(win) then
                    vim.api.nvim_win_close(win, true)
                  end
                end
                -- Clean up the buffer reference
                _G.snacks_terminals[key] = nil
              end,
            })
          end)
        end

        -- Open/toggle the terminal with proper window config
        local buf = _G.snacks_terminals[key]
        local wins = vim.fn.win_findbuf(buf)

        if #wins > 0 then
          -- Terminal is visible, close it
          vim.api.nvim_win_close(wins[1], true)
        else
          -- Open terminal in horizontal split
          vim.cmd("botright split")
          local win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_buf(win, buf)
          vim.api.nvim_win_set_height(win, math.floor(vim.o.lines * 0.3))
          -- Disable line numbers in terminal
          vim.wo[win].number = false
          vim.wo[win].relativenumber = false
          vim.cmd("startinsert")
        end
      end,
      desc = "Terminal (horizontal, per-directory)",
      mode = { "n", "t" },
    },

    -- Vertical terminal per directory
    {
      "<leader>2",
      function()
        -- Check if we're already in one of our managed terminals
        local current_buf = vim.api.nvim_get_current_buf()
        local current_win = vim.api.nvim_get_current_win()

        -- Check if current buffer is a managed terminal
        for key, buf in pairs(_G.snacks_terminals) do
          if buf == current_buf and key:match("^vertical_") then
            -- We're in the terminal, just close the window
            vim.api.nvim_win_close(current_win, true)
            return
          end
        end

        -- Not in a terminal, so open/toggle one
        local dir = vim.fn.expand("%:p:h")
        -- Fallback to cwd if current buffer has no valid directory
        if dir == "" or vim.fn.isdirectory(dir) == 0 then
          dir = vim.fn.getcwd()
        end
        local key = "vertical_" .. dir

        -- Get or create terminal instance
        if not _G.snacks_terminals[key] or not vim.api.nvim_buf_is_valid(_G.snacks_terminals[key]) then
          _G.snacks_terminals[key] = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_call(_G.snacks_terminals[key], function()
            vim.fn.jobstart(vim.o.shell, {
              term = true,
              cwd = dir,
              on_exit = function()
                -- Close all windows displaying this terminal buffer
                local wins = vim.fn.win_findbuf(_G.snacks_terminals[key])
                for _, win in ipairs(wins) do
                  if vim.api.nvim_win_is_valid(win) then
                    vim.api.nvim_win_close(win, true)
                  end
                end
                -- Clean up the buffer reference
                _G.snacks_terminals[key] = nil
              end,
            })
          end)
        end

        -- Open/toggle the terminal with proper window config
        local buf = _G.snacks_terminals[key]
        local wins = vim.fn.win_findbuf(buf)

        if #wins > 0 then
          -- Terminal is visible, close it
          vim.api.nvim_win_close(wins[1], true)
        else
          -- Open terminal in vertical split
          vim.cmd("botright vsplit")
          local win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_buf(win, buf)
          vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.4))
          -- Disable line numbers in terminal
          vim.wo[win].number = false
          vim.wo[win].relativenumber = false
          vim.cmd("startinsert")
        end
      end,
      desc = "Terminal (vertical, per-directory)",
      mode = { "n", "t" },
    },

    -- Float terminal per directory
    {
      "<leader>3",
      function()
        -- Check if we're already in one of our managed terminals
        local current_buf = vim.api.nvim_get_current_buf()
        local current_win = vim.api.nvim_get_current_win()

        -- Check if current buffer is a managed terminal
        for key, buf in pairs(_G.snacks_terminals) do
          if buf == current_buf and key:match("^float_") then
            -- We're in the terminal, just close the window
            vim.api.nvim_win_close(current_win, true)
            return
          end
        end

        -- Not in a terminal, so open/toggle one
        local dir = vim.fn.expand("%:p:h")
        -- Fallback to cwd if current buffer has no valid directory
        if dir == "" or vim.fn.isdirectory(dir) == 0 then
          dir = vim.fn.getcwd()
        end
        local key = "float_" .. dir

        -- Get or create terminal instance
        if not _G.snacks_terminals[key] or not vim.api.nvim_buf_is_valid(_G.snacks_terminals[key]) then
          _G.snacks_terminals[key] = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_call(_G.snacks_terminals[key], function()
            vim.fn.jobstart(vim.o.shell, {
              term = true,
              cwd = dir,
              on_exit = function()
                -- Close all windows displaying this terminal buffer
                local wins = vim.fn.win_findbuf(_G.snacks_terminals[key])
                for _, win in ipairs(wins) do
                  if vim.api.nvim_win_is_valid(win) then
                    vim.api.nvim_win_close(win, true)
                  end
                end
                -- Clean up the buffer reference
                _G.snacks_terminals[key] = nil
              end,
            })
          end)
        end

        -- Open/toggle the terminal with proper window config
        local buf = _G.snacks_terminals[key]
        local wins = vim.fn.win_findbuf(buf)

        if #wins > 0 then
          -- Terminal is visible, close it
          vim.api.nvim_win_close(wins[1], true)
        else
          -- Open terminal in floating window
          local width = math.floor(vim.o.columns * 0.8)
          local height = math.floor(vim.o.lines * 0.8)
          local row = math.floor((vim.o.lines - height) / 2)
          local col = math.floor((vim.o.columns - width) / 2)

          local win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = width,
            height = height,
            row = row,
            col = col,
            style = "minimal",
            border = "rounded",
          })
          -- Disable line numbers in terminal
          vim.wo[win].number = false
          vim.wo[win].relativenumber = false
          vim.cmd("startinsert")
        end
      end,
      desc = "Terminal (float, per-directory)",
      mode = { "n", "t" },
    },

    -- Toggle terminal with C-\ (replaces toggleterm default)
    {
      "<c-\\>",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
      mode = { "n", "t" },
    },

    -- Additional terminal shortcuts
    -- {
    --   "<leader>tt",
    --   function()
    --     Snacks.terminal()
    --   end,
    --   desc = "[T]oggle [T]erminal",
    -- },

    -- {
    --   "<leader>tf",
    --   function()
    --     Snacks.terminal(nil, { cwd = vim.fn.expand("%:p:h") })
    --   end,
    --   desc = "[T]erminal in [F]ile directory (explicit)",
    -- },

    -- ==================== LazyGit (replaces toggleterm lazygit) ====================
    -- Your toggleterm had: <Leader>gg for lazygit

    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit (cwd)",
    },

    {
      "<leader>gf",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Lazygit Current File History",
    },

    {
      "<leader>gL",
      function()
        Snacks.lazygit.log()
      end,
      desc = "Lazygit Log (cwd)",
    },

    -- ==================== Git Utilities ====================

    {
      "<leader>gB",
      function()
        Snacks.git.blame_line()
      end,
      desc = "Git Blame Line",
    },

    {
      "<leader>gy",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse & Yank Link",
      mode = { "n", "v" },
    },

    -- ==================== Buffer Management ====================

    {
      "<leader>bo",
      function()
        Snacks.bufdelete.other()
      end,
      desc = "[B]uffer delete [O]thers",
    },

    -- ==================== Scratch Buffers ====================

    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },

    {
      "<leader>,",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },

    -- ==================== Notifications ====================

    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },

    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Hide [N]otifications",
    },

    -- ==================== File Operations ====================

    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },

    -- ==================== Zen Mode ====================

    {
      "<leader>z.",
      function()
        Snacks.zen()
      end,
      desc = "[Z]en mode",
    },

    {
      "<leader>zZ",
      function()
        Snacks.zen.zoom()
      end,
      desc = "[Z]oom (zen with zoom)",
    },

    -- ==================== Word Highlighting ====================

    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },

    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
      mode = { "n", "t" },
    },

    -- ==================== Neovim News ====================

    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },

    -- ==================== Snacks Picker (optional, using Telescope as primary) ====================
    -- These use capital S prefix to differentiate from Telescope

    {
      "<leader>sf",
      function()
        Snacks.picker.files()
      end,
      desc = "Snacks: Files",
    },

    {
      "<leader>sg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Snacks: Grep",
    },

    {
      "<leader>sb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Snacks: Buffers",
    },

    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "Snacks: Help",
    },

    {
      "<leader>so",
      function()
        Snacks.picker.recent()
      end,
      desc = "Snacks: Recent Files",
    },
  },

  init = function()
    -- Global table to track terminal instances per directory and type
    _G.snacks_terminals = _G.snacks_terminals or {}

    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>ur")
        Snacks.toggle.diagnostics():map("<leader>td")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle
          .option("conceallevel", {
            off = 0,
            on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
          })
          :map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>tt")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>ui")
        Snacks.toggle.words():map("<leader>uW") -- Capital W to differentiate from wrap
      end,
    })
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
