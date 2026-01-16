#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}~${NC} $1 ${GREEN}~${NC}"; }
warn() { echo -e "${YELLOW}~${NC} $1 ${YELLOW}~${NC}"; }
error() { echo -e "${RED}~${NC} $1 ${RED}~${NC}"; }

prompt_install() {
    local name="$1"
    read -p "Would you like to install $name? [y/N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

install_brew() {
    if command -v brew &> /dev/null; then
        info "Homebrew already installed"
        return 0
    fi
    
    if prompt_install "Homebrew"; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    else
        warn "Skipping Homebrew installation"
        return 1
    fi
}

install_ohmyzsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        info "Oh My Zsh already installed"
        return 0
    fi
    
    if prompt_install "Oh My Zsh"; then
        info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        warn "Skipping Oh My Zsh installation"
        return 1
    fi
}

install_bob() {
    if command -v bob &> /dev/null; then
        info "bob already installed"
        return 0
    fi
    
    if prompt_install "bob (neovim version manager)"; then
        if command -v brew &> /dev/null; then
            info "Installing bob via Homebrew..."
            brew install bob
        elif command -v cargo &> /dev/null; then
            info "Installing bob via cargo..."
            cargo install bob-nvim
        else
            error "Neither brew nor cargo found. Please install bob manually."
            return 1
        fi
    else
        warn "Skipping bob installation"
        return 1
    fi
}

install_zsh() {
    if command -v zsh &> /dev/null; then
        info "zsh already installed"
        return 0
    fi
    
    if prompt_install "zsh"; then
        if command -v brew &> /dev/null; then
            brew install zsh
        elif command -v apt &> /dev/null; then
            sudo apt install -y zsh
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y zsh
        elif command -v pacman &> /dev/null; then
            sudo pacman -S --noconfirm zsh
        else
            error "Could not detect package manager. Please install zsh manually."
            return 1
        fi
    else
        warn "Skipping zsh installation"
        return 1
    fi
}

# Format: source:destination
LINKS=(
    "sway:$HOME/.config/sway"
    "nvim:$HOME/.config/nvim"
    "waybar:$HOME/.config/waybar"
    "nnn:$HOME/.config/nnn"
    "wofi:$HOME/.config/wofi"
    "zshrc:$HOME/.zshrc"
    "zsh:$HOME/.zsh"
	"wezterm.lua:$HOME/.wezterm.lua"
)

mkdir -p "$HOME/.config"

info "Checking dependencies..."
install_zsh || true
install_brew || true
install_ohmyzsh || true
install_bob || true

[ -f "$DOTFILES_DIR/.gitmodules" ] && git -C "$DOTFILES_DIR" submodule update --init --recursive

link() {
    local src="$1" dest="$2"
    
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
        echo "~ Already exists: $dest ~"
        return
    fi
    
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        mv "$dest" "$dest.bak.$(date +%s)"
        echo "~ Backup created: $dest.bak.$(date +%s) ~"
    fi
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"
    
    ln -s "$src" "$dest"
    echo "~ Linked: $dest → $src ~"
}

for item in "${LINKS[@]}"; do
    link "$DOTFILES_DIR/${item%%:*}" "${item##*:}"
done

# Link zsh plugins to Oh My Zsh custom plugins directory
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ -d "$HOME/.oh-my-zsh" ]; then
    mkdir -p "$ZSH_CUSTOM/plugins"
    for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search; do
        if [ -d "$DOTFILES_DIR/zsh/$plugin" ]; then
            link "$DOTFILES_DIR/zsh/$plugin" "$ZSH_CUSTOM/plugins/$plugin"
        fi
    done
else
    echo "~ Warning: Oh My Zsh not found. Install it first, then re-run this script ~"
fi

echo "~ Installation complete ~"
