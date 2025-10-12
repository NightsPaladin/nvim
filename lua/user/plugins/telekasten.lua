return {
  "renerocksai/telekasten.nvim",
  dependencies = {
    "renerocksai/calendar-vim",
  },
  event = "VeryLazy",

  -- ============================================================================
  -- Keybindings (extracted from config)
  -- ============================================================================
  keys = {
    { "<leader>zz", "<cmd>Telekasten panel<CR>", desc = "Telekasten Panel" },
    { "<leader>zn", "<cmd>Telekasten new_note<CR>", desc = "New Note" },
    { "<leader>zN", "<cmd>Telekasten new_templated_note<CR>", desc = "New Templated Note" },
    { "<leader>zc", "<cmd>Telekasten show_calendar<CR>", desc = "Show Calendar" },
    { "<leader>zC", "<cmd>CalendarT<CR>", desc = "Show Calendar (Fullscreen)" },
    { "<leader>zf", "<cmd>Telekasten find_notes<CR>", desc = "Find Notes" },
    { "<leader>zd", "<cmd>Telekasten find_daily_notes<CR>", desc = "Find Daily Notes" },
    { "<leader>zg", "<cmd>Telekasten search_notes<CR>", desc = "Search Notes" },
    { "<leader>zl", "<cmd>Telekasten follow_link<CR>", desc = "Follow Link" },
    { "<leader>zT", "<cmd>Telekasten goto_today<CR>", desc = "Goto Today" },
    { "<leader>zW", "<cmd>Telekasten goto_thisweek<CR>", desc = "Goto This Week" },
    { "<leader>zw", "<cmd>Telekasten find_weekly_notes<CR>", desc = "Find Weekly Note" },
    { "<leader>zt", "<cmd>Telekasten toggle_todo<CR>", desc = "Add Todo Item" },
    { "<leader>za", "<cmd>Telekasten show_tags<CR>", desc = "Show Tags" },
    { "<leader>zb", "<cmd>Telekasten show_backlinks<CR>", desc = "Show Backlinks" },
    { "<leader>zm", "<cmd>Telekasten browse_media<CR>", desc = "Browse Media" },
    { "<leader>zp", "<cmd>Telekasten preview_image<CR>", desc = "Preview Image" },
    { "<leader>zI", "<cmd>Telekasten insert_img_link({ i = true })<CR>", desc = "Insert Image Link" },
  },

  -- ============================================================================
  -- Plugin Options (auto-calls setup with these options)
  -- ============================================================================
  opts = function()
    local home = vim.fn.expand("~/work/wiki")

    return {
      home = home,

      -- Enable telekasten when opening a note within the configured home
      take_over_my_home = true,

      -- CHANGED: Let files stay as markdown (don't override filetype)
      auto_set_filetype = false,

      -- Directory structure
      dailies = home .. "/daily",
      weeklies = home .. "/weekly",
      templates = home .. "/templates",
      image_subdir = "img",

      -- File settings
      extension = ".md",

      -- Note creation behavior
      follow_creates_nonexisting = true,
      dailies_create_nonexisting = true,
      weeklies_create_nonexisting = true,

      -- Templates for new notes
      template_new_note = home .. "/templates/new_note.md",
      template_new_daily = home .. "/templates/daily.md",
      template_new_weekly = home .. "/templates/weekly.md",

      -- Image link style: markdown format instead of wiki format
      image_link_style = "markdown",

      -- Calendar integration
      plug_into_calendar = true,
      calendar_opts = {
        weeknm = 4, -- Week display: 'KW 1'
        calendar_monday = 1, -- Monday as first day
        calendar_mark = "left-fit",
      },

      -- Telescope behavior
      close_after_yanking = false,
      insert_after_inserting = true,

      -- Tag notation: #tag format
      tag_notation = "#tag",

      -- UI themes
      command_palette_theme = "ivy",
      show_tags_theme = "ivy",

      -- Link behavior
      subdirs_in_links = true,

      -- Template handling: smart detection of daily/weekly notes
      template_handling = "smart",

      -- Path handling: smart placement based on note type
      new_note_location = "smart",

      -- Update links when renaming files
      rename_update_links = true,

      -- Media preview
      media_previewer = "catimg-previewer",
    }
  end,
}

-- ============================================================================
-- Benefits of This Refactor:
-- ============================================================================
--
-- ✅ Cleaner separation of concerns:
--    - keys = {} for keybindings
--    - opts = {} for plugin configuration
--
-- ✅ No manual which-key.add() call needed:
--    - lazy.nvim handles keybinding registration
--    - Descriptions show up in which-key automatically
--
-- ✅ No manual setup() call needed:
--    - lazy.nvim automatically calls require("telekasten").setup(opts)
--
-- ✅ opts = function() allows dynamic home path:
--    - Computes home once
--    - Uses it throughout the config
--
-- ✅ Easier to read and maintain:
--    - All keybindings in one place
--    - All options in one place
--    - No nested function logic
--
-- ✅ Better lazy-loading:
--    - Keys can trigger plugin loading
--    - event = "VeryLazy" ensures it doesn't slow startup

-- vim: ts=2 sts=2 sw=2 et
