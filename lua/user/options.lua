-- ============================================================================
-- Leader Keys (Must be set before plugins load)
-- ============================================================================
-- See `:help mapleader`
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- Global Settings
-- ============================================================================
vim.g.have_nerd_font = true -- Set to true if you have a Nerd Font installed

-- Disable providers we do not care about
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Netrw settings
vim.g.netrw_banner = 0
vim.g.netrw_mouse = 2

-- ============================================================================
-- UI Appearance
-- ============================================================================
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.cursorline = true -- Highlight current line
vim.opt.cursorcolumn = true -- Highlight current column
vim.opt.colorcolumn = "80" -- Show column guide at 80 characters
vim.opt.showmode = false -- Don't show mode (shown in statusline)
vim.opt.showcmd = false -- Don't show command in statusline
vim.opt.ruler = false -- Don't show ruler (using statusline)
vim.opt.laststatus = 3 -- Global statusline
vim.opt.numberwidth = 4 -- Width of number column

-- Show whitespace characters
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Fillchars for better UI
vim.opt.fillchars = vim.opt.fillchars + "eob: "
vim.opt.fillchars:append({ stl = " " })

vim.opt.termguicolors = true -- Enable 24-bit RGB colors

-- ============================================================================
-- Editor Behavior
-- ============================================================================
vim.opt.mouse = "ni" -- Enable mouse in normal and insert mode
vim.opt.wrap = true -- Wrap long lines
vim.opt.breakindent = true -- Preserve indentation in wrapped lines
vim.opt.scrolloff = 10 -- Keep 10 lines above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
vim.opt.sidescroll = 1 -- Smooth horizontal scrolling

-- Command line
vim.opt.cmdheight = 1 -- Height of command line
vim.opt.inccommand = "split" -- Preview substitutions live

-- Better vim behavior
vim.cmd("set whichwrap+=<,>,[,],h,l") -- Allow cursor to wrap between lines

-- ============================================================================
-- Search Settings
-- ============================================================================
vim.opt.hlsearch = true -- Highlight search matches
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Case-sensitive if search contains capitals

-- ============================================================================
-- Indentation
-- ============================================================================
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.tabstop = 2 -- Number of spaces for a tab
vim.opt.shiftwidth = 2 -- Number of spaces for indentation
vim.opt.smartindent = true -- Smart autoindenting

-- ============================================================================
-- Completion
-- ============================================================================
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- Completion options
vim.opt.pumheight = 10 -- Max height of popup menu
vim.opt.pumblend = 10 -- Transparency of popup menu

-- ============================================================================
-- File Handling
-- ============================================================================
vim.opt.undofile = true -- Persistent undo
vim.opt.backup = false -- No backup file
vim.opt.writebackup = false -- No backup while editing
vim.opt.swapfile = false -- No swap file
vim.opt.autoread = true -- Auto-reload files changed outside vim
vim.opt.confirm = true -- Ask for confirmation instead of erroring

-- ============================================================================
-- Window Splitting
-- ============================================================================
vim.opt.splitright = true -- Vertical splits go right
vim.opt.splitbelow = true -- Horizontal splits go below

-- ============================================================================
-- Timing
-- ============================================================================
vim.opt.updatetime = 250 -- Faster completion and swap file writing
vim.opt.timeoutlen = 250 -- Time to wait for mapped sequence

-- ============================================================================
-- Clipboard
-- ============================================================================
-- Sync clipboard between OS and Neovim
-- Schedule after UiEnter to prevent startup slowdown
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- ============================================================================
-- Wildmenu / File Ignore
-- ============================================================================
vim.opt.wildignore = {
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

-- ============================================================================
-- Miscellaneous
-- ============================================================================
vim.opt.conceallevel = 0 -- Don't conceal characters (useful for markdown)
vim.opt.shortmess:append("c") -- Don't show completion messages
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles") -- Separate vim/nvim plugins

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
