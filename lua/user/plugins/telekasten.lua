return {
  "renerocksai/telekasten.nvim",
  dependencies = {
    "renerocksai/calendar-vim",
  },
  event = {
    "VeryLazy",
  },
  config = function()
    local wk = require("which-key")
    wk.add({
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
    })

    local home = vim.fn.expand("~/work/wiki")
    -- NOTE for Windows users:
    -- - don't use Windows
    -- - try WSL2 on Windows and pretend you're on Linux
    -- - if you **must** use Windows, use "/Users/myname/zettelkasten" instead of "~/zettelkasten"
    -- - NEVER use "C:\Users\myname" style paths
    require("telekasten").setup({
      home = home,

      -- if true, telekasten will be enabled when opening a note within the configured home
      take_over_my_home = true,

      -- auto-set telekasten filetype: if false, the telekasten filetype will not be used
      --                               and thus the telekasten syntax will not be loaded either
      auto_set_filetype = true,

      -- dir names for special notes (absolute path or subdir name)
      dailies = home .. "/" .. "daily",
      weeklies = home .. "/" .. "weekly",
      templates = home .. "/" .. "templates",

      -- image (sub)dir for pasting
      -- dir name (absolute path or subdir name)
      -- or nil if pasted images shouldn't go into a special subdir
      image_subdir = "img",

      -- markdown file extension
      extension = ".md",

      -- following a link to a non-existing note will create it
      follow_creates_nonexisting = true,
      dailies_create_nonexisting = true,
      weeklies_create_nonexisting = true,

      -- template for new notes (new_note, follow_link)
      -- set to `nil` or do not specify if you do not want a template
      template_new_note = home .. "/" .. "templates/new_note.md",

      -- template for newly created daily notes (goto_today)
      -- set to `nil` or do not specify if you do not want a template
      template_new_daily = home .. "/" .. "templates/daily.md",

      -- template for newly created weekly notes (goto_thisweek)
      -- set to `nil` or do not specify if you do not want a template
      template_new_weekly = home .. "/" .. "templates/weekly.md",

      -- image link style
      -- wiki:     ![[image name]]
      -- markdown: ![](image_subdir/xxxxx.png)
      image_link_style = "markdown",

      -- integrate with calendar-vim
      plug_into_calendar = true,
      calendar_opts = {
        -- calendar week display mode: 1 .. 'WK01', 2 .. 'WK 1', 3 .. 'KW01', 4 .. 'KW 1', 5 .. '1'
        weeknm = 4,
        -- use monday as first day of week: 1 .. true, 0 .. false
        calendar_monday = 1,
        -- calendar mark: where to put mark for marked days: 'left', 'right', 'left-fit'
        calendar_mark = "left-fit",
      },

      -- telescope actions behavior
      close_after_yanking = false,
      insert_after_inserting = true,

      -- tag notation: '#tag', ':tag:', 'yaml-bare'
      tag_notation = "#tag",

      -- command palette theme: dropdown (window) or ivy (bottom panel)
      command_palette_theme = "ivy",

      -- tag list theme:
      -- get_cursor: small tag list at cursor; ivy and dropdown like above
      show_tags_theme = "ivy",

      -- when linking to a note in subdir/, create a [[subdir/title]] link
      -- instead of a [[title only]] link
      subdirs_in_links = true,

      -- template_handling
      -- What to do when creating a new note via `new_note()` or `follow_link()`
      -- to a non-existing note
      -- - prefer_new_note: use `new_note` template
      -- - smart: if day or week is detected in title, use daily / weekly templates (default)
      -- - always_ask: always ask before creating a note
      template_handling = "smart",

      -- path handling:
      --   this applies to:
      --     - new_note()
      --     - new_templated_note()
      --     - follow_link() to non-existing note
      --
      --   it does NOT apply to:
      --     - goto_today()
      --     - goto_thisweek()
      --
      --   Valid options:
      --     - smart: put daily-looking notes in daily, weekly-looking ones in weekly,
      --              all other ones in home, except for notes/with/subdirs/in/title.
      --              (default)
      --
      --     - prefer_home: put all notes in home except for goto_today(), goto_thisweek()
      --                    except for notes with subdirs/in/title.
      --
      --     - same_as_current: put all new notes in the dir of the current note if
      --                        present or else in home
      --                        except for notes/with/subdirs/in/title.
      new_note_location = "smart",

      -- should all links be updated when a file is renamed
      rename_update_links = true,

      -- how to preview media files
      -- "telescope-media-files" if you have telescope-media-files.nvim installed
      -- "catimg-previewer" if you have catimg installed
      media_previewer = "catimg-previewer",
    })
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
