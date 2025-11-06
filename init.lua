-- ============================================================================
-- Essential Core Modules (Load First: Sets up base options, keymaps, and events)
-- ============================================================================
require("user.launch")        -- Plugin specification system
require("user.options")       -- Vim/neovim options and settings
require("user.keymaps")       -- Global keybindings
require("user.autocommands")  -- Automated commands for events

-- ============================================================================
-- User Interface & Appearance (Colors, statusline, navigation)
-- ============================================================================
spec("user.colorscheme")                -- Set colorscheme
spec("user.plugins.lualine")            -- Statusline
spec("user.plugins.breadcrumbs")        -- Show code context in statusline
spec("user.plugins.navic")              -- LSP symbol navigation

-- ============================================================================
-- Language Support & Editing (LSP, completion, syntax, markdown)
-- ============================================================================
spec("user.plugins.lazydev")            -- Lua LSP for Neovim config (dependency for completion)
spec("user.plugins.schemastore")        -- JSON/YAML schemas (dependency for LSP)
spec("user.plugins.lsp")                -- Language Server Protocol setup
spec("user.plugins.cmp")                -- Completion engine
spec("user.plugins.treesitter")         -- Syntax highlighting and parsing
spec("user.plugins.markview")           -- Inline Markdown rendering

-- ============================================================================
-- Editor Enhancements (General productivity plugins)
-- ============================================================================
spec("user.plugins.mini")               -- Multi-tool: surround, pairs, comment, etc.
spec("user.plugins.snacks")             -- Terminal, lazygit, notifications, toggles
spec("user.plugins.telescope")          -- Fuzzy finder (disabled)
spec("user.plugins.whichkey")           -- Keybinding hints
spec("user.plugins.nvimtree")           -- File explorer

-- ============================================================================
-- Code Quality & Formatting
-- ============================================================================
spec("user.plugins.conform")            -- Code formatting
spec("user.plugins.guessindent")        -- Auto-detect indentation
spec("user.plugins.colorizer")          -- Highlight color codes
spec("user.plugins.todocomments")       -- Highlight TODO/FIXME in comments

-- ============================================================================
-- Git Integration
-- ============================================================================
spec("user.plugins.gitsigns")           -- Git status in gutter, hunk navigation

-- ============================================================================
-- Debugging
-- ============================================================================
spec("user.plugins.dap")                -- Debug Adapter Protocol support

-- ============================================================================
-- AI & Copilot
-- ============================================================================
spec("user.plugins.ai")                 -- GitHub Copilot & CopilotChat
-- require("user.plugins.copilot-telescope") -- Multi-file CopilotChat (disabled)

-- ============================================================================
-- Specialty & Project-Specific Plugins
-- ============================================================================
spec("user.plugins.telekasten")         -- Personal wiki/note-taking
spec("user.plugins.sops")               -- Encrypted secrets management
-- NOTE: Project management is loaded in snacks.lua after VeryLazy event

-- ============================================================================
-- Disabled Plugins (Superseded by other solutions)
-- ============================================================================
-- spec("user.plugins.bufferline")       -- Replaced by lualine
-- spec("user.plugins.gitlinker")        -- Replaced by snacks.nvim gitbrowse
-- spec("user.plugins.indentline")       -- Replaced by mini.indentscope
-- spec("user.plugins.nvimsurround")     -- Replaced by mini.surround
-- spec("user.plugins.toggleterm")       -- Replaced by snacks.nvim terminal/lazygit

-- ============================================================================
-- Plugin Manager Initialization (Must Be Last)
-- ============================================================================
require("user.lazy")                    -- Initialize plugin manager

-- vim: ts=2 sts=2 sw=2 et
