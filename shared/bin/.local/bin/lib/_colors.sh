#!/usr/bin/env bash
# colors:: - Library for terminal colors and pretty printing
# Use: source lib/_colors.sh
#      colors::init
#      echo "${colors::red}Error message${colors::nc}"

# ============================================================================
# Color Code Variables
# ============================================================================

# Text modifiers
colors::nc=""              # No color (reset)
colors::bold=""            # Bold text
colors::reverse=""         # Reverse video
colors::underline=""       # Underlined text

# Foreground colors
colors::red=""
colors::red_bright=""
colors::green=""
colors::orange=""
colors::navy=""
colors::blue=""
colors::blue_bright=""
colors::aqua=""
colors::magenta=""
colors::gray=""
colors::white=""

# Background colors
colors::bg_red=""
colors::bg_green=""
colors::bg_orange=""
colors::bg_navy=""
colors::bg_blue=""
colors::bg_aqua=""
colors::bg_magenta=""
colors::bg_gray=""
colors::bg_white=""

# Combined modifiers
colors::bold_red=""
colors::bold_green=""
colors::bold_orange=""
colors::bold_magenta=""

# Message type colors
colors::warning=""         # PREFIX: WARNING:
colors::ok=""              # PREFIX: OK:
colors::error=""           # PREFIX: ERROR:
colors::note=""            # PREFIX: NOTE:

# ============================================================================
# Private Function: Initialize colors based on terminal capability
# ============================================================================

colors::_init_tput() {
	if tput setaf 1 &>/dev/null; then
		# Use tput for better compatibility
		colors::nc=$(tput sgr0)
		colors::bold=$(tput bold)
		colors::reverse=$(tput smso)
		colors::underline=$(tput smul)

		colors::red=$(tput setaf 9)
		colors::red_bright=$(tput setaf 1)
		colors::green=$(tput setaf 10)
		colors::orange=$(tput setaf 11)
		colors::navy=$(tput setaf 4)
		colors::blue=$(tput setaf 12)
		colors::blue_bright=$(tput setaf 12)
		colors::aqua=$(tput setaf 14)
		colors::magenta=$(tput setaf 13)
		colors::gray=$(tput setaf 8)
		colors::white=$(tput setaf 15)

		colors::bg_red=$(tput setab 9)
		colors::bg_green=$(tput setab 10)
		colors::bg_orange=$(tput setab 11)
		colors::bg_navy=$(tput setab 4)
		colors::bg_blue=$(tput setab 12)
		colors::bg_aqua=$(tput setab 14)
		colors::bg_magenta=$(tput setab 13)
		colors::bg_gray=$(tput setab 8)
		colors::bg_white=$(tput setab 15)
	fi
}

colors::_init_ansi() {
	# Fallback to ANSI escape codes
	colors::nc='\033[m'
	colors::bold='\033[0;1m'
	colors::reverse='\033[0;7m'
	colors::underline='\033[0;4m'

	colors::red='\033[1;31m'
	colors::red_bright='\033[1;31m'
	colors::green='\033[1;32m'
	colors::orange='\033[1;33m'
	colors::navy='\033[0;34m'
	colors::blue='\033[1;34m'
	colors::blue_bright='\033[1;34m'
	colors::aqua='\033[1;36m'
	colors::magenta='\033[1;35m'
	colors::gray='\033[1;30m'
	colors::white='\033[1;37m'

	colors::bg_red='\033[1;41m'
	colors::bg_green='\033[1;42m'
	colors::bg_orange='\033[1;43m'
	colors::bg_navy='\033[0;44m'
	colors::bg_blue='\033[1;44m'
	colors::bg_aqua='\033[1;46m'
	colors::bg_magenta='\033[1;45m'
	colors::bg_gray='\033[1;40m'
	colors::bg_white='\033[1;47m'
}

# ============================================================================
# Public Functions
# ============================================================================

# Initialize colors for the terminal
colors::init() {
	colors::_init_tput
	colors::_init_ansi

	# Setup message prefixes
	colors::warning="${colors::bold}${colors::orange}WARNING:${colors::nc}"
	colors::ok="${colors::green}✓ OK:${colors::nc}"
	colors::error="${colors::bold}${colors::red}✗ ERROR:${colors::nc}"
	colors::note="${colors::bold}${colors::blue}ℹ NOTE:${colors::nc}"
}

# Print available colors for demonstration
colors::print_all() {
	local x=1
	while [ $x -le 255 ]; do
		local color="$(tput bold; tput setaf "$x")"
		echo "${color}tput setaf $x${colors::nc}"
		((x++))
	done
}

# Print color palette
colors::print_palette() {
	echo -en "\n\n${colors::nc}"
	echo -e "${colors::bold}BOLD${colors::nc} ${colors::reverse}REVERSE${colors::nc} ${colors::underline}UNDERLINE${colors::nc}"
	echo -e "${colors::red}RED${colors::nc} ${colors::bg_red}RED_BG${colors::nc}"
	echo -e "${colors::green}GREEN${colors::nc} ${colors::bg_green}GREEN_BG${colors::nc}"
	echo -e "${colors::orange}ORANGE${colors::nc} ${colors::bg_orange}ORANGE_BG${colors::nc}"
	echo -e "${colors::navy}NAVY${colors::nc} ${colors::blue}BLUE${colors::nc} ${colors::aqua}AQUA${colors::nc}"
	echo -e "${colors::navy_bg}NAVY_BG${colors::nc} ${colors::bg_blue}BLUE_BG${colors::nc} ${colors::bg_aqua}AQUA_BG${colors::nc}"
	echo -e "${colors::magenta}MAGENTA${colors::nc} ${colors::bg_magenta}MAGENTA_BG${colors::nc}"
	echo -e "${colors::gray}GRAY${colors::nc} ${colors::white}WHITE${colors::nc} ${colors::bg_gray}GRAY_BG${colors::nc} ${colors::bg_white}WHITE_BG${colors::nc}\n"
}

# Auto-initialize on source (backward compatibility)
colors::init
