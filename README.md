# Neovim Configuration

A modern, feature-rich Neovim configuration built on [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) with elements from [Launch.nvim](https://github.com/LunarVim/Launch.nvim), optimized for Go and Python development.

This configuration has evolved over time. It originally started with Launch.nvim, was customized with personal preferences and additional plugins, and was later rebased to Kickstart.nvim as the foundation. The rebase to Kickstart.nvim provided a more functional base while preserving the customizations and workflow optimizations developed along the way. The configuration has been split from a single file into multiple organized files, with plugins and settings structured for maintainability.

> **Note:** This configuration was created and refined with the assistance of AI (Claude) to ensure best practices, comprehensive documentation, and optimal plugin integration.

## ✨ Features

- 🚀 **Fast startup** - Lazy-loaded plugins for optimal performance
- 🎨 **Multiple colorschemes** - Gruvbox, Catppuccin, Tokyo Night, and more
- 📝 **Powerful completion** - blink.cmp with LSP, snippets, and path completion
- 🔍 **Fuzzy finding** - Telescope for files, grep, LSP, and more
- 🤖 **AI Integration** - GitHub Copilot with chat interface
- 🐛 **Full debugging** - DAP support for Go and Python
- 📚 **Personal wiki** - Telekasten for note-taking and knowledge management
- 🌳 **Smart syntax** - Treesitter for advanced highlighting and text objects
- 🔧 **Auto-formatting** - Format-on-save with language-specific formatters
- 🪟 **Terminal integration** - Per-directory terminals and lazygit
- 📦 **Easy package management** - Mason for LSP servers, formatters, and linters

## 📋 Prerequisites

### Option 1: Homebrew (macOS & Linux)

macOS:
```bash
# Core tools
brew install neovim git ripgrep fd lazygit make node go python@3

# Nerd Font for icons (no tap needed as of 2024)
brew install font-hack-nerd-font
# Or choose another: font-jetbrains-mono-nerd-font, font-fira-code-nerd-font, etc.
```

Linux (with Homebrew):
```bash
# Core tools
brew install neovim git ripgrep fd lazygit make node go python@3

# Nerd Font for icons (no tap needed as of 2024!)
brew install font-hack-nerd-font
# Or choose another: font-jetbrains-mono-nerd-font, font-fira-code-nerd-font, etc.
```

**Linux (with Homebrew):**
```bash
brew install neovim git ripgrep fd lazygit make node go python@3 xclip gcc
brew install font-hack-nerd-font
```

### Option 2: Native Package Managers (Linux)

#### Ubuntu 24.04

Ubuntu 24.04 includes Neovim 0.9.5, which is sufficient for this configuration.

```bash
# Core tools (all available in official repos)
sudo apt update
sudo apt install neovim git ripgrep fd-find xclip gcc make curl unzip

# Node.js (via NodeSource for latest LTS)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Go
sudo snap install go --classic

# Python3 (pre-installed on Ubuntu 24.04)
sudo apt install python3 python3-pip python3-venv

# Lazygit (not in Ubuntu 24.04 repos - manual install required)
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit lazygit.tar.gz

# Nerd Fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
unzip Hack.zip
rm Hack.zip
fc-cache -fv
```

**Note:** `fd-find` is installed as `fdfind` on Ubuntu. Create a symlink:
```bash
mkdir -p ~/.local/bin
ln -s $(which fdfind) ~/.local/bin/fd
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Note for Ubuntu 22.04 users:** The default Neovim package is version 0.6.1, which is too old. Install from the [Neovim PPA](https://launchpad.net/~neovim-ppa/+archive/ubuntu/unstable):
```bash
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim
```

#### Debian 13 (Trixie)

Debian 13 (Trixie) includes Neovim 0.10.4. All required packages, including lazygit, are available in the official repositories.

```bash
# All packages available in official repos
sudo apt update
sudo apt install neovim git ripgrep fd-find lazygit xclip gcc make curl unzip

# Node.js (via NodeSource for latest LTS)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# Go
sudo apt install golang

# Python3 (pre-installed on Debian 13)
sudo apt install python3 python3-pip python3-venv

# Nerd Fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
unzip Hack.zip
rm Hack.zip
fc-cache -fv
```

Note: `fd-find` is installed as `fdfind` on Debian. Create a symlink:
```bash
mkdir -p ~/.local/bin
ln -s $(which fdfind) ~/.local/bin/fd
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Fedora

```bash
# Core tools
sudo dnf install neovim git ripgrep fd-find xclip gcc make curl unzip

# Node.js
sudo dnf install nodejs

# Go
sudo dnf install golang

# Python3 (usually pre-installed)
sudo dnf install python3 python3-pip

# Lazygit (via Copr repository)
sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit

# Nerd Fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Hack.zip
unzip Hack.zip
rm Hack.zip
fc-cache -fv
```

#### Arch Linux

```bash
# Core tools (most available in official repos)
sudo pacman -S neovim git ripgrep fd xclip gcc make curl nodejs go python python-pip unzip

# Lazygit (from AUR)
# Using yay (AUR helper)
yay -S lazygit

# Or using paru
paru -S lazygit

# Or manually without AUR helper
git clone https://aur.archlinux.org/lazygit.git
cd lazygit
makepkg -si
cd .. && rm -rf lazygit

# Nerd Fonts (available in official repos)
sudo pacman -S ttf-hack-nerd

# Or install other Nerd Fonts
sudo pacman -S ttf-jetbrains-mono-nerd ttf-firacode-nerd
```

Note: Arch Linux provides Nerd Fonts in the official repositories and maintains up-to-date versions of all packages due to its rolling release model.

If you don't have an AUR helper installed, install `yay` first:
```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd .. && rm -rf yay
```

### Optional but Recommended

**Additional language support** (install as needed):

```bash
# Via Homebrew
brew install rust cargo lua

# Via apt (Ubuntu/Debian)
sudo apt install rustc cargo lua5.4

# Via dnf (Fedora)
sudo dnf install rust cargo lua

# Via pacman (Arch)
sudo pacman -S rust lua
```

### Verifying Installation

After installing with any method, verify everything works:

```bash
# Check versions
nvim --version      # Should be 0.9.0 or higher
git --version
rg --version
fd --version
lazygit --version
node --version
go version
python3 --version

# Check clipboard (Linux only)
echo "test" | xclip -selection clipboard
xclip -selection clipboard -o
```

## 🚀 Installation

1. **Backup existing config** (if you have one):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   ```

2. **Clone this repository**:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. **Install dependencies**:
   - Choose **Option 1** (Homebrew) or **Option 2** (Native Package Manager) from the Prerequisites section above
   - Follow the appropriate commands for your operating system

4. **Configure terminal font**:
   - Set your terminal to use a Nerd Font (Hack Nerd Font if following the guide)
   - iTerm2: Preferences → Profiles → Text → Font
   - Alacritty: Edit `~/.config/alacritty/alacritty.toml`
   - Kitty: Edit `~/.config/kitty/kitty.conf`
   - GNOME Terminal: Preferences → Profile → Text → Custom font
   - Konsole: Settings → Edit Current Profile → Appearance → Font

5. **Ubuntu/Debian users only**: Ensure fd symlink is in PATH:
   
   Ubuntu and Debian install `fd` as `fdfind` to avoid naming conflicts. If you followed the installation instructions above, you've already created the symlink. Verify it works:
   ```bash
   fd --version  # Should show fd version, not "command not found"
   ```

6. **Launch Neovim**:
   ```bash
   nvim
   ```
   - Lazy.nvim will automatically install all plugins
   - Mason will auto-install LSP servers and tools
   - First launch may take a few minutes

7. **Verify installation**:
   ```vim
   :checkhealth
   :Mason
   :LspInfo
   ```

## 🎯 Quick Start Guide

### Essential Keybindings

**Leader key:** `Space`

#### File Operations
- `<Space>ff` - Find files
- `<Space>fg` - Live grep (search in files)
- `<Space>fb` - Find buffers
- `<Space><Space>` - Quick buffer switch
- `<Space>e` - Toggle file explorer

#### Code Navigation
- `gd` - Go to definition
- `gr` - Find references
- `K` - Hover documentation
- `<Space>ca` - Code actions
- `<Space>cf` - Format buffer

#### Git Integration
- `<Space>gg` - Open lazygit
- `<Space>gj/gk` - Next/previous hunk
- `<Space>gp` - Preview hunk
- `<Space>gb` - Git blame line

#### AI Assistant (Copilot)
- `<Space>aa` - Toggle Copilot chat
- `<Space>aq` - Quick question
- `Ctrl+g` - Accept suggestion (insert mode)
- Visual mode: `<Space>ae` - Explain, `<Space>ar` - Review, `<Space>af` - Fix

#### Debugging
- `<Space>dd` - Start/continue debug
- `<Space>db` - Toggle breakpoint
- `<Space>dn` - Step over
- `<Space>di` - Step into
- `<Space>do` - Step out
- `<Space>du` - Toggle debug UI

#### Terminals
- `<Space>1` - Horizontal terminal (per-directory)
- `<Space>2` - Vertical terminal (per-directory)
- `<Space>3` - Floating terminal (per-directory)
- `Ctrl+\` - Toggle terminal

#### Window Management
- `Ctrl+h/j/k/l` - Navigate between windows
- `<Space>↑/↓/←/→` - Resize windows

## 🔧 Language Support

### Go
- **LSP:** gopls with full configuration
- **Formatting:** gofumpt + goimports (auto on save)
- **Debugging:** Delve integration with nvim-dap-go
- **Features:** Inlay hints, code actions, auto-imports

### Python
- **LSP:** pyright with type checking
- **Formatting:** black + isort (auto on save)
- **Linting:** ruff for fast diagnostics
- **Debugging:** debugpy with test method debugging
- **Features:** Virtual environment detection, Django support

### Lua
- **LSP:** lua_ls (Neovim config aware)
- **Formatting:** stylua
- **Features:** lazydev.nvim for Neovim API completion

### YAML/JSON
- **LSP:** yamlls, jsonls
- **Schema validation:** schemastore.nvim for auto-completion
- **Formatting:** yamlfmt

### Shell Scripts
- **Linting:** shellcheck
- **Formatting:** shfmt

## 📁 Configuration Structure

```
~/.config/nvim/
├── init.lua                 # Entry point - loads all modules
├── lua/
│   ├── user/
│   │   ├── launch.lua       # Plugin specification system
│   │   ├── lazy.lua         # Lazy.nvim setup
│   │   ├── options.lua      # Vim options
│   │   ├── keymaps.lua      # Global keymaps
│   │   ├── autocommands.lua # Autocommands
│   │   ├── colorscheme.lua  # Color scheme configuration
│   │   ├── icons.lua        # Icon definitions
│   │   └── plugins/         # Plugin configurations
│   │       ├── lsp.lua      # LSP + Mason setup
│   │       ├── cmp.lua      # Completion (blink.cmp)
│   │       ├── treesitter.lua
│   │       ├── telescope.lua
│   │       ├── conform.lua  # Formatting
│   │       ├── ai.lua       # Copilot + CopilotChat
│   │       ├── dap.lua      # Debugging
│   │       ├── snacks.lua   # Terminal, lazygit, etc.
│   │       ├── mini.lua     # Mini.nvim modules
│   │       ├── gitsigns.lua
│   │       ├── nvimtree.lua
│   │       ├── telekasten.lua
│   │       └── ...
│   └── snippets/
│       └── emoji.lua        # Emoji snippets
└── README.md
```

## 🔌 Plugin List

### Core
- **lazy.nvim** - Plugin manager
- **nvim-lspconfig** - LSP configuration
- **mason.nvim** - LSP/formatter/linter installer
- **blink.cmp** - Completion engine
- **nvim-treesitter** - Syntax parsing

### UI
- **lualine.nvim** - Statusline
- **nvim-tree.lua** - File explorer
- **breadcrumbs.nvim** - Code context breadcrumbs
- **nvim-navic** - LSP symbol context
- **which-key.nvim** - Keybinding hints
- **snacks.nvim** - Notifications, terminals, zen mode

### Editor
- **telescope.nvim** - Fuzzy finder
- **mini.nvim** - Swiss army knife (surround, pairs, comment, etc.)
- **conform.nvim** - Formatting
- **gitsigns.nvim** - Git integration
- **todo-comments.nvim** - Highlight TODOs

### AI & Completion
- **copilot.lua** - GitHub Copilot
- **CopilotChat.nvim** - AI chat interface
- **LuaSnip** - Snippet engine
- **friendly-snippets** - Snippet collection

### Debugging
- **nvim-dap** - Debug Adapter Protocol
- **nvim-dap-ui** - Debug UI
- **nvim-dap-go** - Go debugging
- **nvim-dap-python** - Python debugging

### Specialty
- **telekasten.nvim** - Personal wiki/notes
- **sops.nvim** - Encrypted secrets management
- **schemastore.nvim** - JSON/YAML schemas
- **nvim-colorizer.lua** - Color code highlighting

## ⚙️ Customization

### Changing the Colorscheme

Edit `lua/user/colorscheme.lua`:
```lua
local colorscheme = "base16-gruvbox-dark-pale"  -- Change this line
```

Available schemes: `darkplus`, `badwolf`, `base16-*`, `catppuccin`, `gruvbox`, `tokyonight`

### Adding a New Language Server

1. Add to `servers` table in `lua/plugins/lsp.lua`:
   ```lua
   local servers = {
     your_lsp = {
       settings = {
         -- LSP-specific settings
       },
     },
   }
   ```

2. The LSP will be auto-installed via Mason

### Adding Formatters

Edit `lua/plugins/conform.lua`:
```lua
formatters_by_ft = {
  your_language = { "formatter1", "formatter2" },
}
```

Add the formatter to `ensure_installed` in `lua/plugins/lsp.lua`

### Disabling Format-on-Save

In `lua/plugins/conform.lua`, change:
```lua
format_on_save = function(bufnr)
  return nil  -- Disable for all filetypes
end
```

Or disable for specific filetypes:
```lua
local disable_filetypes = { c = true, cpp = true, python = true }
```

### Custom Keybindings

Add to `lua/user/keymaps.lua`:
```lua
vim.keymap.set('n', '<leader>xx', '<cmd>YourCommand<CR>', { desc = 'Description' })
```

## 🐛 Troubleshooting

### Icons not displaying
- Ensure you've installed a Nerd Font
- Verify your terminal is using the Nerd Font
- Check `:echo vim.g.have_nerd_font` returns `true`

### LSP not working
```vim
:LspInfo          " Check if LSP is attached
:Mason            " Verify language servers are installed
:checkhealth lsp  " Diagnose LSP issues
```

### Formatting not working
```vim
:ConformInfo      " Check formatter status
:Mason            " Verify formatters are installed
```

### Copilot authentication
```vim
:Copilot auth     " Start authentication flow
:Copilot status   " Check connection status
```

### Plugin issues
```vim
:Lazy sync        " Update all plugins
:Lazy clean       " Remove unused plugins
:checkhealth lazy " Diagnose plugin issues
```

### Mason installation failures
- Check `:checkhealth mason` for missing dependencies
- Ensure `node`, `go`, `python3` are installed
- On Linux, verify `gcc` and build tools are available

## 📚 Learning Resources

- **Neovim docs:** `:help` or `:Tutor`
- **Plugin docs:** `:help <plugin-name>`
- **Lua guide:** `:help lua-guide`
- **LSP:** `:help lsp`
- **Keymaps:** Press `<Space>` and wait for which-key popup
- **Telescope help:** `:Telescope help_tags`
- **Kickstart.nvim documentation:** Many of the base concepts and configurations come from Kickstart.nvim, whose documentation and comments are invaluable for understanding Neovim configuration

## 🤝 Contributing

This is a personal configuration that has evolved over time to fit specific workflows and preferences. However, suggestions and improvements are welcome.

If you find bugs, have suggestions, or want to contribute improvements:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

Note: This configuration is actively maintained and regularly updated with new plugins and optimizations.

## 🙏 Credits

This configuration has evolved through inspiration and learning from multiple sources in the Neovim community.

### Foundation
Built with components and inspiration from:
- [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - TJ DeVries
- [Launch.nvim](https://github.com/LunarVim/Launch.nvim) - Chris@Machine  
- [LazyVim](https://github.com/LazyVim/LazyVim) - Folke Lemaitre

### Special Thanks
Huge thanks to the entire Neovim community for providing amazing plugins and sharing information about configurations.

Special recognition to:
- **[TJ DeVries](https://github.com/tjdevries)** - Creator of Kickstart.nvim, Telescope.nvim, plenary.nvim, and many other essential projects used throughout the community. His educational content on Neovim, Lua, and configuration has been invaluable.
- **[Chris@Machine](https://chrisatmachine.com/)** - Creator of LunarVim, Launch.nvim, and [Neovim-from-scratch](https://github.com/LunarVim/Neovim-from-scratch), which provided the foundation for early versions of this configuration.
- **Neovim plugin authors** - For creating and maintaining the excellent plugins that make this configuration possible.

### Development
This configuration was developed with assistance from Claude (Anthropic) for optimal setup, documentation, and best practices.

## 📝 License

This configuration is provided as-is for personal use. Individual plugins have their own licenses.

---

**Author:** NightsPaladin  
**Created:** 2024-2025  
**AI Assistant:** Claude by Anthropic
