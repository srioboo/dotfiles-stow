#!/usr/bin/env bash
# fs:: - File system operations library
# Use: source lib/_fs.sh
#      fs::create_symlink "$source" "$target"

# Source colors for error messages
source "$(dirname "${BASH_SOURCE[0]}")/_colors.sh" || exit 1

# ============================================================================
# Symbolic Link Functions
# ============================================================================

# Create a symbolic link with error handling
# Usage: fs::create_symlink "/path/to/source" "/path/to/link"
fs::create_symlink() {
	local source="$1"
	local target="$2"
	
	if [[ -z "$source" ]] || [[ -z "$target" ]]; then
		echo -e "${colors::error} Missing arguments for fs::create_symlink"
		return 1
	fi
	
	# Check if source exists
	if [[ ! -e "$source" ]]; then
		echo -e "${colors::error} Source does not exist: ${colors::blue}$source${colors::nc}"
		return 1
	fi
	
	# Remove existing target if it exists
	if [[ -L "$target" ]] || [[ -e "$target" ]]; then
		rm -f "$target" || {
			echo -e "${colors::error} Could not remove existing target: ${colors::blue}$target${colors::nc}"
			return 1
		}
	fi
	
	# Create parent directory if needed
	local target_dir="$(dirname "$target")"
	if [[ ! -d "$target_dir" ]]; then
		mkdir -p "$target_dir" || {
			echo -e "${colors::error} Could not create directory: ${colors::blue}$target_dir${colors::nc}"
			return 1
		}
	fi
	
	# Create the symlink
	if ln -sf "$source" "$target"; then
		echo -e "${colors::ok} Symlink created: ${colors::blue}$target${colors::nc} -> ${colors::green}$source${colors::nc}"
		return 0
	else
		echo -e "${colors::error} Failed to create symlink: ${colors::blue}$target${colors::nc}"
		return 1
	fi
}

# Remove symbolic link
# Usage: fs::remove_symlink "/path/to/link"
fs::remove_symlink() {
	local link="$1"
	
	if [[ ! -L "$link" ]]; then
		echo -e "${colors::warning} Not a symlink: ${colors::blue}$link${colors::nc}"
		return 1
	fi
	
	if rm -f "$link"; then
		echo -e "${colors::ok} Symlink removed: ${colors::blue}$link${colors::nc}"
		return 0
	else
		echo -e "${colors::error} Failed to remove symlink: ${colors::blue}$link${colors::nc}"
		return 1
	fi
}

# ============================================================================
# Directory Functions
# ============================================================================

# Ensure directory exists
# Usage: fs::ensure_dir "/path/to/directory"
fs::ensure_dir() {
	local dir="$1"
	
	if [[ ! -d "$dir" ]]; then
		if mkdir -p "$dir"; then
			echo -e "${colors::ok} Directory created: ${colors::blue}$dir${colors::nc}"
			return 0
		else
			echo -e "${colors::error} Failed to create directory: ${colors::blue}$dir${colors::nc}"
			return 1
		fi
	fi
}

# Check if directory exists and is writable
# Usage: fs::is_writable "/path/to/directory"
fs::is_writable() {
	local dir="$1"
	
	if [[ ! -d "$dir" ]]; then
		return 1
	fi
	
	if [[ -w "$dir" ]]; then
		return 0
	else
		return 1
	fi
}

# ============================================================================
# File Check Functions
# ============================================================================

# Check if file exists and is readable
# Usage: fs::is_readable "/path/to/file"
fs::is_readable() {
	[[ -f "$1" && -r "$1" ]]
}

# Check if file exists and is executable
# Usage: fs::is_executable "/path/to/file"
fs::is_executable() {
	[[ -f "$1" && -x "$1" ]]
}

# Get file size in human-readable format
# Usage: size=$(fs::get_size "/path/to/file")
fs::get_size() {
	local file="$1"
	
	if [[ ! -f "$file" ]]; then
		echo "0B"
		return 1
	fi
	
	# Use ls for cross-platform compatibility
	ls -lh "$file" | awk '{print $5}'
}

# ============================================================================
# Backup Functions
# ============================================================================

# Create a backup of a file
# Usage: fs::backup "/path/to/file"
fs::backup() {
	local file="$1"
	local backup="${file}.backup"
	
	if [[ ! -e "$file" ]]; then
		echo -e "${colors::warning} File does not exist: ${colors::blue}$file${colors::nc}"
		return 1
	fi
	
	# Find available backup name if needed
	local counter=1
	while [[ -e "$backup" ]]; do
		backup="${file}.backup.$counter"
		((counter++))
	done
	
	if cp -p "$file" "$backup"; then
		echo -e "${colors::ok} Backup created: ${colors::blue}$backup${colors::nc}"
		return 0
	else
		echo -e "${colors::error} Failed to backup file: ${colors::blue}$file${colors::nc}"
		return 1
	fi
}
