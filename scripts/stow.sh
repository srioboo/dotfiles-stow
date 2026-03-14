#!/usr/bin/env bash
set -e

DOTFILES="$HOME/.dotfiles-stow"
OS=$(uname -s)

# Siempre se aplica lo compartido
stow -d "$DOTFILES" -t "$HOME" shared

# Configuración específica por OS
case "$OS" in
  Linux)
    stow -d "$DOTFILES" -t "$HOME" linux
    ;;
  Darwin)
    stow -d "$DOTFILES" -t "$HOME" macos
    ;;
  *)
    echo "OS no reconocido: $OS"
    exit 1
    ;;
esac

echo "Dotfiles aplicados correctamente en $OS"
