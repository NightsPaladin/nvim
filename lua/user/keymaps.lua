-- [[ Basic Keymaps ]]
--  See `:help keymap()`

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- write buffer to file
keymap("n", "<leader>w", "<cmd>w!<CR>", { desc = "Save" })
-- quit window
keymap("n", "<leader>qq", "<cmd>confirm q<CR>", { desc = "Quit" })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
keymap("n", "<leader>qf", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
keymap("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- keymap('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- keymap('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- keymap('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- keymap('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
keymap("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
keymap("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
keymap("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
keymap("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- keymap("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- keymap("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- keymap("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- keymap("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

keymap("n", "<C-tab>", "<C-6>", opts)

keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)
keymap("n", "*", "*zz", opts)
keymap("n", "#", "#zz", opts)
keymap("n", "g*", "g*zz", opts)
keymap("n", "g#", "g#zz", opts)

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

vim.cmd([[:amenu 10.100 mousemenu.Goto\ Definition <cmd>lua vim.lsp.buf.definition()<CR>]])
vim.cmd([[:amenu 10.110 mousemenu.References <cmd>lua vim.lsp.buf.references()<CR>]])
-- vim.cmd [[:amenu 10.120 mousemenu.-sep- *]]

keymap("n", "<RightMouse>", "<cmd>:popup mousemenu<CR>")
keymap("n", "<Tab>", "<cmd>:popup mousemenu<CR>")

-- more good
keymap({ "n", "o", "x" }, "<C-S-h>", "^", opts)
keymap({ "n", "o", "x" }, "<C-S-l>", "g_", opts)

-- tailwind bearable to work with
-- keymap({ 'n', 'x' }, 'j', 'gj', opts)
-- keymap({ 'n', 'x' }, 'k', 'gk', opts)
-- keymap('n', '<leader>w', ':lua vim.wo.wrap = not vim.wo.wrap<CR>', opts)

-- Resize with arrows
keymap("n", "<Leader><Up>", ":resize +5<CR>", opts)
keymap("n", "<Leader><Down>", ":resize -5<CR>", opts)
keymap("n", "<Leader><Left>", ":vertical resize -5<CR>", opts)
keymap("n", "<Leader><Right>", ":vertical resize +5<CR>", opts)

-- Move text up and down (removed '==gi' don't need or want insert after)
keymap("n", "<C-S-j>", "<Esc>:m .+1<CR>", opts)
keymap("n", "<C-S-k>", "<Esc>:m .-2<CR>", opts)

-- Press jk fast to exit insert mode
keymap("i", "jk", "<ESC>", opts)
-- keymap("i", "kj", "<ESC>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>bdelete<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)
keymap("x", "p", '"_dP', opts)

-- Terminal related?
keymap("t", "<C-;>", "<C-\\><C-n>", opts)

-- Toggle line/relative numbers
keymap("n", "<leader>0r", function()
  vim.o.relativenumber = not vim.o.relativenumber
end, { desc = "Toggle Relative Line Numbers" })
keymap("n", "<leader>0n", function()
  vim.o.number = not vim.o.number
end, { desc = "Toggle Line Numbers" })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
