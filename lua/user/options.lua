-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
-- vim.o.mouse = 'a'
vim.opt.mouse = "ni" -- allow the mouse to be used in neovim

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

vim.opt.backup = false -- creates a backup file
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.swapfile = false -- creates a swapfile

vim.opt.cmdheight = 1 -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files

-- vim.opt.fileencoding = "utf-8" -- the encoding written to a file

vim.opt.hlsearch = true -- highlight all matches on previous search pattern
vim.opt.ignorecase = true -- ignore case in search patterns

vim.opt.pumheight = 10 -- pop up menu height
vim.opt.pumblend = 10

-- vim.opt.showtabline = 1 -- always show tabs

vim.opt.smartcase = true -- smart case
vim.opt.smartindent = true -- make indenting smarter again

vim.opt.termguicolors = true -- set term gui colors (most terminals support this)

vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2 -- insert 2 spaces for a tab

vim.opt.cursorline = true -- highlight the current line
vim.opt.cursorcolumn = true -- highlight current column

vim.opt.laststatus = 3
vim.opt.showcmd = false

vim.opt.ruler = false

vim.opt.numberwidth = 4 -- set number column width to 2 {default 4}

vim.opt.wrap = true -- display lines as one long line

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.sidescroll = 1

-- vim.opt.guifont = 'monospace:h17' -- the font used in graphical neovim applications
vim.opt.title = false

vim.opt.colorcolumn = "80"
-- vim.opt.colorcolumn = '120'

vim.opt.autoread = true

vim.opt.fillchars = vim.opt.fillchars + "eob: "
vim.opt.fillchars:append({
  stl = " ",
})

vim.opt.wildignore = { -- Automatically ignore the following file types
  ".git,.svn,CVS",
  "*.o,*.obj,*.a,*.class,*.mo,*.la,*.so",
  "*~,*.swp",
  "*.jpg,*.png,*.xpm,*.gif",
  "*.pyc",
  "tags,*.tags",
  "log/**",
  "tmp/**",
  "*DS_Store",
}

vim.opt.shortmess:append("c")
-- vim.opt.iskeyword:append("-") -- hyphenated words recognized by searches
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles") -- separate vim plugins from neovim in case vim still in use

-- Disable providers we do not care about
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

vim.cmd("set whichwrap+=<,>,[,],h,l")
-- vim.cmd [[set iskeyword+=-]]

vim.g.netrw_banner = 0
vim.g.netrw_mouse = 2

-- Open checkhealth in floating window
-- vim.g.health = { style = 'float' }

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
