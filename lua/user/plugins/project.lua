return {
  "ahmedkhalf/project.nvim",
  opts = {
    manual_mode = true, -- Don't auto-detect, only change on command
    detection_methods = { "pattern" },
    patterns = { ".git", "Makefile", "package.json", "go.mod", "Cargo.toml" },

    -- Don't automatically change directory
    silent_chdir = false,

    -- Show a message when changing project
    show_hidden = false,
  },

  keys = {
    { "<leader>pr", "<cmd>ProjectRoot<cr>", desc = "Go to [P]roject [R]oot" },
    -- Optional: if you use telescope, uncomment this for project picker
    { "<leader>pp", "<cmd>Telescope projects<cr>", desc = "[P]ick [P]roject" },
  },

  config = function(_, opts)
    require("project_nvim").setup(opts)

    -- Optional: integrate with telescope if available
    pcall(function()
      require("telescope").load_extension("projects")
    end)
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
