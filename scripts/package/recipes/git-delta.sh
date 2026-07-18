#!/usr/bin/env bash

git-delta::install() {
	"$DOTFILES/bin/dot" package add git-delta --skip-recipe
}

git-delta::is_installed() {
	platform::command_exists delta
}
