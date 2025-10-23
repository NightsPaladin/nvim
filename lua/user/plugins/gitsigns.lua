return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile" },

  keys = {
    -- { "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", desc = "Next Hunk" },
    -- { "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", desc = "Prev Hunk" },
    -- { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk" },
    -- { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },
    { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame" },
    -- { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
    -- { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk" },
    -- { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk" },
    { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Git Diff" },
    -- { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file" },
    -- { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
    -- { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit" },
  },

  opts = function()
    local icons = require("user.icons")
    return {
      signs = {
        add = { text = icons.ui.BoldLineMiddle },
        change = { text = icons.ui.BoldLineDashedMiddle },
        delete = { text = icons.ui.TriangleShortArrowRight },
        topdelete = { text = icons.ui.TriangleShortArrowRight },
        changedelete = { text = icons.ui.BoldLineMiddle },
      },
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      update_debounce = 200,
      max_file_length = 40000,
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    }
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
