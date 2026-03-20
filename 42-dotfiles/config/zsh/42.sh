# Personal email config
export MAIL="srioboo-@student.42malaga.com"

# C execution funtions
ccse (){
  cc -Wall -Wextra -Werror *.c -o main -fsanitize=address -g && ./main
}

ccdg (){
  cc -Wall -Wextra -Werror *.c -o main -g && gdb ./main
}

cce (){
  cc -Wall -Wextra -Werror $1.c -o main && ./main $2
}

pw (){
	ARG=$1
	./push_swap $ARG | wc -l	
	./push_swap $ARG | ./checker_linux $ARG	
}

# C execution alias
alias cca="cc -Wall -Wextra -Werror"

# commands alias
alias ll="ls -l"

# Francinette relate alias
alias francinette=$HOME/francinette/tester.sh
alias paco=$HOME/francinette/tester.sh
alias lpaco="paco -in > log/gnl_$(date "+%Y%m%d%H%M%S").log"

# TODO change for utils::is_mac in the future
if [[ "$(uname)" = "Darwin" ]]; then
	alias norminette="/Users/salrio/Library/Python/3.9/bin/norminette"
fi
