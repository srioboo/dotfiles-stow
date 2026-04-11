#!/usr/bin/env bash

# exit if something go wrong
# set -eu

# source colors
source "_colors.sh"

# set dotfiles route
# export DOTFILES_42=$HOME/WORK/42/dotfiles-42/config
export DOTFILES_42=$HOME/.dotfiles-42
export DOTFILES_42_CONFIG=$DOTFILES_42/config
echo $DOTFILES_42_CONFIG

# create soft link
_create_link_soft()
{
    ln -sf "$1" "$2"
    if [ $? -ne 0 ]; then
        echo -e "${ERROR} creating symlink from ${ORANGE}$1 to ${MAGENTA}$2"
        exit 1
    else
        echo -e "${OK} Symlinks created at ${BLUE}$1 from ${ORANGE} $2"
    fi
}

# create soft links

# zsh
_create_link_soft $DOTFILES_42_CONFIG/zsh/zshrc $HOME/.zshrc

# tmux
_create_link_soft $DOTFILES_42_CONFIG/tmux/tmux.conf $HOME/.tmux.conf

# vim
_create_link_soft $DOTFILES_42_CONFIG/vim/vimrc $HOME/.vimrc

# code
_create_code_ln()
{
    if [[ "$(uname)" = "Darwin" ]]; then
        local VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
        ln -sf "$DOTFILES_42_CONFIG/Code/User/settings.json" "$VSCODE_USER_DIR/settings.json"
        _create_link_soft "$DOTFILES_42_CONFIG/Code/User/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
        echo -e "${OK} VS Code configuration linked for MacOs"
    else
        _create_link_soft $DOTFILES_42_CONFIG/Code/User/settings.json $HOME/.config/Code/User/settings.json
        _create_link_soft $DOTFILES_42_CONFIG/Code/User/snippets/{language}.json $HOME/.config/Code/User/{language}.json
        _create_link_soft $DOTFILES_42_CONFIG/Code/User/keybindings.json $HOME/.config/Code/User/keybindings.json
        echo -e "${OK} VS Code configuration linked for Linux"
    fi
}
_create_code_ln

# kitty
_create_link_soft $DOTFILES_42_CONFIG/kitty/kitty.conf $HOME/.config/kitty/kitty.conf

# lazygit
_create_link_soft $DOTFILES_42_CONFIG/lazygit $HOME/.config/lazygit

# waybar
_create_link_soft $DOTFILES_42_CONFIG/waybar $HOME/.config/waybar

# yazi
_create_link_soft $DOTFILES_42_CONFIG/yazi $HOME/.config/yazi

# show result
echo -e "${OK} Symlinks created:${BLUE}"
# find $HOME -type l -ls | grep $DOTFILES_42_CONFIG
