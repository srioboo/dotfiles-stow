#!/usr/bin/env bash
# utils:: - General utility functions library
# Use: source lib/_utils.sh
#      utils::is_mac && echo "Running on macOS"

# ============================================================================
# System Detection Functions
# ============================================================================

# Check if running on macOS
utils::is_mac() {
	[[ "$(uname)" == "Darwin" ]]
}

# Check if running on Linux
utils::is_linux() {
	[[ "$(uname)" == "Linux" ]]
}

# Check if running in a git repository
utils::in_git_repo() {
	git rev-parse --git-dir >/dev/null 2>&1
}

# ============================================================================
# Validation Functions
# ============================================================================

# Check if variable/parameter is set and not empty
# Usage: utils::require "VAR_NAME" "$VAR_VALUE"
utils::require() {
	local name="$1"
	local value="$2"
	
	if [[ -z "$value" ]]; then
		echo "${colors::error} Required variable not set: ${colors::blue}$name${colors::nc}"
		return 1
	fi
}

# Check if command exists
# Usage: utils::command_exists "git" || exit 1
utils::command_exists() {
	command -v "$1" >/dev/null 2>&1
}

# ============================================================================
# String Functions
# ============================================================================

# Convert string to lowercase
utils::to_lower() {
	echo "$1" | tr '[:upper:]' '[:lower:]'
}

# Convert string to uppercase
utils::to_upper() {
	echo "$1" | tr '[:lower:]' '[:upper:]'
}

# Trim whitespace from string
utils::trim() {
	local s="$1"
	s="${s#"${s%%[![:space:]]*}"}"
	s="${s%"${s##*[![:space:]]}"}"
	echo "$s"
}

# ============================================================================
# File/Path Functions
# ============================================================================

# Get absolute path of a file
# Usage: abs_path=$(utils::abspath "./config/file.txt")
utils::abspath() {
	local file="$1"
	if [[ -d "$file" ]]; then
		(cd "$file" && pwd)
	else
		(cd "$(dirname "$file")" && echo "$PWD/$(basename "$file")")
	fi
}

# Get directory of script being executed
utils::script_dir() {
	local source="${BASH_SOURCE[0]}"
	while [[ -L "$source" ]]; do
		local dir=$(cd -P "$(dirname "$source")" && pwd)
		source=$(readlink "$source")
		[[ $source != /* ]] && source="$dir/$source"
	done
	echo "$(cd -P "$(dirname "$source")" && pwd)"
}

# Check if path exists
utils::path_exists() {
	[[ -e "$1" ]]
}

# ============================================================================
# Array Functions
# ============================================================================

# Check if element exists in array
# Usage: if utils::in_array "item" "${array[@]}"; then echo "found"; fi
utils::in_array() {
	local needle="$1"
	shift
	local item
	for item in "$@"; do
		[[ "$item" == "$needle" ]] && return 0
	done
	return 1
}

# ============================================================================
# Exit Handlers
# ============================================================================

# Setup cleanup function to run on exit
# Usage: utils::on_exit cleanup_function
utils::on_exit() {
	local exit_func="$1"
	trap "$exit_func" EXIT
}

# Verbose output (for debugging)
# Usage: utils::debug "This is a debug message"
utils::debug() {
	if [[ "${DEBUG:-0}" == "1" ]]; then
		echo "[DEBUG] $*" >&2
	fi
}
