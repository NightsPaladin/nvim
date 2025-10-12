return {
  "SmiteshP/nvim-navic",
  opts = function()
    local icons = require("user.icons")
    return {
      icons = icons.kind,
      highlight = true,
      lsp = {
        auto_attach = true,
      },
      click = true,
      separator = " " .. icons.ui.ChevronRight .. " ",
      depth_limit = 0,
      depth_limit_indicator = "..",
    }
  end,
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
