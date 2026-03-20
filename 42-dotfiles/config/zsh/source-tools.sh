# This is for source tools as bun, npm, go, etc

# colors for the terminal
source $DOTFILES_42/scripts/_colors.sh
source $DOTFILES_42/scripts/_utils.sh

# bun and bun completions
# install: curl -fsSL https://bun.sh/install | bash
function source_bun()
{
	if  [ -s "$HOME/.bun/_bun" ]
	then
		source "$HOME/.bun/_bun"
		export BUN_INSTALL="$HOME/.bun"
		export PATH="$BUN_INSTALL/bin:$PATH"
	else
		printf "${WARNING} bun is not present at $HOME/.bun"
	fi
}

# node version manager (nvm)
# install: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
function source_nvm()
{
	# export NVM_DIR=~/.nvm
 	#	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
	if [ utils::is_mac ]; then
		export NVM_DIR="/opt/homebrew/opt/nvm"
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
		[ -s "$NVM_DIR/etc/bash_completion.d/nvm" ] && \. "$NVM_DIR/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
	else
		export NVM_DIR="$HOME/.nvm"
		[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
		[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
	fi
}

# go language
# install: https://go.dev/doc/install
function source_go()
{
	export PATH=$PATH:/usr/local/go/bin
}

# rust language and cargo
# install: curl https://sh.rustup.rs -sSf | sh
function source_cargo()
{
	if  [ -s "$HOME/.cargo/env" ]
	then	
		. "$HOME/.cargo/env"
	else
		printf "${WARNING} cargo is not present at $HOME/.cargo"
	fi
}

# brew
function source_brew()
{
	if [ ! utils::is_mac ]; then
		eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	fi
}

# sdk man
function source_sdkman()
{
	export SDKMAN_DIR="$HOME/.sdkman"
	[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
}
