return {
  "NvChad/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    filetypes = {
      "*", -- Enable for all filetypes
      -- But exclude some where it makes no sense:
      "!lazy",
      "!mason",
      "!help",
      "!checkhealth",
    },
    user_default_options = {
      names = false, -- Don't highlight color names like "red", "blue" (can be noisy)
      RGB = true, -- #RGB hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      rgb_fn = true, -- CSS rgb() and rgba() functions
      hsl_fn = true, -- CSS hsl() and hsla() functions
      css = false, -- Don't enable all CSS features (too broad)
      css_fn = false, -- Don't enable all CSS function formats
      mode = "background", -- Show color as background
      tailwind = "both", -- Enable tailwind colors
    },
    buftypes = {
      "*", -- Enable for all buffer types including quickfix
      "!prompt",
      "!popup",
    },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
