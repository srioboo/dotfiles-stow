#!/usr/bin/env bash

set -euo pipefail

##? Setups the environment
##?
##? Usage:
##?    restorer [-c | --continue]
##?
##? Options:
##?    -h --help      Prints this help
##?    -v --version   Prints this script version
##?    -c --continue  Continue previous install without cloning again your
##?                   dotfiles if they exists. Useful if previous restore fails.
##?

# Script variables
SCRIPT_NAME="Dotly dotfiles recovery"
SCRIPT_VERSION="v1.0.0"

# Default values
continue=false

# Arguments
while [[ $# -gt 0 ]]; do
	case "$1" in
	--help | -h)
		cat <<EOF
Usage:
   install [-c | --continue]

Options:
   -h --help      Prints this help
   -v --version   Prints this script version
   -c --continue  Continue previous install withour cloning again your
                  dotfiles if they exists. Useful if previous restore fails.

EOF
		exit 0
		;;
	--version | -v)
		echo "$SCRIPT_NAME $SCRIPT_VERSION"
		echo
		exit 0
		;;
	--continue | -c)
		continue=true
		;;
	*) ;;

	esac
done

DOTLY_LOG_FILE=${DOTLY_LOG_FILE:-$HOME/dotly.log}
export DOTLY_ENV=${DOTLY_ENV:-PROD}
export DOTLY_INSTALLER=true

red='\033[0;31m'
green='\033[0;32m'
purple='\033[0;35m'
normal='\033[0m'
