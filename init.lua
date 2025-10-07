require("user.launch")
require("user.options")
require("user.keymaps")
require("user.autocommands")
spec("user.colorscheme")

-- Plugin to provide "tabs" at the top, showing all open buffers/tabs.
-- I don't need this as telescope and Shift+H/L can move between files.
-- I think it's primarily for a VS Code-like experience.
-- spec("user.plugins.bufferline")
spec("user.plugins.ai")
spec("user.plugins.breadcrumbs")
spec("user.plugins.cmp")
spec("user.plugins.colorizer")
spec("user.plugins.conform")
spec("user.plugins.gitsigns")
spec("user.plugins.guessindent")
spec("user.plugins.indentline")
spec("user.plugins.lazydev")
spec("user.plugins.lsp")
spec("user.plugins.lualine")
spec("user.plugins.mini")
spec("user.plugins.navic")
spec("user.plugins.nvimsurround")
spec("user.plugins.nvimtree")
spec("user.plugins.gitlinker")
-- spec("user.plugins.project")
spec("user.plugins.sops")
spec("user.plugins.schemastore") -- Keep? Messes with various filetype formatting schemas like JSON, YAML, LUA.
spec("user.plugins.telescope")
spec("user.plugins.telekasten")
spec("user.plugins.todocomments")
spec("user.plugins.toggleterm")
spec("user.plugins.treesitter")
spec("user.plugins.whichkey")
require("user.lazy")

--
-- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
-- Or use telescope!
-- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
-- you can continue same window with `<space>sr` which resumes last telescope search

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
