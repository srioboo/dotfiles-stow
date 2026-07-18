#!/usr/bin/env bash

docpars::install() {
	platform::command_exists brew && brew install denisidoro/tools/docpars && return 0 || true

	script::depends_on cargo

	"$DOTFILES/bin/dot" package add docpars --skip-recipe
}

docpars::is_installed() {
	platform::command_exists docpars
}
