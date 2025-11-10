#!/usr/bin/env bash

# Neovim dependencies installer
# Works standalone or as part of dotfiles system

set -e

# ============================================
# CONFIGURATION - Edit these lists as needed
# ============================================

# Neovim version to install via mise
NEOVIM_VERSION="0.11.3"

# Tools to install via mise (preferred method)
MISE_TOOLS=(
    "python@3.12"                   # Python (required for pynvim)
    "node@lts"                      # Node.js (required for neovim npm package and LSPs)
    "jq@latest"                     # JSON formatter
    "shellcheck@latest"             # Shell script linter
    "shfmt@latest"                  # Shell script formatter
    "tree-sitter@latest"            # Parser library
    "black@latest"                  # Python formatter
    "prettier@latest"               # Multi-language formatter (JS/JSON/YAML/Markdown/etc)
    "stylua@latest"                 # Lua formatter
    "yamlfmt@latest"                # YAML formatter
    "taplo@latest"                  # TOML formatter
    "yamllint@latest"               # YAML linter
    "ruff@latest"                   # Python linter and formatter
    "lua-language-server@latest"    # Lua LSP
    "gofumpt@latest"                # Go formatter (stricter gofmt)
    "golangci-lint@latest"          # Go linter (if Go available)
    "rust-analyzer@latest"          # Rust LSP (if Rust available)
    "julia@latest"                  # Julia (required by Mason)
)

# Tools to install via Homebrew (fallback if mise fails or not available)
BREW_TOOLS=(
    "eslint"                        # JavaScript/TypeScript linter
    "pyright"                       # Python type checker/LSP
    "gopls"                         # Go LSP
    "typescript-language-server"    # TypeScript/JavaScript LSP
    "yaml-language-server"          # YAML LSP
    "bash-language-server"          # Bash LSP
    "cpplint"                       # C++ linter
    "yamlfix"                       # YAML formatter
    "sops"                          # Secrets encryption (for sops.nvim)
    "catimg"                        # Image preview (for telekasten media)
    "flake8"                        # Python linter (legacy support)
)

# Python packages to install via pip (only if not available via mise/brew)
PYTHON_PACKAGES=(
    "pynvim"          # Neovim Python support (required, not available via mise/brew)
)

# Node packages to install via npm (only if not available via mise/brew)
NPM_PACKAGES=(
    "neovim"                        # Neovim Node.js support (required, not available via mise/brew)
    "vscode-langservers-extracted"  # HTML/CSS/JSON/ESLint LSPs (not available via mise/brew)
    "mcp-hub"                       # Model Context Protocol Hub (not available via mise/brew)
)

# ============================================
# Colors for output
# ============================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo ""
log_info "=============================================="
log_info "  Neovim Dependencies Installer"
log_info "=============================================="
echo ""

# Detect OS
OS_TYPE=""
case "$(uname -s)" in
Darwin*) OS_TYPE="macos" ;;
Linux*) OS_TYPE="linux" ;;
*)
  log_error "Unsupported OS: $(uname -s)"
  exit 1
  ;;
esac
log_info "Detected OS: ${OS_TYPE}"

# Check and install Homebrew
log_info "Checking for Homebrew..."
if ! command -v brew &>/dev/null; then
  log_warn "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for this session
  if [[ "$OS_TYPE" == "macos" ]]; then
    export PATH="/opt/homebrew/bin:$PATH"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
  log_success "Homebrew installed"
else
  log_success "Homebrew already installed"
fi

# Check and install mise
log_info "Checking for mise..."
if ! command -v mise &>/dev/null; then
  log_warn "mise not found. Installing via Homebrew..."
  brew install mise

  # Add mise to PATH for this session
  eval "$(mise activate bash)"
  log_success "mise installed"
else
  log_success "mise already installed"
  eval "$(mise activate bash)" 2>/dev/null || true
fi

# Install Neovim via mise
log_info "Installing Neovim..."
if mise list neovim 2>/dev/null | grep -q "neovim"; then
  log_success "Neovim already installed via mise"
else
  log_info "Installing Neovim ${NEOVIM_VERSION}..."
  mise use -g "neovim@${NEOVIM_VERSION}"
  log_success "Neovim ${NEOVIM_VERSION} installed"
fi

# Install mise tools (preferred for available tools)
log_info "Installing tools via mise..."
for tool in "${MISE_TOOLS[@]}"; do
    # Extract tool name and version
    tool_spec="${tool%% #*}"
    tool_spec="${tool_spec## }"  # Trim whitespace
    tool_name="${tool_spec%%@*}"
    
    # Skip language-specific tools if language not available
    if [[ "$tool_name" == "gofumpt" || "$tool_name" == "golangci-lint" ]] && ! command -v go &>/dev/null; then
        log_info "Skipping $tool_name (Go not installed)"
        continue
    fi
    if [[ "$tool_name" == "rust-analyzer" ]] && ! command -v cargo &>/dev/null; then
        log_info "Skipping $tool_name (Rust not installed)"
        continue
    fi
    
    if mise list "$tool_name" 2>/dev/null | grep -q "$tool_name"; then
        log_success "$tool_name already installed via mise"
    else
        log_info "Installing $tool_spec via mise..."
        if mise use -g "$tool_spec" 2>/dev/null; then
            log_success "$tool_name installed via mise"
        else
            log_warn "$tool_name failed to install via mise, will try brew"
        fi
    fi
done

# Verify Python is available (should be installed via mise tools above)
log_info "Verifying Python installation..."
if command -v python3 &>/dev/null; then
  PYTHON_CMD="python3"
  DETECTED_PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
  log_success "Python available: ${DETECTED_PYTHON_VERSION}"
else
  log_error "Python not found. This should have been installed via mise tools."
  exit 1
fi

# Install Python packages
log_info "Installing Python packages..."
for package in "${PYTHON_PACKAGES[@]}"; do
  # Extract package name (before any version specifier)
  pkg_name="${package%%[<>=]*}"

  if $PYTHON_CMD -m pip show "$pkg_name" &>/dev/null; then
    log_success "$pkg_name already installed"
  else
    log_info "Installing $package..."
    $PYTHON_CMD -m pip install --user "$package"
    log_success "$pkg_name installed"
  fi
done

# Verify Node.js is available (should be installed via mise tools above)
log_info "Verifying Node.js installation..."
if command -v node &>/dev/null; then
  DETECTED_NODE_VERSION=$(node --version)
  log_success "Node.js available: ${DETECTED_NODE_VERSION}"
else
  log_error "Node.js not found. This should have been installed via mise tools."
  exit 1
fi

# Install Node packages
log_info "Installing Node.js packages..."
for package in "${NPM_PACKAGES[@]}"; do
  # Extract package name (before any @ version specifier)
  pkg_name="${package%%@*}"

  if npm list -g "$pkg_name" 2>/dev/null | grep -q "$pkg_name"; then
    log_success "$pkg_name already installed"
  else
    log_info "Installing $package..."
    npm install -g "$package"
    log_success "$pkg_name installed"
  fi
done

# Install tools via Homebrew (fallback for tools not in mise or that failed)
log_info "Installing tools via Homebrew (fallback)..."
for tool in "${BREW_TOOLS[@]}"; do
    # Extract just the package name (remove comments)
    pkg="${tool%% #*}"
    pkg="${pkg## }"  # Trim whitespace
    
    # Check if tool is already available (from mise or system)
    tool_cmd="${pkg}"
    # Handle tools where command name differs from package name
    case "$pkg" in
        "lua-language-server") tool_cmd="lua-language-server" ;;
        "typescript-language-server") tool_cmd="typescript-language-server" ;;
        "yaml-language-server") tool_cmd="yaml-language-server" ;;
        "bash-language-server") tool_cmd="bash-language-server" ;;
    esac
    
    if command -v "$tool_cmd" &>/dev/null; then
        log_success "$pkg already available (via mise or system)"
    elif brew list "$pkg" &>/dev/null; then
        log_success "$pkg already installed via brew"
    else
        log_info "Installing $pkg via brew..."
        if brew install "$pkg" 2>/dev/null; then
            log_success "$pkg installed via brew"
        else
            log_warn "$pkg failed to install via brew"
        fi
    fi
done


echo ""
log_success "=============================================="
log_success "  Neovim Dependencies Installation Complete!"
log_success "=============================================="
echo ""
log_info "Installed:"
log_info "  ✓ Neovim (via mise)"
log_info "  ✓ Python support (pynvim)"
log_info "  ✓ Node.js support (neovim npm package)"
log_info "  ✓ Formatters (black, prettier, stylua, shfmt, gofumpt, yamlfmt, yamlfix, jq, taplo)"
log_info "  ✓ Linters (eslint, cpplint, ruff, flake8, yamllint, shellcheck)"
log_info "  ✓ Language Servers (TypeScript, YAML, Bash, Python/Pyright, Lua, Go, Rust)"
log_info "  ✓ Additional Tools (tree-sitter, sops, catimg, mcp-hub)"
log_info ""
log_info "Installation priority used:"
log_info "  1. mise (preferred for cross-platform consistency)"
log_info "  2. Homebrew (fallback for tools not in mise)"
log_info "  3. Language package managers (only for language bindings)"
echo ""
log_info "Next steps:"
log_info "  1. Start Neovim: nvim"
log_info "  2. Run :checkhealth to verify installation"
log_info "  3. Additional LSPs/tools will auto-install on first use (via Mason)"
log_info "  4. For AI features, authenticate Copilot: :Copilot auth"
log_info ""
log_info "Note: Some tools (terraform_fmt, helm, kubectl) are managed via mise"
log_info "      and should be installed through your dotfiles Brewfile/mise-tools"
echo ""
