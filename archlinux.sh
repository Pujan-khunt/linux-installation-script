#!/usr/bin/env bash

DOTFILES_ORIGIN="https://github.com/Pujan-khunt/dotfiles.git"
NEOVIM_ORIGIN="https://github.com/Pujan-khunt/nvim.git"
CONFIG_DIR="$HOME/.config"

# Install neovim to write down things.
sudo pacman -S nvim
echo "1. installing neovim via pacman"

# Installing git for obvious reasons.
sudo pacman -S git
echo "2. Installing git via pacman"

# Cloning neovim config
git -C $CONFIG_DIR clone $NEOVIM_ORIGIN
echo "3. Cloning neovim configuration files from $NEOVIM_ORIGIN into $CONFIG_DIR"

# Install keyd to remap CAPS to ESC for easier use with Neovim.
sudo pacman -S keyd
echo "4. installed keyd via pacman"

# Create directory to store config files for keyd.
sudo mkdir -p /etc/keyd
echo "5. created /etc/keyd to store configuration files for keyd"

# Write the configuration for keyd.
sudo echo "[ids]

*

[main]

# Capslock behaves has control on hold and escape on press.
capslock = overload(control, esc)

# Escape key behaves as the capslock key.
esc = capslock" > /etc/keyd/default.conf
echo "6. keyd config written at /etc/keyd/default.conf"

# Enable the keyd daemon
sudo systemctl enable --now keyd
echo "7. Enabling keyd daemon for use"

# Cloning dotfiles
git -C $HOME clone $DOTFILES_ORIGIN
echo "8. Cloning dotfiles from $DOTFILES_ORIGIN"

# Installing tmux for productivity reasons
sudo pacman -S tmux
echo "9. Installing tmux via pacman"

# Symlink tmux config
ln -s $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf
echo "10. Linking tmux configuration from dotfiles"
