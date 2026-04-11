#!/usr/bin/env bash

set -euo pipefail

source "_colors.sh"

printf "${RED}Hola mundo!!!"

print_colors

source "_utils.sh"
utils::is_mac