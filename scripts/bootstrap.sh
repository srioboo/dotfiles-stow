#!/usr/bin/env bash
set -e

OS=$(uname -s)
DOTFILES="$HOME/.dotfiles-stow"

install_deps_linux() {
  sudo apt-get install -y stow git zsh nvim   # o tu package manager
}

install_deps_macos() {
  # Instala Homebrew si no está
  command -v brew &>/dev/null || \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew bundle --file="$DOTFILES/macos/homebrew/Brewfile"
}

clone_dotfiles() {
  [ -d "$DOTFILES" ] || \
    git clone https://github.com/srioboo/dotfiles-stow.git "$DOTFILES"
}

clone_dotfiles

case "$OS" in
  Linux)  install_deps_linux ;;
  Darwin) install_deps_macos ;;
esac

# Aplica los symlinks
bash "$DOTFILES/scripts/stow.sh"
