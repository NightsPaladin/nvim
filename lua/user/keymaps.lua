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
keymap("n", "n", "nzz", { desc = "Next search result (centered)" })
keymap("n", "N", "Nzz", { desc = "Prev search result (centered)" })
keymap("n", "*", "*zz", { desc = "Next word match (centered)" })
keymap("n", "#", "#zz", { desc = "Prev word match (centered)" })
keymap("n", "g*", "g*zz", { desc = "Next word match (centered)" })
keymap("n", "g#", "g#zz", { desc = "Prev word match (centered)" })

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
-- Smart resizing: arrows always expand/contract in their visual direction
-- regardless of which split has focus

--- Smart resize that moves the edge closest to the arrow direction
--- @param direction string "up", "down", "left", or "right"
--- @param amount number Number of lines/columns to resize (default: 5)
local function smart_resize(direction, amount)
  amount = amount or 5
  local win = vim.api.nvim_get_current_win()
  local wins = vim.api.nvim_tabpage_list_wins(0)

  if #wins <= 1 then
    return
  end

  local current_pos = vim.api.nvim_win_get_position(win)
  local current_row = current_pos[1]
  local current_col = current_pos[2]

  -- Determine if there are windows in each direction
  local has_win_above = false
  local has_win_below = false
  local has_win_left = false
  local has_win_right = false

  for _, other_win in ipairs(wins) do
    if other_win ~= win then
      local other_pos = vim.api.nvim_win_get_position(other_win)
      local other_row = other_pos[1]
      local other_col = other_pos[2]

      if other_row < current_row then
        has_win_above = true
      elseif other_row > current_row then
        has_win_below = true
      end

      if other_col < current_col then
        has_win_left = true
      elseif other_col > current_col then
        has_win_right = true
      end
    end
  end

  -- Apply smart resizing based on direction and window position
  -- Rule: Arrow keys always EXPAND the current window in that direction
  -- - If there's a window in that direction: grow (take space from neighbor)
  -- - If at the edge: shrink (pull away from edge)

  if direction == "up" then
    if has_win_above then
      vim.cmd("resize +" .. amount) -- Grow upward into the window above
    else
      vim.cmd("resize -" .. amount) -- At top edge, shrink to pull up from bottom
    end
  elseif direction == "down" then
    if has_win_below then
      vim.cmd("resize +" .. amount) -- Grow downward into the window below
    else
      vim.cmd("resize -" .. amount) -- At bottom edge, shrink to pull down from top
    end
  elseif direction == "left" then
    if has_win_left then
      vim.cmd("vertical resize +" .. amount) -- Grow leftward into the window on left
    else
      vim.cmd("vertical resize -" .. amount) -- At left edge, shrink to pull left from right
    end
  elseif direction == "right" then
    if has_win_right then
      vim.cmd("vertical resize +" .. amount) -- Grow rightward into the window on right
    else
      vim.cmd("vertical resize -" .. amount) -- At right edge, shrink to pull right from left
    end
  end
end

keymap("n", "<leader><Up>", function()
  smart_resize("up", 5)
end, { desc = "Expand window upward" })
keymap("n", "<leader><Down>", function()
  smart_resize("down", 5)
end, { desc = "Expand window downward" })
keymap("n", "<leader><Left>", function()
  smart_resize("left", 5)
end, { desc = "Expand window leftward" })
keymap("n", "<leader><Right>", function()
  smart_resize("right", 5)
end, { desc = "Expand window rightward" })

-- NOTE: Window movement commands disabled (terminal compatibility issues)
-- If your terminal supports these, you can uncomment:
-- keymap("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- keymap("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- keymap("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the bottom" })
-- keymap("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the top" })

-- ============================================================================
-- Window Resizing - Percentage Based
-- ============================================================================
-- Resize windows to specific percentages of available space
-- Auto-detect variants resize height/width based on split orientation
-- Explicit variants (uh*/uw*) force height or width resizing

--- Resize current window to percentage of available space
--- @param percent number Percentage of screen to resize to (30, 50, 70, 90)
--- @param dimension string|nil "height", "width", or "auto" (default: "auto")
local function resize_window_percent(percent, dimension)
  dimension = dimension or "auto"
  local win = vim.api.nvim_get_current_win()
  local wins = vim.api.nvim_tabpage_list_wins(0)

  -- Check if there are multiple windows
  if #wins <= 1 then
    return
  end

  -- Get current window position
  local current_pos = vim.api.nvim_win_get_position(win)
  local current_row = current_pos[1]
  local current_col = current_pos[2]

  -- Detect split orientation by checking neighbor positions
  local has_horizontal_split = false -- Has windows above or below
  local has_vertical_split = false -- Has windows left or right

  for _, other_win in ipairs(wins) do
    if other_win ~= win then
      local other_pos = vim.api.nvim_win_get_position(other_win)
      local other_row = other_pos[1]
      local other_col = other_pos[2]

      -- Check for horizontal split (different rows)
      if other_row ~= current_row then
        has_horizontal_split = true
      end

      -- Check for vertical split (different columns)
      if other_col ~= current_col then
        has_vertical_split = true
      end
    end
  end

  -- Apply resizing based on dimension parameter or auto-detect
  if dimension == "height" or (dimension == "auto" and has_horizontal_split) then
    local available_lines = vim.o.lines - vim.o.cmdheight - 2
    local target_height = math.floor(available_lines * percent / 100)
    vim.cmd("resize " .. target_height)
  end

  if dimension == "width" or (dimension == "auto" and has_vertical_split) then
    local target_width = math.floor(vim.o.columns * percent / 100)
    vim.cmd("vertical resize " .. target_width)
  end
end

-- Auto-detect resize (both height and width as needed)
keymap("n", "<leader>u3", function()
  resize_window_percent(30, "auto")
end, { desc = "Resize window to 30%" })
keymap("n", "<leader>u5", function()
  resize_window_percent(50, "auto")
end, { desc = "Resize window to 50%" })
keymap("n", "<leader>u7", function()
  resize_window_percent(70, "auto")
end, { desc = "Resize window to 70%" })
keymap("n", "<leader>u9", function()
  resize_window_percent(90, "auto")
end, { desc = "Resize window to 90%" })

-- Explicit height resize
keymap("n", "<leader>uh3", function()
  resize_window_percent(30, "height")
end, { desc = "Resize window height to 30%" })
keymap("n", "<leader>uh5", function()
  resize_window_percent(50, "height")
end, { desc = "Resize window height to 50%" })
keymap("n", "<leader>uh7", function()
  resize_window_percent(70, "height")
end, { desc = "Resize window height to 70%" })
keymap("n", "<leader>uh9", function()
  resize_window_percent(90, "height")
end, { desc = "Resize window height to 90%" })

-- Explicit width resize
keymap("n", "<leader>uw3", function()
  resize_window_percent(30, "width")
end, { desc = "Resize window width to 30%" })
keymap("n", "<leader>uw5", function()
  resize_window_percent(50, "width")
end, { desc = "Resize window width to 50%" })
keymap("n", "<leader>uw7", function()
  resize_window_percent(70, "width")
end, { desc = "Resize window width to 70%" })
keymap("n", "<leader>uw9", function()
  resize_window_percent(90, "width")
end, { desc = "Resize window width to 90%" })

-- ============================================================================
-- Buffer Navigation
-- ============================================================================

-- Cycle through buffers with Shift+hl
keymap("n", "<S-l>", "<cmd>bnext<CR>", opts)
keymap("n", "<S-h>", "<cmd>bprevious<CR>", opts)

-- Close current buffer with Shift+q
-- keymap("n", "<S-q>", "<cmd>bdelete<CR>", opts)

-- Quick switch to alternate buffer (like Alt+Tab for files)
keymap("n", "<leader><tab>", "<C-6>", { desc = "Alternate buffer" })

-- ============================================================================
-- Quickfix & Location List Toggle
-- ============================================================================

--- Toggle quickfix or location list
--- @param list_type string "quickfix" or "loclist"
local function toggle_list(list_type)
  local is_open = false

  for _, win in pairs(vim.fn.getwininfo()) do
    if win["quickfix"] == 1 then
      if list_type == "loclist" and win["loclist"] == 1 then
        is_open = true
        break
      elseif list_type == "quickfix" and win["loclist"] == 0 then
        is_open = true
        break
      end
    end
  end

  if is_open then
    vim.cmd(list_type == "quickfix" and "cclose" or "lclose")
  else
    local has_items = list_type == "quickfix" and not vim.tbl_isempty(vim.fn.getqflist())
      or not vim.tbl_isempty(vim.fn.getloclist(0))

    if has_items then
      -- Use botright to force opening at the very bottom, spanning full width
      if list_type == "quickfix" then
        vim.cmd("botright copen")
      else
        vim.cmd("botright lopen")
      end
    else
      local name = list_type == "quickfix" and "Quickfix" or "Location"
      vim.notify(name .. " list is empty", vim.log.levels.INFO)
    end
  end
end

keymap("n", "<leader>tq", function()
  toggle_list("quickfix")
end, { desc = "[T]oggle [Q]uickfix list" })
keymap("n", "<leader>tl", function()
  toggle_list("loclist")
end, { desc = "[T]oggle [L]ocation list" })

-- ============================================================================
-- Text Movement & Manipulation
-- ============================================================================

-- Does not currently work. Ctrl+Shift+k is used by the terminal
-- Move lines up/down with Ctrl+Shift+jk
-- TODO: Update to use a keybinding that will allow easy move of lines
--
-- keymap("n", "<C-S-j>", "<Esc>:m .+1<CR>", opts)
-- keymap("n", "<C-S-k>", "<Esc>:m .-2<CR>", opts)

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
-- NOTE: Tab keymap commented out to avoid conflicts with completion/snippets
-- Uncomment if you want Tab to also open the mouse menu
-- keymap("n", "<Tab>", "<cmd>:popup mousemenu<CR>")

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
