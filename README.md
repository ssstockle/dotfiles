# Dotfiles
My ~ personal configurations ~ for:
- **sway** - Wayland compositor
- **nvim** - Neovim :s
- **waybar** - Status bar for Sway
- **wofi** - Application launcher (themed to match sway)
- **nnn** - File manager
- **zsh** - Shell config + plugins
- **wezterm** - Terminal emulator

## Prerequisites
The install script will prompt to install these if missing:
- **zsh** - Required shell
- **Homebrew/Linuxbrew** - Package manager (used for installing other tools)
- **Oh My Zsh** - Zsh framework for plugins/themes
- **bob** - Neovim version manager (optional, for nvim config)

You'll also need:
- **git** - For cloning and submodules
- **curl** - For downloading installers

### Optional (maybe not too ~optional~ as these are pretty much the most configured things, even though they're still minimalistic)
Install these manually if you plan to use their configurations:
- **[sway](https://swaywm.org/)** - Window manager (Wayland)
- **[waybar](https://github.com/Alexays/Waybar)** - Status bar for Sway
- **[wofi](https://hg.sr.ht/~scoopta/wofi)** - Application launcher for Wayland
- **[wezterm](https://wezfurlong.org/wezterm/)** - Terminal emulator
- **[nnn](https://github.com/jarun/nnn)** - File manager
- **[neovim](https://neovim.io/)** - Install via `bob use stable` after running install.sh

## Installation
```bash
git clone --recursive <repo-url> ~/dotfiles
cd ~/dotfiles
./install.sh
```

The script will:
1. Prompt to install missing dependencies (zsh, Homebrew, Oh My Zsh, bob)
2. Initialize git submodules (zsh plugins)
3. Create symlinks for all configurations
4. Link zsh plugins to Oh My Zsh custom plugins directory

Existing configs are backed up with timestamps (`.bak.timestamp`).

## Update zsh plugins
```bash
git submodule update --remote
```

## Adding New Configurations

### Step 1: Copy your config to dotfiles
```bash
# For .config apps
cp -r ~/.config/yourapp ~/dotfiles/

# For home directory files
cp ~/.yourconfig ~/dotfiles/yourconfig
```

### Step 2: Add entry to install.sh
Edit `install.sh` and add a new line to the `LINKS` array:
```bash
LINKS=(
    "i3:$HOME/.config/i3"
    "sway:$HOME/.config/sway"

    # ... existing entries ...
    
    "yourapp:$HOME/.config/yourapp"      # For .config apps
    "yourconfig:$HOME/.yourconfig"        # For home directory files
)
```

**Format:** `"source:destination"`
- `source` = folder/file name in your dotfiles directory
- `destination` = where it should be linked (full path)

### Step 3: Commit and apply
```bash
git add yourapp  # or yourconfig
git commit -m "Add yourapp config"
git push
./install.sh
```

## Updating Existing Configurations
Since your configs are symlinked, any changes you make are automatically reflected in the dotfiles directory. Just commit and push:
```bash
cd ~/dotfiles
git add -u
git commit -m "Update configs"
git push
```

## Adding Git Submodules (for plugins, themes, etc.)
```bash
cd ~/dotfiles
git submodule add <repository-url> <destination-folder>
git commit -m "Add submodule: <name>"
git push
```

## Examples

### Adding kitty terminal config
```bash
cp -r ~/.config/kitty ~/dotfiles/
```
Edit `install.sh`:
```bash
LINKS=(
    # ... existing entries ...
    "kitty:$HOME/.config/kitty"
)
```
```bash
git add kitty
git commit -m "Add kitty config"
./install.sh
```

### Adding .bashrc
```bash
cp ~/.bashrc ~/dotfiles/bashrc
```
Edit `install.sh`:
```bash
LINKS=(
    # ... existing entries ...
    "bashrc:$HOME/.bashrc"
)
```
```bash
git add bashrc
git commit -m "Add bashrc"
./install.sh
```
