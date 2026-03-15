#!/usr/bin/env bash
set -e

DOTFILES="$HOME/.dotfiles-stow"
OS=$(uname -s)
LEVEL=--verbose=0


# -------------------------------------------------
# Functions
# -------------------------------------------------
stow_pkg() {
  # echo "stow -d $1 -t $HOME $2"
  stow -d "$1" -t "$HOME" "$2" $LEVEL
}

# -------------------------------------------------
# Stow Dotfile Modules
# -------------------------------------------------
stow_modules() {
    echo "🔗 Stowing dotfile modules in $2"
    # cd "$DOTFILES_DIR"

    for module in $(find "$1/$2" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;); do
        # backup_conflicts "$module"
        echo "  📁 Stowing $module"
        stow_pkg "$1/$2" "$module"
        # stow "$module"
    done
}

# Siempre se aplica lo compartido
stow_modules "$DOTFILES" shared

# Configuración específica por OS
case "$OS" in
  Linux)
    stow_modules "$DOTFILES" linux
    ;;
  Darwin)
    stow_modules "$DOTFILES" macos 
    ;;
  *)
    echo "OS no reconocido: $OS"
    exit 1
    ;;
esac

echo "Dotfiles aplicados correctamente en $OS"
