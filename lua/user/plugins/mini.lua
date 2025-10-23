-- lua/user/plugins/mini.lua
-- Mini.nvim configuration
-- Provides: surround, pairs, comment, bufremove, indentscope, trailspace, ai
--
-- Where snacks.nvim and mini.nvim overlap, snacks.nvim takes precedence
-- Mini.nvim alternatives are commented out for you to try later

return {
  "echasnovski/mini.nvim",
  event = "VeryLazy",
  config = function()
    -- ==================== Active Mini Modules ====================

    -- Enhanced text objects (works great with treesitter)
    require("mini.ai").setup({ n_lines = 500 })

    -- Smart comments (handles tsx, vue, etc. via treesitter)
    require("mini.comment").setup({})

    -- Auto-pair brackets, quotes, etc.
    require("mini.pairs").setup({
      mappings = {
        ['"'] = {
          action = "closeopen",
          pair = '""',
          neigh_pattern = "[^%w\\][^%w]",
          register = { cr = false },
        },
        ["`"] = {
          action = "closeopen",
          pair = "``",
          neigh_pattern = "[^%w\\][^%w]",
          register = { cr = false },
        },
        -- Single quote already has left-side word detection,
        -- but you could make it bidirectional:
        ["'"] = {
          action = "closeopen",
          pair = "''",
          neigh_pattern = "[^%w\\][^%w]",
          register = { cr = false },
        },
      },
    })
    -- Disable backtick pairing in markdown files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        -- Disable backtick auto-pairing in markdown
        vim.keymap.set("i", "`", "`", { buffer = true })
      end,
    })

    -- Surround operations (replaces nvim-surround)
    -- gsa - add surround
    -- gsd - delete surround
    -- gsr - replace surround
    require("mini.surround").setup({
      mappings = {
        add = "gsa",
        delete = "gsd",
        replace = "gsr",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        update_n_lines = "gsn",
        suffix_last = "l",
        suffix_next = "n",
      },
    })

    -- File explorer: Using nvim-tree instead (mini.files had window sizing issues)
    -- See lua/user/plugins/nvimtree.lua for configuration

    -- Buffer removal (better than :bdelete)
    -- <leader>bd to delete buffer without closing window
    local bufremove = require("mini.bufremove")
    vim.keymap.set("n", "<leader>bd", function()
      bufremove.delete(0, false)
    end, { desc = "Delete buffer" })
    vim.keymap.set("n", "<leader>bD", function()
      bufremove.delete(0, true)
    end, { desc = "Force delete buffer" })

    -- Indent scope visualization (replaces indent-blankline)
    local indentscope = require("mini.indentscope")
    indentscope.setup({
      symbol = "│",
      draw = { animation = indentscope.gen_animation.none() },
    })
    -- Disable in special buffers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "help",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
      callback = function()
        vim.b.miniindentscope_disable = true
      end,
    })

    -- Trailing whitespace highlighting and removal
    -- <leader>cw to clean whitespace
    require("mini.trailspace").setup({})
    vim.keymap.set("n", "<leader>cw", function()
      require("mini.trailspace").trim()
    end, { desc = "[C]lean [W]hitespace" })

    -- ==================== Disabled: Using lualine instead ====================
    -- Uncomment if you want to use mini.statusline instead of lualine

    -- require("mini.statusline").setup({ use_icons = true })

    -- ==================== Commented Out: Snacks.nvim provides these ====================

    -- Alternative to snacks.bufdelete (currently using mini.bufremove above)
    -- Both work fine, choose one

    -- Alternative to snacks.terminal
    -- Uncomment if you prefer mini's terminal over snacks
    -- require('mini.misc').setup()
    -- vim.keymap.set('n', '<leader>tt', function()
    --   require('mini.misc').setup_termbg_sync()
    -- end, { desc = 'Terminal background sync' })

    -- Alternative to snacks.notify
    -- Uncomment if you prefer mini's notifications
    -- require('mini.notify').setup({
    --   window = {
    --     config = {
    --       border = 'rounded',
    --     },
    --   },
    -- })
    -- vim.notify = require('mini.notify').make_notify()

    -- Alternative to snacks.scratch
    -- Uncomment for mini's visit tracking and scratch buffers
    -- require('mini.visits').setup()
    -- require('mini.extra').setup() -- Provides pickers for visits
    -- vim.keymap.set('n', '<leader>vv', function()
    --   require('mini.extra').pickers.visit_paths()
    -- end, { desc = '[V]isit paths' })

    -- Alternative session management
    -- Uncomment if you want session management
    -- require('mini.sessions').setup({
    --   autoread = false,
    --   autowrite = true,
    --   directory = vim.fn.stdpath('data') .. '/sessions',
    -- })

    -- Alternative to snacks.zen (zoom/focus)
    -- Uncomment if you prefer mini's zoom
    -- require('mini.misc').setup()
    -- vim.keymap.set('n', '<leader>z', function()
    --   require('mini.misc').zoom()
    -- end, { desc = '[Z]oom window' })

    -- ==================== Additional Mini Modules You Might Want ====================

    -- Mini.move - Move lines and selections with Alt+hjkl
    -- Uncomment to enable
    -- require('mini.move').setup({
    --   mappings = {
    --     left = '<M-h>',
    --     right = '<M-l>',
    --     down = '<M-j>',
    --     up = '<M-k>',
    --     line_left = '<M-h>',
    --     line_right = '<M-l>',
    --     line_down = '<M-j>',
    --     line_up = '<M-k>',
    --   },
    -- })

    -- Mini.splitjoin - Split and join function arguments
    -- Uncomment to enable (gS to toggle)
    -- require('mini.splitjoin').setup()

    -- Mini.align - Align text (ga/gA operators)
    -- Uncomment to enable
    -- require('mini.align').setup()

    -- Mini.bracketed - Navigate through various text objects
    -- Uncomment to enable [b ]b for buffers, [d ]d for diagnostics, etc.
    -- require('mini.bracketed').setup({
    --   buffer = { suffix = 'b', options = {} },
    --   comment = { suffix = 'c', options = {} },
    --   conflict = { suffix = 'x', options = {} },
    --   diagnostic = { suffix = 'd', options = {} },
    --   file = { suffix = 'f', options = {} },
    --   indent = { suffix = 'i', options = {} },
    --   jump = { suffix = 'j', options = {} },
    --   location = { suffix = 'l', options = {} },
    --   oldfile = { suffix = 'o', options = {} },
    --   quickfix = { suffix = 'q', options = {} },
    --   treesitter = { suffix = 't', options = {} },
    --   undo = { suffix = 'u', options = {} },
    --   window = { suffix = 'w', options = {} },
    --   yank = { suffix = 'y', options = {} },
    -- })

    -- Mini.clue - Show keybindings in a popup (alternative to which-key)
    -- Uncomment to enable (currently using which-key)
    -- local miniclue = require('mini.clue')
    -- miniclue.setup({
    --   triggers = {
    --     { mode = 'n', keys = '<Leader>' },
    --     { mode = 'x', keys = '<Leader>' },
    --     { mode = 'n', keys = 'g' },
    --     { mode = 'x', keys = 'g' },
    --     { mode = 'n', keys = 'z' },
    --     { mode = 'x', keys = 'z' },
    --   },
    --   clues = {
    --     miniclue.gen_clues.builtin_completion(),
    --     miniclue.gen_clues.g(),
    --     miniclue.gen_clues.marks(),
    --     miniclue.gen_clues.registers(),
    --     miniclue.gen_clues.windows(),
    --     miniclue.gen_clues.z(),
    --   },
    -- })

    -- Mini.hipatterns - Highlight color codes and special patterns
    -- Uncomment if you want this instead of nvim-colorizer
    -- local hipatterns = require('mini.hipatterns')
    -- hipatterns.setup({
    --   highlighters = {
    --     hex_color = hipatterns.gen_highlighter.hex_color(),
    --     fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    --     hack = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
    --     todo = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
    --     note = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
    --   },
    -- })

    -- Mini.jump - Jump to single characters (f/F/t/T enhancements)
    -- Uncomment to enable
    -- require('mini.jump').setup()

    -- Mini.jump2d - Jump to any location with 2 characters
    -- Uncomment to enable (Enter to start jumping)
    -- require('mini.jump2d').setup({
    --   mappings = {
    --     start_jumping = '<CR>',
    --   },
    -- })

    -- Mini.pick - Alternative to Telescope (currently using Telescope)
    -- Uncomment if you want to try mini.pick
    -- require('mini.pick').setup()
    -- vim.keymap.set('n', '<leader>Pf', function()
    --   require('mini.pick').builtin.files()
    -- end, { desc = 'Pick: Files' })
    -- vim.keymap.set('n', '<leader>Pg', function()
    --   require('mini.pick').builtin.grep_live()
    -- end, { desc = 'Pick: Grep' })
    -- vim.keymap.set('n', '<leader>Pb', function()
    --   require('mini.pick').builtin.buffers()
    -- end, { desc = 'Pick: Buffers' })

    -- Mini.tabline - Alternative tabline
    -- Uncomment if you want a tabline
    -- require('mini.tabline').setup()

    -- Mini.map - Window with buffer text overview (minimap)
    -- Uncomment to enable
    -- require('mini.map').setup()
    -- vim.keymap.set('n', '<leader>mm', require('mini.map').toggle, { desc = 'Toggle Minimap' })

    -- Mini.animate - Smooth animations for cursor movement and scrolling
    -- Uncomment to enable (note: can be distracting for some users)
    -- require('mini.animate').setup()

    -- Mini.starter - Start screen (alternative to dashboard)
    -- Uncomment to enable
    -- require('mini.starter').setup()
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
