-- You can easily change to a different colorscheme.
-- Change the name of the colorscheme plugin below, and then
-- change the command in the config to whatever the name of that colorscheme is.
--
-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
local colorscheme = 'base16-gruvbox-dark-pale'

local M = {
  {
    'LunarVim/darkplus.nvim',
    name = 'darkplus',
    priority = 1000, -- Make sure to load this before all the other start plugins.
  },

  {
    'sjl/badwolf',
    name = 'badwolf',
    priority = 1000, -- Make sure to load this before all the other start plugins.
  },

  {
    'RRethy/nvim-base16',
    name = 'base16',
    priority = 1000, -- Make sure to load this before all the other start plugins.
  },

  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
  },
  {
    'ellisonleao/gruvbox.nvim',
    name = 'gruvbox',
    priority = 1000, -- Make sure to load this before all the other start plugins.
  },
  {
    'folke/tokyonight.nvim',
    name = 'tokyonight',
    priority = 1000, -- Make sure to load this before all the other start plugins.
  },
}

for _, v in pairs(M) do
  if string.find(colorscheme, v.name, 1, true) then
    v.config = function()
      if v.name == 'tokyonight' then
        ---@diagnostic disable-next-line: missing-fields
        require('tokyonight').setup {
          styles = {
            comments = { italic = false }, -- Disable italics in comments
          },
        }
      end
      if v.name == 'gruvbox' then
        ---@diagnostic disable-next-line: missing-fields
        require('gruvbox').setup {
          contrast = 'hard',
          italic = {
            strings = false,
            comments = false,
            folds = true,
            emphasis = true,
            operators = false,
          },
        }
      end

      vim.cmd.colorscheme(colorscheme)
      vim.o.background = 'dark'
    end
  end
end

return M
