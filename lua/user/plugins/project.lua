return {
  "ahmedkhalf/project.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },

  config = function()
    require("project_nvim").setup({
      manual_mode = true,
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "pom.xml" },
      ignore_lsp = { "terraform_ls" },
      exclude_dirs = {},
      show_hidden = false,
      silent_chdir = true,
      scope_chdir = "global",
    })

    vim.keymap.set("n", "<leader>fp", require("telescope").extensions.projects.projects, { desc = "[F]ind [P]roject" })
  end,
}
