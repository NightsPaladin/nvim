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
    "",
  },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
  end,
})

-- auto-close quickfix menu after selecting choice
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf" },
  callback = function()
    vim.cmd([[nnoremap <buffer> <CR> <CR>:cclose<CR>]])
  end,
})

local opts = { noremap = true, silent = true }
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "telekasten" },
  callback = function()
    vim.api.nvim_set_keymap("i", "[[", "<cmd>Telekasten insert_link<CR>", opts)
    vim.api.nvim_set_keymap("i", "<Leader>zt", "<cmd>Telekasten toggle_todo<CR>", opts)
    vim.api.nvim_set_keymap("i", "<Leader>#", "<cmd>Telekasten show_tags<CR>", opts)
    vim.cmd([[
        "hi tkLink ctermfg=Blue cterm=bold,underline guifg=blue gui=bold,underline   " just blue and gray links
        "hi tkBrackets ctermfg=gray guifg=gray
        hi tkLink ctermfg=72 guifg=#689d6a cterm=bold,underline gui=bold,underline    " for gruvbox
        hi tkBrackets ctermfg=gray guifg=gray
        "hi tkHighlight ctermbg=yellow ctermfg=darkred cterm=bold guibg=yellow guifg=darkred gui=bold    " real yellow
        hi tkHighlight ctermbg=214 ctermfg=124 cterm=bold guibg=#fabd2f guifg=#9d0006 gui=bold   " gruvbox
        hi link CalNavi CalRuler
        hi tkTagSep ctermfg=gray guifg=gray
        hi tkTag ctermfg=175 guifg=#d3869B
        ]])
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "help" },
  callback = function()
    vim.api.nvim_set_keymap("n", "<CR>", "<C-]>", opts)
    vim.api.nvim_set_keymap("n", "<BS>", "<C-T>", opts)
    vim.api.nvim_set_keymap("n", "o", "/'\\l\\{2,\\}'<CR>", opts)
    vim.api.nvim_set_keymap("n", "O", "?'\\l\\{2,\\}'<CR>", opts)
    vim.api.nvim_set_keymap("n", "s", "/\\|\\zs\\S\\+\\ze\\|<CR>", opts)
    vim.api.nvim_set_keymap("n", "S", "?\\|\\zs\\S\\+\\ze\\|<CR>", opts)
    vim.cmd([[ setlocal bufhidden=unload | wincmd L | vertical resize 80 ]])
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

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
