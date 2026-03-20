#!/bin/sh

# stop at errors
set -e 

# configure git alias
config_git_alias()
{
	git config --global alias.branches "branch -a";
	git config --global alias.brs "branch -a";
	git config --global alias.br "branch";
	git config --global alias.co "checkout";
	# git config --global alias.ci commit;
	git config --global alias.st "status";

	## logs
	# View abbreviated SHA, description, and history graph of the latest 20 commits
	git config --global alias.l "log --pretty=oneline -n 20 --graph --abbrev-commit"
	git config --global alias.ls "log --oneline --graph";
	# Other abreviated log
	# git config --global alias.slog "log --graph --all --topo-order --pretty='format:%C(blue) %h %C(red) %ai %C(reset) %s%d (%an)'"
	git config --global alias.slog "log --graph --all --topo-order --pretty='format:%C(green)%h %C(red) %ai %C(reset) %s%C(yellow)%d %C(blue) (%an)'"	
	# Color graph log view
	git config --global alias.graph "log --graph --color --pretty=format:'%C(yellow)%H%C(green)%d%C(reset)%n%x20%cd%n%x20%cn%x20(%ce)%n%x20%s%n'"
	git config --global alias.lg "log --color --decorate --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an (%G?)>%Creset' --abbrev-commit"
	git config --global alias.lgs "log --color --decorate --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an (%G?)> - %ae%Creset' --abbrev-commit"
}

pt_config_git_alias()
{
	git config --global --list | grep alias;
}

# launch
config_git_alias

# after launch info
pt_config_git_alias
