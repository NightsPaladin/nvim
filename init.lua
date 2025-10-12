-- ============================================================================
-- Core Configuration (Must Load First)
-- ============================================================================
require("user.launch")
require("user.options")
require("user.keymaps")
require("user.autocommands")

-- ============================================================================
-- UI & Appearance
-- ============================================================================
spec("user.colorscheme")
spec("user.plugins.lualine") -- Statusline
spec("user.plugins.breadcrumbs") -- Breadcrumb navigation
spec("user.plugins.navic") -- LSP symbol context

-- ============================================================================
-- Core Editing & LSP (Foundation for other plugins)
-- ============================================================================
spec("user.plugins.lazydev") -- Lua LSP for Neovim config (dependency for cmp)
spec("user.plugins.schemastore") -- JSON/YAML schemas (dependency for LSP)
spec("user.plugins.lsp") -- LSP configuration
spec("user.plugins.cmp") -- Completion engine
spec("user.plugins.treesitter") -- Syntax parsing & highlighting

-- ============================================================================
-- Editor Enhancements (Multi-purpose plugins)
-- ============================================================================
spec("user.plugins.mini") -- Swiss army knife (surround, pairs, comment, bufremove, indentscope, etc.)
spec("user.plugins.snacks") -- Terminal, lazygit, notifications, toggles, etc.
spec("user.plugins.telescope") -- Fuzzy finder
spec("user.plugins.whichkey") -- Keybinding hints
spec("user.plugins.nvimtree") -- File explorer

-- ============================================================================
-- Code Quality & Formatting
-- ============================================================================
spec("user.plugins.conform") -- Code formatting
spec("user.plugins.guessindent") -- Auto-detect indentation
spec("user.plugins.colorizer") -- Color code highlighting
spec("user.plugins.todocomments") -- Highlight TODO/FIXME/etc in comments

-- ============================================================================
-- Git Integration
-- ============================================================================
spec("user.plugins.gitsigns") -- Git signs in gutter, hunk navigation

-- ============================================================================
-- AI & Copilot
-- ============================================================================
spec("user.plugins.ai") -- GitHub Copilot & CopilotChat
require("user.plugins.copilot-telescope") -- Multi-file selection for CopilotChat

-- ============================================================================
-- Specialty & Project-Specific
-- ============================================================================
spec("user.plugins.telekasten") -- Personal wiki/note-taking
spec("user.plugins.sops") -- Encrypted secrets management

-- ============================================================================
-- Disabled Plugins (Replaced by other solutions)
-- ============================================================================

-- Replaced by lualine
-- spec("user.plugins.bufferline")

-- Replaced by snacks.nvim gitbrowse
-- spec("user.plugins.gitlinker")

-- Replaced by mini.indentscope
-- spec("user.plugins.indentline")

-- Replaced by mini.surround
-- spec("user.plugins.nvimsurround")

-- Not currently using project management
-- spec("user.plugins.project")

-- Replaced by snacks.nvim terminal and lazygit
-- spec("user.plugins.toggleterm")

-- ============================================================================
-- Plugin Manager Initialization (Must Be Last)
-- ============================================================================
require("user.lazy")

-- vim: ts=2 sts=2 sw=2 et
