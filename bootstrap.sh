#!/usr/bin/env bash
set -e

# -------------------------------------------------
# CONFIGURATION
# -------------------------------------------------
DOTFILES_DIR="$HOME/.dotfiles-stow"

# These match your dotfiles modules
MODULES=(
    zsh
    ghostty
    nvim
)

# Arch packages needed for your setup
PACKAGES_ARCH=(
    stow
    omarchy-zsh
)

# AUR packages (installed via yay)
PACKAGES_AUR=(
)

BACKUP_SUFFIX=".bak.$(date +%s)"


# -------------------------------------------------
# Detect OS
# -------------------------------------------------
if [[ -f /etc/os-release ]]; then
    . /etc/os-release
fi


# -------------------------------------------------
# Install Required Packages
# -------------------------------------------------
install_packages() {
    echo "📦 Installing system packages…"

    if [[ "$ID" == "arch" ]]; then
        sudo pacman -Syu --noconfirm "${PACKAGES_ARCH[@]}"
    else
        echo "⚠️ This script is tuned for Omarchy (Arch)."
    fi
}


# -------------------------------------------------
# Install AUR Packages
# -------------------------------------------------
install_aur_packages() {
    if [[ ${#PACKAGES_AUR[@]} -eq 0 ]]; then
        return
    fi

    echo "📦 Installing AUR packages…"

    if ! command -v yay &>/dev/null; then
        echo "⚠️ yay not found. Skipping AUR packages: ${PACKAGES_AUR[*]}"
        echo "   Install yay first to enable AUR support."
        return
    fi

    yay -S --needed --noconfirm "${PACKAGES_AUR[@]}"
}


# -------------------------------------------------
# Install Oh My Zsh (user-only)
# -------------------------------------------------
install_ohmyzsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        echo "✨ Installing Oh My Zsh…"
        RUNZSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        echo "✔ Oh My Zsh already installed."
    fi
}


# -------------------------------------------------
# Install Oh My Zsh Plugins
# -------------------------------------------------
install_omz_plugin() {
    local name="$1"
    local repo="$2"
    local dest="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$name"

    if [[ ! -d "$dest" ]]; then
        echo "✨ Installing Oh My Zsh plugin: $name"
        git clone --depth=1 "$repo" "$dest"
    else
        echo "✔ Plugin already installed: $name"
    fi
}

install_omz_plugins() {
    install_omz_plugin "zsh-autosuggestions" \
        "https://github.com/zsh-users/zsh-autosuggestions"

    # Optional — uncomment to enable
    # install_omz_plugin "zsh-syntax-highlighting" \
    #     "https://github.com/zsh-users/zsh-syntax-highlighting"
    #
    # install_omz_plugin "fzf-tab" \
    #     "https://github.com/Aloxaf/fzf-tab"
}


# -------------------------------------------------
# Setup Omarchy Zsh
# -------------------------------------------------
setup_omarchy_zsh() {
    if [[ "$SHELL" != "$(command -v zsh)" ]]; then
        echo "🐚 Configuring Omarchy's Zsh…"
        sudo omarchy-setup-zsh
    else
        echo "✔ Zsh already the default shell."
    fi
}


# -------------------------------------------------
# Backup Conflicts for Stow
# -------------------------------------------------
backup_file() {
    local path="$1"
    if [[ -e "$path" ]]; then
        local backup="${path}${BACKUP_SUFFIX}"
        echo "🔐 Backing up $path → $backup"
        mv "$path" "$backup"
    fi
}

backup_conflicts() {
    local module="$1"
    echo "🔍 Checking for conflicts in module: $module"

    cd "$DOTFILES_DIR"

    # Detect conflicts via stow dry-run
    local conflicts
    conflicts=$(stow -nv "$module" 2>&1 | grep -o "over existing target [^ ]*" | awk '{print $4}' || true)

    for file in $conflicts; do
        backup_file "$HOME/$file"
    done
}


# -------------------------------------------------
# Stow Dotfile Modules
# -------------------------------------------------
stow_modules() {
    echo "🔗 Stowing dotfile modules…"
    cd "$DOTFILES_DIR"

    for module in "${MODULES[@]}"; do
        backup_conflicts "$module"
        echo "📁 Stowing $module"
        stow "$module"
    done
}


# -------------------------------------------------
# Run Everything
# -------------------------------------------------
echo "🚀 Bootstrapping your Omarchy + Zsh + Dotfiles environment…"

#install_packages
#install_aur_packages
#install_ohmyzsh
#install_omz_plugins
#setup_omarchy_zsh
stow_modules

echo ""
echo "🎉 Dotfiles successfully bootstrapped!"
echo "➡️ Restart your terminal for all changes to apply."
