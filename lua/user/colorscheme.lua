-- You can easily change to a different colorscheme.
-- Change the name of the colorscheme plugin below, and then
-- change the command in the config to whatever the name of that colorscheme is.
--
-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
-- local colorscheme = "base16-gruvbox-dark-pale"
local colorscheme = "base16-horizon-dark"

local M = {
  -- Only your active colorscheme loads at startup
  {
    "RRethy/nvim-base16",
    name = "base16",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme(colorscheme)
      vim.o.background = "dark"
    end,
  },

  -- All alternatives lazy load
  {
    "ellisonleao/gruvbox.nvim",
    name = "gruvbox",
    lazy = true,
    priority = 1000,
    opts = {
      contrast = "hard",
      italic = {
        strings = false,
        comments = false,
        folds = true,
        emphasis = true,
        operators = false,
      },
    },
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = true,
    priority = 1000,
    opts = {
      styles = {
        comments = { italic = false },
      },
    },
  },
  {
    "sjl/badwolf",
    name = "badwolf",
    lazy = true,
    priority = 1000,
  },
  {
    "LunarVim/darkplus.nvim",
    name = "darkplus",
    lazy = true,
    priority = 1000,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
  },
}

return M

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
