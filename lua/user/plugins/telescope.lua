-- Minimal Telescope.nvim configuration
-- Required by: Telekasten.nvim
-- Also provides: plenary.nvim for custom projects list (snacks.nvim picker)
return {
  "nvim-telescope/telescope.nvim",
  lazy = true,
  dependencies = {
    -- Required by Telescope; also used by Telekasten and custom projects list
    "nvim-lua/plenary.nvim",

    -- Optional but recommended: native FZF sorter for better performance
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
  },

  config = function()
    local actions = require("telescope.actions")

    require("telescope").setup({
      defaults = {
        -- Minimal defaults - you can customize these as needed
        prompt_prefix = "🔍 ",
        selection_caret = "➤ ",
        initial_mode = "insert",
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          width = 0.87,
          height = 0.80,
        },

        -- Telescope window mappings (retained as requested)
        mappings = {
          i = {
            -- Navigation
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,

            -- Selection
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            -- Preview scrolling
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            -- Results scrolling
            ["<C-b>"] = actions.results_scrolling_up,
            ["<C-f>"] = actions.results_scrolling_down,

            -- Multi-selection
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-S-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

            -- Close
            ["<C-c>"] = actions.close,
          },

          n = {
            -- Navigation
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,

            -- Selection
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            -- Preview scrolling
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            -- Results scrolling
            ["<C-b>"] = actions.results_scrolling_up,
            ["<C-f>"] = actions.results_scrolling_down,

            -- Multi-selection
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_previous,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-S-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

            -- Close
            ["<esc>"] = actions.close,
            ["q"] = actions.close,
          },
        },
      },
    })

    -- Load FZF extension if available
    pcall(require("telescope").load_extension, "fzf")

    -- ============================================================================
    -- Leader keybindings (commented out - uncomment if needed)
    -- ============================================================================
    -- local builtin = require("telescope.builtin")
    -- vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
    -- vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep" })
    -- vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
    -- vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
    -- vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume" })
  end,
}

-- vim: ts=2 sts=2 sw=2 et
