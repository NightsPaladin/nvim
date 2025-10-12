-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.cmd("set formatoptions-=cro")
    vim.cmd("set formatoptions+=j")
  end,
})

-- quit these types of buffers with 'q'
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "netrw",
    "Jaq",
    "git",
    "help",
    "man",
    "lspinfo",
    "oil",
    "spectre_panel",
    "lir",
    "DressingSelect",
    "tsplayground",
    "checkhealth",
    "qf",
    "",
  },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
  end,
})

local opts = { noremap = true, silent = true }

-- ============================================================================
-- Auto-close Quickfix after selection
-- ============================================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(event)
    local bufnr = event.buf

    -- Determine if this is quickfix or location list
    local is_loclist = vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0

    -- <CR> - Jump to item and close the list
    vim.keymap.set("n", "<CR>", function()
      local line = vim.fn.line(".")
      vim.cmd("normal! " .. line .. "G")
      vim.cmd(".cc") -- Jump to the item

      -- Close the appropriate list
      if is_loclist then
        vim.cmd("lclose")
      else
        vim.cmd("cclose")
      end
    end, { buffer = bufnr, desc = "Jump to item and close" })

    -- 'o' - Open in horizontal split (keeps quickfix open)
    vim.keymap.set("n", "o", function()
      local line = vim.fn.line(".")
      vim.cmd("normal! " .. line .. "G")
      vim.cmd(".cc")
      vim.cmd("wincmd p") -- Go back to previous window
      vim.cmd("split") -- Create horizontal split
      vim.cmd(".cc") -- Jump to the item in the split
    end, { buffer = bufnr, desc = "Open in split (keep list open)" })

    -- 'v' - Open in vertical split (keeps quickfix open)
    vim.keymap.set("n", "v", function()
      local line = vim.fn.line(".")
      vim.cmd("normal! " .. line .. "G")
      vim.cmd(".cc")
      vim.cmd("wincmd p")
      vim.cmd("vsplit")
      vim.cmd(".cc")
    end, { buffer = bufnr, desc = "Open in vertical split (keep list open)" })

    -- Note: 'q' to close is handled by the main "quit these types of buffers" autocommand
    -- No need to duplicate it here
  end,
})

-- ============================================================================
-- Telekasten: Add features to markdown files in wiki directory
-- ============================================================================
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*/wiki/*.md", "*/wiki/**/*.md" },
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()

    -- Insert mode keymaps
    vim.keymap.set(
      "i",
      "[[",
      "<cmd>Telekasten insert_link<CR>",
      { buffer = bufnr, noremap = true, silent = true, desc = "Insert Telekasten link" }
    )
    vim.keymap.set(
      "i",
      "<leader>zt",
      "<cmd>Telekasten toggle_todo<CR>",
      { buffer = bufnr, noremap = true, silent = true, desc = "Toggle todo (insert)" }
    )
    vim.keymap.set(
      "i",
      "<leader>#",
      "<cmd>Telekasten show_tags<CR>",
      { buffer = bufnr, noremap = true, silent = true, desc = "Show tags" }
    )

    -- Normal mode keymaps (buffer-local, only in wiki files)

    -- Follow link under cursor
    vim.keymap.set(
      "n",
      "gf",
      "<cmd>Telekasten follow_link<CR>",
      { buffer = bufnr, noremap = true, silent = true, desc = "Follow Telekasten link" }
    )

    -- Go back after following a link
    vim.keymap.set(
      "n",
      "gb",
      "<C-o>",
      { buffer = bufnr, noremap = true, silent = true, desc = "Go back to previous note" }
    )

    -- Toggle todo checkbox under cursor (normal mode)
    vim.keymap.set(
      "n",
      "<leader>zt",
      "<cmd>Telekasten toggle_todo<CR>",
      { buffer = bufnr, noremap = true, silent = true, desc = "Toggle todo" }
    )

    -- Insert image link
    vim.keymap.set(
      "n",
      "<leader>zi",
      "<cmd>Telekasten insert_img_link<CR>",
      { buffer = bufnr, noremap = true, silent = true, desc = "Insert image link" }
    )

    -- Yank link to current note
    vim.keymap.set(
      "n",
      "<leader>zy",
      "<cmd>Telekasten yank_notelink<CR>",
      { buffer = bufnr, noremap = true, silent = true, desc = "Yank note link" }
    )

    -- Rename current note (updates all links)
    vim.keymap.set(
      "n",
      "<leader>zr",
      "<cmd>Telekasten rename_note<CR>",
      { buffer = bufnr, noremap = true, silent = true, desc = "Rename note" }
    )

    -- Telekasten syntax highlighting
    vim.cmd([[
        hi tkLink ctermfg=72 guifg=#689d6a cterm=bold,underline gui=bold,underline
        hi tkBrackets ctermfg=gray guifg=gray
        hi tkHighlight ctermbg=214 ctermfg=124 cterm=bold guibg=#fabd2f guifg=#9d0006 gui=bold
        hi link CalNavi CalRuler
        hi tkTagSep ctermfg=gray guifg=gray
        hi tkTag ctermfg=175 guifg=#d3869B
    ]])
  end,
})

-- ============================================================================
-- Help Window Configuration
-- ============================================================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "help",
  callback = function(event)
    local bufnr = event.buf
    local winid = vim.api.nvim_get_current_win()

    -- Navigation keymaps
    vim.keymap.set("n", "<CR>", "<C-]>", { buffer = bufnr, desc = "Jump to tag" })
    vim.keymap.set("n", "<BS>", "<C-T>", { buffer = bufnr, desc = "Jump back" })
    vim.keymap.set("n", "o", "/'\\l\\{2,\\}'<CR>", { buffer = bufnr, desc = "Next option" })
    vim.keymap.set("n", "O", "?'\\l\\{2,\\}'<CR>", { buffer = bufnr, desc = "Previous option" })
    vim.keymap.set("n", "s", "/\\|\\zs\\S\\+\\ze\\|<CR>", { buffer = bufnr, desc = "Next subject" })
    vim.keymap.set("n", "S", "?\\|\\zs\\S\\+\\ze\\|<CR>", { buffer = bufnr, desc = "Previous subject" })

    -- Note: 'q' to close is handled by the main "quit these types of buffers" autocommand
    -- No need to duplicate it here

    -- Window configuration
    vim.bo[bufnr].bufhidden = "unload"

    -- Explicitly disable line numbers
    vim.wo[winid].number = false
    vim.wo[winid].relativenumber = false
    vim.wo[winid].signcolumn = "no"

    -- Schedule the window positioning to ensure it happens after the window is created
    vim.schedule(function()
      -- Move to the far right
      vim.cmd("wincmd L")

      -- Set width to exactly 80 (since we disabled line numbers and signs)
      vim.api.nvim_win_set_width(winid, 80)

      -- Optional: Set a minimum width so it doesn't get squished
      vim.wo[winid].winminwidth = 80
    end)
  end,
})

-- Create an autocmd group to avoid duplicate commands
vim.api.nvim_create_augroup("FileTypeConfig", { clear = true })

-- Define an autocmd for setting the filetype based on file extensions
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.zshrc",
  callback = function()
    vim.bo.filetype = "zsh"
  end,
  group = "FileTypeConfig",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.bashrc",
  callback = function()
    vim.bo.filetype = "bash"
  end,
  group = "FileTypeConfig",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.shrc",
  callback = function()
    vim.bo.filetype = "sh"
  end,
  group = "FileTypeConfig",
})

-- Highlight the border of the active window
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  callback = function()
    vim.opt_local.winhighlight = "Normal:Normal,NormalNC:NormalNC"
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  callback = function()
    vim.opt_local.winhighlight = "Normal:NormalNC,NormalNC:NormalNC"
  end,
})
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
