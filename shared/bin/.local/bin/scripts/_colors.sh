# no color and variations variables
NC=""
BOLD=""
REVERSE=""
UNDERLINE=""

# colors variables
RED=""
B_RED=""
GREEN=""
ORANGE=""
NAVY=""
BLUE=""
AQUA=""
MAGENTA=""
GRAY=""
WHITE=""

RED_BG=""
GREEN_BG=""
ORANGE_BG=""
NAVY_BG=""
BLUE_BG=""
AQUA_BG=""
MAGENTA_BG=""
GRAY_BG=""
WHITE_BG=""

# messages colors variables
WARNING=""
OK=""
ERROR=""
NOTE=""

# function to activate colors
activate_color() {
	if tput setaf 1 &> /dev/null; then
		tput sgr0
		NC=$(tput sgr0)
		BOLD=$(tput bold)
		REVERSE=$(tput smso)
		UNDERLINE=$(tput smul)

		RED=$(tput setaf 9)
		GREEN=$(tput setaf 10)
		ORANGE=$(tput setaf 11)
		NAVY=$(tput setaf 4)
		BLUE=$(tput setaf 12)
		AQUA=$(tput setaf 14)
		MAGENTA=$(tput setaf 13)
		GRAY=$(tput setaf 8)
		WHITE=$(tput setaf 15)

		RED_BG=$(tput setab 9)
		GREEN_BG=$(tput setab 10)
		ORANGE_BG=$(tput setab 11)
		NAVY_BG=$(tput setab 4)
		BLUE_BG=$(tput setab 12)
		AQUA_BG=$(tput setab 14)
		MAGENTA_BG=$(tput setab 13)
		GRAY_BG=$(tput setab 8)
		WHITE_BG=$(tput setab 15)
	else
		NC='\033[m'
		BOLD='\033[0;1m'
		REVERSE='\033[0;7m'
		UNDERLINE='\033[0;4m'

		RED='\033[1;31m'
		GREEN='\033[1;32m'
		ORANGE='\033[1;33m'
		NAVY='\033[0;34m'
		BLUE='\033[1;34m'
		AQUA='\033[1;36m'
		MAGENTA='\033[1;35m'
		GRAY='\033[1;30m'
		WHITE='\033[1;37m'

		RED_BG='\033[1;41m'
		GREEN_BG='\033[1;42m'
		ORANGE_BG='\033[1;43m'
		NAVY_BG='\033[0;44m'
		BLUE_BG='\033[1;44m'
		AQUA_BG='\033[1;46m'
		MAGENTA_BG='\033[1;45m'
		GRAY_BG='\033[1;40m'
		WHITE_BG='\033[1;47m'
	fi

	BRED="${BOLD}${RED}"
	BGREEN="${BOLD}${GREEN}"
	BORANGE="${BOLD}${ORANGE}"
	BMAGENTA="${BOLD}${MAGENTA}"
	BBLUE="${BOLD}${NAVY}"
	WARNING="${BORANGE}WARNING:${NC}"
	OK="${GREEN}OK:${NC}"
	ERROR="${BRED}ERROR:${NC}"
	NOTE="${BBLUE}NOTE:${NC}"
}

# print colors
print_colors() {
	echo -en "\n\n${NC}"
	echo -e "${BOLD}BOLD${NC}		${REVERSE}REVERSE${NC}		${UNDERLINE}UNDERLINE${NC}"
	echo -e "${RED}RED${NC}		${RED_BG}RED_BG${NC}"
	echo -e "${GREEN}GREEN${NC}		${GREEN_BG}GREEN_BG${NC}"
	echo -e "${ORANGE}ORANGE${NC}		${ORANGE_BG}ORANGE_BG${NC}"
	echo -e "${NAVY}NAVY${NC}		${BLUE}BLUE${NC}		${AQUA}AQUA${NC}"
	echo -e "${NAVY_BG}NAVY_BG${NC}		${BLUE_BG}BLUE_BG${NC}		${AQUA_BG}AQUA_BG${NC}"
	echo -e "${MAGENTA}MAGENTA${NC}		${MAGENTA_BG}MAGENTA_BG${NC}"
	echo -e "${GRAY}GRAY${NC}		${WHITE}WHITE${NC}		${GRAY_BG}GRAY_BG${NC}		${WHITE_BG}WHITE_BG${NC}"
}

TEST_COLORS=$(print_colors)

print_all() {
	x=1
	while [ $x -le 255 ]
	do
		color="$(tput bold; tput setaf $x)"
		echo "${color}tput setaf $x${reset}"
		x=$(( $x + 1 ))
	done
}

activate_color
