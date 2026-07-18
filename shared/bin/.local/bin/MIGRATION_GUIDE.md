# 🔄 Migration Guide: Converting Scripts to New Structure

Guide for converting existing scripts to use the new organized library/executable structure.

## Overview

**Before**: Scripts scattered, no clear libraries
**After**: Libraries in `lib/`, executables in `bin/`, clear namespaces

## Step-by-Step Migration

### Step 1: Identify Script Type

Determine if your script is a:
- **Library** (meant to be sourced): Move to `lib/_name.sh`
- **Executable** (meant to run): Move to `bin/name` (no .sh)

### Step 2: Add Namespace to Libraries

**Before**:
```bash
# _mylib.sh
my_function() {
	echo "Hello"
}

SOME_VAR="value"
```

**After**:
```bash
#!/usr/bin/env bash
# mylib:: - Library description
# Use: source lib/_mylib.sh

# ============================================================================
# Public Functions
# ============================================================================

mylib::my_function() {
	echo "Hello"
}

# ============================================================================
# Variables
# ============================================================================

mylib::SOME_VAR="value"
```

### Step 3: Extract Common Code to Libraries

If you have code repeated across scripts, move it to a library:

**Before** (in multiple scripts):
```bash
#!/bin/bash
if [[ "$(uname)" = "Darwin" ]]; then
	PLATFORM="macos"
else
	PLATFORM="linux"
fi
```

**After** (in `lib/_utils.sh`):
```bash
utils::is_mac() {
	[[ "$(uname)" == "Darwin" ]]
}

utils::is_linux() {
	[[ "$(uname)" == "Linux" ]]
}
```

Use in scripts:
```bash
source "lib/_utils.sh"
if utils::is_mac; then
	# macOS specific
fi
```

### Step 4: Update Executable Scripts

**Before** (`dot-install.sh`):
```bash
#!/usr/bin/env bash
source "_colors.sh"

_create_link() {
	ln -s "$1" "$2"
}

_create_link "$source" "$target"
```

**After** (`bin/dot-install`):
```bash
#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/../lib"

source "${LIB_DIR}/_colors.sh" || exit 1
source "${LIB_DIR}/_fs.sh" || exit 1

# ============================================================================
# Configuration
# ============================================================================

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"

# ============================================================================
# Main Execution
# ============================================================================

echo -e "${colors::ok} Creating symlinks..."
fs::create_symlink "$source" "$target"
```

Make executable:
```bash
chmod +x bin/dot-install
```

### Step 5: Update Function Names

Apply namespace convention:

**Before**:
```bash
# _utils.sh
is_mac() { ... }
trim_string() { ... }
create_symlink() { ... }
```

**After**:
```bash
# lib/_utils.sh
utils::is_mac() { ... }

# lib/_validation.sh (new)
validation::trim_string() { ... }

# lib/_fs.sh (new)
fs::create_symlink() { ... }
```

Update all call sites:
```bash
# Before
source "_utils.sh"
is_mac
trim_string "$text"

# After
source "lib/_utils.sh"
source "lib/_fs.sh"
utils::is_mac
utils::trim "$text"
fs::create_symlink "$src" "$dst"
```

## Common Migration Scenarios

### Scenario 1: Consolidate Color Functions

**Before** (multiple files with color logic):
```bash
# script1.sh
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
echo "${RED}Error${NC}"

# script2.sh
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
echo "${GREEN}Success${NC}"
```

**After** (single source of truth):
```bash
# Both scripts now
source "lib/_colors.sh"
echo -e "${colors::error} Error"
echo -e "${colors::ok} Success"
```

**Benefits**:
- ✅ DRY principle - no duplication
- ✅ Consistent colors across all scripts
- ✅ Easy to update colors globally
- ✅ Better terminal compatibility

### Scenario 2: Extract File Operations

**Before** (inline file operations):
```bash
# dot-install.sh
if [ -e "$target" ]; then
	rm -f "$target"
fi
mkdir -p "$(dirname "$target")"
ln -s "$source" "$target"
if [ $? -ne 0 ]; then
	echo "Error: failed to create link"
	exit 1
fi
```

**After** (using library):
```bash
# dot-install uses fs::create_symlink from lib/_fs.sh
source "lib/_fs.sh"
fs::create_symlink "$source" "$target" || exit 1
```

**Benefits**:
- ✅ Error handling built-in
- ✅ Consistent behavior
- ✅ Less code to maintain
- ✅ Better testing

### Scenario 3: Add Validation to Scripts

**Before**:
```bash
#!/bin/bash
if [ -z "$CONFIG_FILE" ]; then
	echo "Error: CONFIG_FILE not set"
	exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
	echo "Error: Config not found"
	exit 1
fi
```

**After**:
```bash
#!/bin/bash
source "lib/_validation.sh"

validation::assert_not_empty "CONFIG_FILE" || exit 1
validation::assert_file_exists "$CONFIG_FILE" "Configuration" || exit 1
```

## Migration Checklist

- [ ] Identify all existing scripts
- [ ] Categorize as library or executable
- [ ] Move libraries to `lib/_name.sh`
- [ ] Move executables to `bin/name`
- [ ] Add namespaces to all functions
- [ ] Replace duplicated code with library functions
- [ ] Update all source/import statements
- [ ] Test each script
- [ ] Update documentation
- [ ] Remove old script files
- [ ] Update .gitignore if needed

## Testing After Migration

### Quick Validation

```bash
# Check script is executable
[[ -x bin/script_name ]] && echo "✓ Executable"

# Check it runs (without doing anything dangerous)
./bin/script_name --help 2>/dev/null || ./bin/script_name || true

# Source libraries
bash -c "source lib/_colors.sh && colors::init"

# Check function exists
bash -c "source lib/_utils.sh && utils::is_mac && echo '✓ Function works'"
```

### Comprehensive Testing

Create simple test scripts in `tests/`:

```bash
#!/bin/bash
# tests/test_colors.sh

source lib/_colors.sh

# Test colors initialized
[[ -n "$colors::red" ]] && echo "✓ Colors initialized"

# Test message prefixes
[[ "$colors::error" == *"ERROR"* ]] && echo "✓ Error prefix set"
```

## Common Issues and Solutions

### Issue: "No such file or directory" when sourcing

**Problem**: Library path is wrong
```bash
source "lib/_utils.sh"  # ❌ Relative path issues
```

**Solution**: Use absolute path from script
```bash
LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../lib" && pwd)"
source "${LIB_DIR}/_utils.sh"  # ✅ Works from anywhere
```

### Issue: Functions appear to work in terminal but fail in script

**Problem**: Library not sourced with error checking
```bash
source "lib/_colors.sh"  # ❌ Silently continues if fails
```

**Solution**: Add error handling
```bash
source "${LIB_DIR}/_colors.sh" || {
	echo "Error: Could not source colors library"
	exit 1
}
```

### Issue: "undefined variable" with set -u

**Problem**: Using undefined variables in strict mode
```bash
#!/bin/bash
set -u
echo "$OLD_VAR"  # ❌ Error if OLD_VAR not set
```

**Solution**: Use parameter expansion
```bash
echo "${OLD_VAR:-default_value}"  # ✅ Works
```

## Before and After Examples

### Example 1: Simple Installation Script

**Before**:
```bash
#!/bin/bash
# install.sh

source _colors.sh

mkdir -p ~/.config
cp config.conf ~/.config/

if [ $? -eq 0 ]; then
	echo -e "${GREEN}Installed successfully${NC}"
else
	echo -e "${RED}Installation failed${NC}"
	exit 1
fi
```

**After**:
```bash
#!/bin/bash
# bin/dot-config

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/../lib"

source "${LIB_DIR}/_colors.sh" || exit 1
source "${LIB_DIR}/_fs.sh" || exit 1

fs::ensure_dir "$HOME/.config"
cp config.conf "$HOME/.config/" && \
	echo -e "${colors::ok} Installed successfully" || \
	echo -e "${colors::error} Installation failed"
```

### Example 2: Complex Platform-Specific Script

**Before**:
```bash
#!/bin/bash
# setup.sh

if [[ "$(uname)" = "Darwin" ]]; then
	echo "macOS detected"
	# macOS specific code
else
	echo "Linux detected"
	# Linux specific code
fi
```

**After**:
```bash
#!/bin/bash
# bin/dot-setup

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/../lib"

source "${LIB_DIR}/_colors.sh" || exit 1
source "${LIB_DIR}/_utils.sh" || exit 1

if utils::is_mac; then
	echo -e "${colors::note} Setting up for macOS"
	# macOS specific code
elif utils::is_linux; then
	echo -e "${colors::note} Setting up for Linux"
	# Linux specific code
fi
```

## Next Steps

1. Start with one script as proof of concept
2. Migrate it to new structure
3. Test thoroughly
4. Use it as template for other scripts
5. Document the process in team/project docs

## Support and Questions

- Check [lib/README.md](lib/README.md) for library reference
- Check [bin/README.md](bin/README.md) for executable patterns
- Check [BASH_BEST_PRACTICES.md](BASH_BEST_PRACTICES.md) for bash patterns
