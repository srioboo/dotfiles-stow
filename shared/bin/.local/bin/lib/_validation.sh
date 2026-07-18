#!/usr/bin/env bash
# validation:: - Input validation library
# Use: source lib/_validation.sh
#      validation::is_empty "name" && exit 1

source "$(dirname "${BASH_SOURCE[0]}")/_colors.sh" || exit 1

# ============================================================================
# String Validation
# ============================================================================

# Check if string is empty
validation::is_empty() {
	local string="$1"
	[[ -z "$string" ]]
}

# Check if string is not empty
validation::not_empty() {
	local string="$1"
	[[ -n "$string" ]]
}

# Check if string is alphanumeric
validation::is_alphanumeric() {
	local string="$1"
	[[ "$string" =~ ^[a-zA-Z0-9]+$ ]]
}

# Check if string matches regex pattern
# Usage: validation::matches "value" "^[a-z]+$"
validation::matches() {
	local string="$1"
	local pattern="$2"
	[[ "$string" =~ $pattern ]]
}

# ============================================================================
# Numeric Validation
# ============================================================================

# Check if value is an integer
validation::is_integer() {
	local value="$1"
	[[ "$value" =~ ^[0-9]+$ ]]
}

# Check if value is a positive integer
validation::is_positive() {
	local value="$1"
	validation::is_integer "$value" && (( value > 0 ))
}

# Check if value is within range
# Usage: validation::in_range "5" "1" "10"
validation::in_range() {
	local value="$1"
	local min="$2"
	local max="$3"
	
	validation::is_integer "$value" || return 1
	validation::is_integer "$min" || return 1
	validation::is_integer "$max" || return 1
	
	(( value >= min && value <= max ))
}

# ============================================================================
# Path Validation
# ============================================================================

# Check if path exists and is readable
validation::path_readable() {
	local path="$1"
	[[ -r "$path" ]]
}

# Check if path exists and is a directory
validation::is_directory() {
	local path="$1"
	[[ -d "$path" ]]
}

# Check if path exists and is a file
validation::is_file() {
	local path="$1"
	[[ -f "$path" ]]
}

# Check if path exists and is a symlink
validation::is_symlink() {
	local path="$1"
	[[ -L "$path" ]]
}

# ============================================================================
# Environment Validation
# ============================================================================

# Check if environment variable is set
validation::env_exists() {
	local var_name="$1"
	[[ -n "${!var_name}" ]]
}

# Check if command/executable exists in PATH
validation::command_exists() {
	command -v "$1" >/dev/null 2>&1
}

# ============================================================================
# Email & URL Validation
# ============================================================================

# Check if string is a valid email
validation::is_email() {
	local email="$1"
	local pattern='^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
	[[ "$email" =~ $pattern ]]
}

# Check if string is a valid URL
validation::is_url() {
	local url="$1"
	local pattern='^https?://.*'
	[[ "$url" =~ $pattern ]]
}

# ============================================================================
# Assertion Functions (for error handling)
# ============================================================================

# Assert that condition is true, exit if false
# Usage: validation::assert_not_empty "$var" "Variable cannot be empty"
validation::assert() {
	local condition="$1"
	local message="${2:-Assertion failed}"
	
	if ! eval "$condition"; then
		echo -e "${colors::error} ${colors::bold}$message${colors::nc}" >&2
		return 1
	fi
}

# Assert that variable is not empty
# Usage: validation::assert_not_empty "var_name" "Variable description"
validation::assert_not_empty() {
	local var_name="$1"
	local description="${2:-$var_name}"
	local var_value="${!var_name}"
	
	if validation::is_empty "$var_value"; then
		echo -e "${colors::error} Required parameter missing: ${colors::blue}$description${colors::nc}" >&2
		return 1
	fi
}

# Assert that specified file exists
# Usage: validation::assert_file_exists "filepath" "Config file"
validation::assert_file_exists() {
	local filepath="$1"
	local description="${2:-File}"
	
	if [[ ! -f "$filepath" ]]; then
		echo -e "${colors::error} ${description} not found: ${colors::blue}$filepath${colors::nc}" >&2
		return 1
	fi
}

# Assert that specified directory exists
# Usage: validation::assert_dir_exists "dirpath" "Config directory"
validation::assert_dir_exists() {
	local dirpath="$1"
	local description="${2:-Directory}"
	
	if [[ ! -d "$dirpath" ]]; then
		echo -e "${colors::error} ${description} not found: ${colors::blue}$dirpath${colors::nc}" >&2
		return 1
	fi
}
