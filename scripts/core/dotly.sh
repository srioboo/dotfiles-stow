dotly::list_bash_files() {
	grep "#!/usr/bin/env bash" "$DOTFILES"/{bin,dotfiles_template,scripts,shell,installer,restorer} -R | awk -F':' '{print $1}'
	find "$DOTFILES"/{bin,dotfiles_template,scripts,shell} -type f -name "*.sh"
}
