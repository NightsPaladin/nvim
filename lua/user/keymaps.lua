-- ============================================================================
-- Global Keymaps
-- ============================================================================
-- These are keybindings that don't belong to any specific plugin.
-- Plugin-specific keybindings should be defined in their respective plugin configs.
--
-- Conventions:
-- - <leader> is mapped to Space (see options.lua)
-- - Use descriptive 'desc' fields for which-key integration
-- - opts = { noremap = true, silent = true } prevents recursive mappings and suppresses output
--
-- See `:help keymap()` for more information

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ============================================================================
-- Leader Key Actions
-- ============================================================================

-- Quick save and quit
keymap("n", "<leader>w", "<cmd>w!<CR>", { desc = "Save" })
keymap("n", "<leader>q", "<cmd>confirm q<CR>", { desc = "Quit" })

-- ============================================================================
-- Search & Highlighting
-- ============================================================================

-- Clear search highlights with Esc (in addition to its normal behavior)
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Center screen after search jumps (keeps cursor in middle of screen)
keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "g*", "g*zz", opts)
keymap("n", "g#", "g#zz", opts)

-- ============================================================================
-- Diagnostics (LSP Errors/Warnings)
-- ============================================================================

-- Open diagnostics in quickfix list
keymap("n", "<leader>cq", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Jump to next/previous diagnostic with floating window
keymap("n", "<leader>cj", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Goto Next Diagnostic" })

keymap("n", "<leader>ck", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Goto Previous Diagnostic" })

-- ============================================================================
-- Window Navigation
-- ============================================================================
-- Use Ctrl+hjkl to move between splits
-- Works in Normal, Visual, and Terminal modes
--
-- Note: These also work in Telescope and completion menus for navigation
-- This is intentional - see discussion in config documentation

keymap({ "n", "v" }, "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap({ "n", "v" }, "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap({ "n", "v" }, "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap({ "n", "v" }, "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Terminal mode window navigation
-- Must exit terminal mode first, then switch windows
keymap("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Move to left window from terminal" })
keymap("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Move to lower window from terminal" })
keymap("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Move to upper window from terminal" })
keymap("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Move to right window from terminal" })

-- ============================================================================
-- Window Resizing
-- ============================================================================
-- Use Leader + Arrow keys to resize splits
-- Up/Down changes height, Left/Right changes width

keymap("n", "<leader><Up>", ":resize +5<CR>", { desc = "Increase window height", silent = true })
keymap("n", "<leader><Down>", ":resize -5<CR>", { desc = "Decrease window height", silent = true })
keymap("n", "<leader><Left>", ":vertical resize -5<CR>", { desc = "Decrease window width", silent = true })
keymap("n", "<leader><Right>", ":vertical resize +5<CR>", { desc = "Increase window width", silent = true })

-- NOTE: Window movement commands disabled (terminal compatibility issues)
-- If your terminal supports these, you can uncomment:
-- keymap("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- keymap("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- keymap("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the bottom" })
-- keymap("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the top" })

-- ============================================================================
-- Buffer Navigation
-- ============================================================================

-- Cycle through buffers with Shift+hl
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Close current buffer with Shift+q
keymap("n", "<S-q>", "<cmd>bdelete<CR>", opts)

-- Quick switch to alternate buffer (like Alt+Tab for files)
keymap("n", "<C-tab>", "<C-6>", opts)

-- ============================================================================
-- Text Movement & Manipulation
-- ============================================================================

-- Move lines up/down with Ctrl+Shift+jk
keymap("n", "<C-S-j>", "<Esc>:m .+1<CR>", opts)
keymap("n", "<C-S-k>", "<Esc>:m .-2<CR>", opts)

-- Stay in visual mode when indenting
-- Normally indenting exits visual mode - this keeps you in it
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Better paste in visual mode
-- Normally pasting in visual mode replaces the unnamed register
-- This keeps the original yanked text in the register
keymap("v", "p", '"_dP', opts)
keymap("x", "p", '"_dP', opts)

-- ============================================================================
-- Text Object Shortcuts
-- ============================================================================

-- Jump to beginning/end of line with Ctrl+Shift+hl
-- Works in Normal, Visual, and Operator-pending modes
keymap({ "n", "o", "x" }, "<C-S-h>", "^", opts) -- ^ = first non-blank character
keymap({ "n", "o", "x" }, "<C-S-l>", "g_", opts) -- g_ = last non-blank character

-- ============================================================================
-- Insert Mode Shortcuts
-- ============================================================================

-- Quick escape from insert mode
-- Type 'jk' quickly to exit insert mode (alternative to Esc)
keymap("i", "jk", "<ESC>", opts)

-- Alternative: Uncomment if you prefer 'kj' instead
-- keymap("i", "kj", "<ESC>", opts)

-- ============================================================================
-- Terminal Mode
-- ============================================================================

-- Exit terminal mode with double Esc
-- Standard way is <C-\><C-n> which is hard to remember
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Alternative terminal escape (using semicolon)
keymap("t", "<C-;>", "<C-\\><C-n>", opts)

-- ============================================================================
-- Mouse Integration
-- ============================================================================

-- Right-click context menu for LSP actions
-- Provides "Go to Definition" and "Find References" on right-click
vim.cmd([[:amenu 10.100 mousemenu.Goto\ Definition <cmd>lua vim.lsp.buf.definition()<CR>]])
vim.cmd([[:amenu 10.110 mousemenu.References <cmd>lua vim.lsp.buf.references()<CR>]])

keymap("n", "<RightMouse>", "<cmd>:popup mousemenu<CR>")
keymap("n", "<Tab>", "<cmd>:popup mousemenu<CR>")

-- ============================================================================
-- Plugin Toggles
-- ============================================================================

-- Toggle Markview (Markdown preview)
keymap("n", "<leader>tm", "<cmd>:Markview<CR>", { desc = "[T]oggle [M]arkview" })

-- NOTE: Other toggles are handled by Snacks.nvim (see snacks.lua)
-- - <leader>u* for UI toggles (line numbers, wrap, spelling, etc.)
-- - <leader>t* for functional toggles (diagnostics, treesitter, AI)

-- ============================================================================
-- Disabled/Alternative Keymaps
-- ============================================================================
-- These are commented out but provided as alternatives or learning aids

-- Force yourself to use hjkl instead of arrow keys (uncomment to enable)
-- keymap("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
-- keymap("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
-- keymap("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
-- keymap("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Soft wrap navigation (moves by visual line instead of actual line)
-- Useful for long lines or Tailwind classes
-- keymap({ "n", "x" }, "j", "gj", opts)
-- keymap({ "n", "x" }, "k", "gk", opts)

-- Toggle soft wrap on/off
-- keymap("n", "<leader>w", ":lua vim.wo.wrap = not vim.wo.wrap<CR>", opts)

-- ============================================================================
-- Organization Notes
-- ============================================================================
--
-- This file contains ONLY global keymaps that don't belong to specific plugins.
--
-- Plugin-specific keymaps are defined in their respective config files:
-- - LSP keymaps: lua/user/plugins/lsp.lua
-- - Telescope: lua/user/plugins/telescope.lua
-- - Git: lua/user/plugins/gitsigns.lua
-- - AI: lua/user/plugins/ai.lua
-- - Snacks toggles: lua/user/plugins/snacks.lua
-- - Telekasten: lua/user/autocommands.lua (buffer-local)
-- - NvimTree: lua/user/plugins/nvimtree.lua
--
-- This keeps related functionality together and makes the config easier to maintain.

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
