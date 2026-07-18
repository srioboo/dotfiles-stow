dotfiles::list_bash_files() {
	grep "#!/usr/bin/env bash" "$DOTFILES"/{bin,scripts,shell} -R | awk -F':' '{print $1}'
	find "$DOTFILES"/{bin,scripts,shell} -type f -name "*.sh"
}
