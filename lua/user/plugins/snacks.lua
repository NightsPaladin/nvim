-- lua/user/plugins/snacks.lua
-- Comprehensive snacks.nvim configuration
-- Replaces: toggleterm, lazygit, and Telescope

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  dependencies = { "nvim-lua/plenary.nvim" }, -- Required for project management
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

    -- Picker configuration (replaces Telescope)
    picker = {
      enabled = true,
      -- Window configuration to prevent stealing current buffer
      win = {
        style = "picker",
      },
      -- Use default keybinds and just add/override what we need
      sources = {
        files = {
          hidden = true, -- Show hidden files
          follow = true, -- Follow symlinks
        },
        grep = {
          hidden = true, -- Search in hidden files
        },
        buffers = {
          -- Custom keymaps for the buffers picker
          win = {
            input = {
              keys = {
                ["dd"] = { "bufdelete", mode = "n" },
                ["yy"] = { "yank", mode = "n" },
              },
            },
          },
        },
      },
      formatters = {
        file = {
          filename_first = false, -- Show path before filename (like Telescope)
        },
      },
    },

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

    -- Buffer deletion
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
          local width = math.floor(vim.o.columns * 0.9)
          local height = math.floor(vim.o.lines * 0.9)
          local col = math.floor((vim.o.columns - width) / 2)
          local row = math.floor((vim.o.lines - height) / 2)

          local win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = width,
            height = height,
            col = col,
            row = row,
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

    -- ==================== LazyGit (replaces toggleterm lazygit) ====================

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
      desc = "Lazygit Current [F]ile History",
    },

    {
      "<leader>gL",
      function()
        Snacks.lazygit.log()
      end,
      desc = "[L]azygit Log (cwd)",
    },

    -- ==================== Git Utilities ====================

    {
      "<leader>gB",
      function()
        Snacks.git.blame_line()
      end,
      desc = "[G]it [B]lame Line",
    },

    {
      "<leader>gy",
      function()
        Snacks.gitbrowse()
      end,
      desc = "[G]it Browse & [Y]ank Link",
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
      "<leader>sn",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },

    {
      "<leader>sN",
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
      "<leader>sz",
      function()
        Snacks.zen()
      end,
      desc = "Snacks: [Z]en mode",
    },

    {
      "<leader>sZ",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Snacks: [Z]oom (zen with zoom)",
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
      desc = "[N]eovim News",
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

    -- ==================== Snacks Picker (replaces Telescope) ====================
    -- All your Telescope keymaps migrated to Snacks.picker

    -- File pickers
    {
      "<leader>fc",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "[F]ind [C]olorscheme",
    },

    {
      "<leader>fh",
      function()
        Snacks.picker.help()
      end,
      desc = "[F]ind [H]elp",
    },

    {
      "<leader>fk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "[F]ind [K]eymaps",
    },

    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "[F]ind [F]iles",
    },

    {
      "<leader>fw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "[F]ind current [W]ord",
    },

    {
      "<leader>fg",
      function()
        Snacks.picker.grep()
      end,
      desc = "[F]ind by [G]rep",
    },

    {
      "<leader>fd",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "[F]ind [D]iagnostics",
    },

    {
      "<leader>fr",
      function()
        Snacks.picker.resume()
      end,
      desc = "[F]ind [R]esume",
    },

    {
      "<leader>f.",
      function()
        Snacks.picker.recent()
      end,
      desc = '[F]ind Recent Files ("." for repeat)',
    },

    -- LSP Document symbols
    {
      "<leader>fl",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "[F]ind Document Symbo[l]s",
    },

    -- Buffers
    {
      "<leader><leader>",
      function()
        Snacks.picker.buffers()
      end,
      desc = "[ ] Find existing buffers",
    },

    -- Search in current buffer
    {
      "<leader>/",
      function()
        Snacks.picker.lines()
      end,
      desc = "[/] Fuzzily search in current buffer",
    },

    -- Grep in open files
    {
      "<leader>f/",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "[F]ind [/] in Open Files",
    },

    -- Find Neovim config files
    {
      "<leader>fn",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "[F]ind [N]eovim files",
    },

    -- Git pickers
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "[G]it [S]tatus",
    },

    {
      "<leader>gc",
      function()
        Snacks.picker.git_log()
      end,
      desc = "[G]it [C]ommits",
    },

    -- NOTE: LSP keybinds (grr, grd, gri, grt, gO, gW) are in your lsp.lua

    -- Additional useful pickers
    {
      "<leader>fm",
      function()
        Snacks.picker.marks()
      end,
      desc = "[F]ind [M]arks",
    },

    {
      "<leader>fj",
      function()
        Snacks.picker.jumps()
      end,
      desc = "[F]ind [J]umps",
    },

    {
      "<leader>fq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "[F]ind [Q]uickfix",
    },

    {
      "<leader>fv",
      function()
        Snacks.picker.vim_options()
      end,
      desc = "[F]ind [V]im Options",
    },

    {
      "<leader>fa",
      function()
        Snacks.picker.autocmds()
      end,
      desc = "[F]ind [A]utocommands",
    },

    {
      "<leader>fC",
      function()
        Snacks.picker.commands()
      end,
      desc = "[F]ind [C]ommands",
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

        -- Toggle mappings
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

        -- Adaptive path shortening: keeps as many full segments as fit, shortens earlier ones
        local function shorten_path(path, max_len, separator)
          separator = separator or "/"
          local parts = vim.split(path, separator, { plain = true })

          -- If it already fits or has very few parts, return as-is
          if vim.api.nvim_strwidth(path) <= max_len or #parts <= 1 then
            return path
          end

          -- Start with all parts and work backwards, deciding what to keep full
          local result = {}
          local current_width = 0

          -- Always keep the last part (filename) full
          for i = #parts, 1, -1 do
            local part = parts[i]
            if part ~= "" then
              local full_width = vim.api.nvim_strwidth(part)
              local short_width = vim.api.nvim_strwidth(part:sub(1, 1))
              local sep_width = (i < #parts) and 1 or 0 -- Account for separator

              -- Try to fit the full segment
              if current_width + full_width + sep_width <= max_len then
                table.insert(result, 1, part)
                current_width = current_width + full_width + sep_width
              else
                -- Not enough space for full segment, use shortened version
                table.insert(result, 1, part:sub(1, 1))
                current_width = current_width + short_width + sep_width
              end
            end
          end

          return table.concat(result, separator)
        end

        -- Override snacks truncpath to use our custom shortening
        local truncpath_orig = Snacks.picker.util.truncpath
        Snacks.picker.util.truncpath = function(path, len, opts)
          -- First normalize the path using original function with a large length
          -- to prevent it from truncating
          local normalized = truncpath_orig(path, 9999, opts)

          -- Then apply our adaptive shortening
          local shortened = shorten_path(normalized, len)

          -- If somehow still too long, fall back to original
          if vim.api.nvim_strwidth(shortened) > len then
            return truncpath_orig(path, len, opts)
          end

          return shortened
        end

        -- Load project management functionality
        require("user.project")
      end,
    })
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
