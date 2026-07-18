# 📚 Bash Best Practices Guide

Professional patterns and conventions for shell scripts in this repository.

## 🏗️ Script Structure

### Header and Shebang

```bash
#!/usr/bin/env bash
# my-script: Brief one-line description
# Longer description if needed

set -euo pipefail  # Strict mode
```

### Setup Section

```bash
# ============================================================================
# Script Setup
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/../lib"

# Source libraries with error handling
source "${LIB_DIR}/_colors.sh" || exit 1
source "${LIB_DIR}/_validation.sh" || exit 1
```

### Organized Sections

Use comment headers for clarity:

```bash
# ============================================================================
# Configuration
# ============================================================================

CONFIG_FILE="${CONFIG_FILE:-$HOME/.config/app.conf}"
TIMEOUT="${TIMEOUT:-30}"

# ============================================================================
# Functions
# ============================================================================

main_function() {
	# ...
}

helper_function() {
	# ...
}

# ============================================================================
# Main Execution
# ============================================================================

main_function "$@"
```

## ⚙️ Strict Mode

Always use strict mode in scripts:

```bash
set -euo pipefail
```

- **`-e`**: Exit immediately on error
- **`-u`**: Error on undefined variable
- **`-o pipefail`**: Pipe failure fails entire pipeline

Default variables with safer methods:

```bash
# Good - won't error even if VAR is undefined
VALUE="${VAR:-default}"

# Also good
if [[ -z "${VAR:-}" ]]; then
    echo "VAR not set"
fi

# Avoid - will error in strict mode if undefined
VALUE="$VAR"  # ❌ DON'T DO THIS
```

## 📝 Variable Naming

- **Script variables**: `UPPER_CASE`
- **Function variables**: `lower_case`
- **Library variables**: `namespace::lower_case`
- **Readonly values**: `readonly CONSTANT_NAME`

```bash
# Script-level configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly TIMEOUT=30

# Function parameters and locals
my_function() {
	local result=""
	local counter=0
}
```

## 🔧 String Handling

### Quoting

Always quote variables unless you need word splitting:

```bash
# Good
echo "$var"
cp "$source_file" "$dest_file"

# Avoid unless intentional
echo $var          # ❌ Vulnerable to word splitting
local arr=$items   # ❌ Will lose array structure
```

### String Operations

Use modern bash syntax:

```bash
# Parameter expansion - preferred
result="${string#prefix}"      # Remove prefix
result="${string%suffix}"      # Remove suffix
result="${string/old/new}"     # Replace

# Avoid command substitution for simple operations
# ❌ result="$(echo "$string" | sed -e 's/x/y/')"
# ✅ result="${string/x/y}"
```

### Trimming Whitespace

```bash
# Using parameter expansion (preferred)
utils::trim() {
	local s="$1"
	s="${s#"${s%%[![:space:]]*}"}"
	s="${s%"${s##*[![:space:]]}"}"
	echo "$s"
}
```

## 🎯 Conditions and Tests

### Prefer [[ ]] over [ ]

```bash
# Good - modern, more features
if [[ "$string" == pattern* ]]; then
	true
fi

# Avoid - old style
if [ "$string" = "value" ]; then
	true
fi
```

### Test Patterns

```bash
# String tests
[[ -z "$string" ]]           # Empty?
[[ -n "$string" ]]           # Not empty?
[[ "$a" == "$b" ]]           # Equal?
[[ "$a" != "$b" ]]           # Not equal?
[[ "$string" =~ ^regex$ ]]   # Regex match?

# File tests
[[ -e "$file" ]]             # Exists?
[[ -f "$file" ]]             # Regular file?
[[ -d "$dir" ]]              # Directory?
[[ -r "$file" ]]             # Readable?
[[ -w "$file" ]]             # Writable?
[[ -x "$file" ]]             # Executable?
[[ -L "$link" ]]             # Symlink?

# Numeric tests
(( num > 10 ))               # Greater than?
(( num >= 10 ))              # Greater than or equal?
(( num < 10 ))               # Less than?
(( num == 10 ))              # Equal?

# Logic
[[ "$a" == "x" && "$b" == "y" ]]  # AND
[[ "$a" == "x" || "$b" == "y" ]]  # OR
[[ ! "$a" == "x" ]]               # NOT
```

## 🔄 Loops

### While Loop

```bash
while IFS= read -r line; do
	echo "Line: $line"
done < "$file"
```

### For Loop

```bash
# Over array
for item in "${array[@]}"; do
	echo "$item"
done

# Range (bash 4+)
for i in {1..10}; do
	echo "$i"
done

# Using C-style syntax
for (( i=0; i<10; i++ )); do
	echo "$i"
done
```

### Iterate with Index

```bash
for i in "${!array[@]}"; do
	echo "[$i]=${array[i]}"
done
```

## 📦 Arrays

### Declaration and Usage

```bash
# Indexed array
declare -a indexed=("one" "two" "three")

# Associative array
declare -A assoc=([name]="value" [key]="data")

# Append
indexed+=("four")

# Get element
echo "${indexed[0]}"           # First element
echo "${indexed[-1]}"  # Last element (bash 4.3+)

# All elements
echo "${indexed[@]}"           # All items
echo "${indexed[*]}"           # All items as single string - avoid usually

# Length
echo "${#indexed[@]}"          # Array length

# Slice (bash 4.3+)
slice=("${indexed[@]:1:2}")    # Start at 1, take 2 items
```

## 🛡️ Error Handling

### Exit Codes

```bash
# Always check exit code
if some_command; then
	echo "Success"
else
	echo "Failed with code: $?"
fi

# Define meaningful exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_INVALID_ARG=1
readonly EXIT_FILE_NOTFOUND=2
readonly EXIT_PERMISSION=3
```

### Function Return Codes

```bash
# Good - returns 0 on success, 1 on failure
my_function() {
	if condition_met; then
		return 0
	else
		return 1
	fi
}

if my_function; then
	echo "Function succeeded"
fi
```

### Trap Errors

```bash
# Cleanup on exit
cleanup() {
	[[ -n "${temp_file:-}" ]] && rm -f "$temp_file"
	echo "Cleaned up"
}

trap cleanup EXIT
trap 'echo "Error at line $LINENO"' ERR
```

## 📚 Functions

### Function Definition

```bash
# Preferred style
my_function() {
	# Function body
	local var="$1"
	return 0
}

# Alternative (same meaning)
function my_function {
	# Function body
	return 0
}
```

### Parameters and Return

```bash
# Single parameter
process_file() {
	local file="$1"
	
	if [[ ! -f "$file" ]]; then
		echo "File not found: $file" >&2
		return 1
	fi
	
	# Process file
	return 0
}

# Multiple parameters with validation
create_link() {
	local source="$1"
	local target="$2"
	
	[[ -n "${source:-}" ]] || return 1
	[[ -n "${target:-}" ]] || return 1
	
	ln -s "$source" "$target"
}

# Usage
if create_link "/source" "/target"; then
	echo "Success"
else
	echo "Failed"
	return 1
fi
```

### Named Parameters Pattern

For complex functions with many parameters:

```bash
parse_args() {
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-f|--file)
				file="$2"
				shift 2
				;;
			-v|--verbose)
				verbose=1
				shift
				;;
			*)
				echo "Unknown option: $1"
				return 1
				;;
		esac
	done
}

# Usage
parse_args -f myfile.txt -v
```

## 📘 I/O and Output

### Error Messages

Send errors to stderr:

```bash
# Good
echo "Error happened" >&2
echo -e "${colors::error} Something went wrong" >&2

# Avoid
echo "Error happened"  # ❌ Goes to stdout
```

### Quiet Mode Pattern

```bash
# Support quiet/verbose flags
if [[ "${VERBOSE:-0}" == "1" ]]; then
	echo "Detailed output"
fi

# Usage
VERBOSE=1 ./script.sh

# Or with function
log() {
	if [[ "${VERBOSE:-0}" == "1" ]]; then
		echo "$@"
	fi
}

log "This shows in verbose mode"
```

### Reading Input

```bash
# Read line by line preserving whitespace
while IFS= read -r line; do
	process "$line"
done < "$file"

# Read into array
mapfile -t lines < "$file"
for line in "${lines[@]}"; do
	process "$line"
done

# Interactive input
read -p "Enter value: " -r user_input
```

## 🔍 Debugging

### Debug Mode

```bash
# Enable with set -x
if [[ "${DEBUG:-0}" == "1" ]]; then
	set -x
fi

# Or use PS4 for better output
export PS4='[${BASH_SOURCE}:${LINENO}] ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
set -x

# Usage
DEBUG=1 ./script.sh
```

### Echo Debugging

```bash
# Conditional debug output
debug() {
	if [[ "${DEBUG:-0}" == "1" ]]; then
		echo "[DEBUG] $*" >&2
	fi
}

debug "Variable value: $value"
```

### Check if Running Interactively

```bash
# Good for scripts that might be sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	# Script is being executed, not sourced
	main "$@"
fi
```

## 🎯 Common Patterns

### Check Multiple Conditions

```bash
# Good
if [[ "$file_exists" == "1" && "$is_readable" == "1" ]]; then
	process_file
fi

# Also good
if [[ -f "$file" && -r "$file" ]]; then
	process_file
fi
```

### Iterate Through Arguments

```bash
# Process all arguments
for arg in "$@"; do
	echo "Processing: $arg"
done

# Or manually
while [[ $# -gt 0 ]]; do
	process "$1"
	shift
done
```

### Safe Temporary Files

```bash
# Create temp file safely
temp_file=$(mktemp)
trap 'rm -f "$temp_file"' EXIT

# Use temp file
data > "$temp_file"
cat "$temp_file"
```

### Default Values

```bash
# Use parameter expansion for defaults
output_dir="${OUTPUT_DIR:-.}"
log_level="${LOG_LEVEL:-INFO}"
config_file="${CONFIG_FILE:-$HOME/.config/app.conf}"
```

## 🚫 Common Mistakes to Avoid

```bash
# ❌ Don't quote in [ ] tests incorrectly
[ -f "$file" ]         # ✓ Good
[ -f test file ]       # ❌ Wrong - splits

# ❌ Don't use command substitution for arithmetic
(( result = 5 + 3 ))   # ✓ Good
result=$(( 5 + 3 ))    # ✓ Also good
result=$((5+3))        # ✓ Also good
result=`expr 5 + 3`    # ❌ Outdated

# ❌ Don't assume success
output=$(some_command)       # ✓ With set -e
output=$(some_command) &&... # ✓ Or explicit check

# ❌ Don't use find without -print0
find . -name "*.txt" | xargs -v rm    # ❌ Breaks with spaces
find . -name "*.txt" -print0 | xargs -0 rm  # ✓ Good

# ❌ Don't hardcode paths
/usr/bin/bash           # ❌ Avoid
#!/usr/bin/env bash     # ✓ Portable
```

## 📚 References and Resources

- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck](https://www.shellcheck.net/) - Static analysis tool
- [Bash Manual](https://www.gnu.org/software/bash/manual/)
