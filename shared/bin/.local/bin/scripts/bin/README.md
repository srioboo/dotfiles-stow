# 🔧 Executable Scripts

This directory contains standalone executable scripts that use libraries from `../lib/`.

## 🏗️ Structure

Each script in this directory is an **executable** (without `.sh` extension) that performs a specific task:

- **`dot-install`** - Setup symbolic links for dotfiles configuration
  - Supports macOS and Linux platforms
  - Uses `_colors.sh`, `_validation.sh`, `_fs.sh`

## 🚀 Usage

All scripts are executable from the command line:

```bash
# Make sure script is executable
chmod +x bin/dot-install

# Run from the scripts directory
./bin/dot-install

# Or from anywhere (if in PATH or with full path)
/path/to/scripts/bin/dot-install
```

## ✨ Design Principles

### 1. **Naming Convention**
- No `.sh` extension for executables
- Kebab-case names: `dot-install`, `dot-test`, etc.
- Kept short but descriptive

### 2. **Library Dependencies**
Each executable clearly declares its library dependencies at the top:

```bash
#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/../lib"

# Source libraries with error handling
source "${LIB_DIR}/_colors.sh" || exit 1
source "${LIB_DIR}/_validation.sh" || exit 1
source "${LIB_DIR}/_fs.sh" || exit 1
```

### 3. **Error Handling**
All scripts use strict mode:

```bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures
```

### 4. **Clear Output**
Using color-coded messages from the colors library:

```bash
echo -e "${colors::ok} Something successful"
echo -e "${colors::error} Something failed"
echo -e "${colors::warning} Be careful"
echo -e "${colors::note} Information"
```

### 5. **Platform Support**
Scripts detect and adapt to different platforms:

```bash
if utils::is_mac; then
    # macOS specific logic
elif utils::is_linux; then
    # Linux specific logic
fi
```

## 📖 Example: Creating a New Executable

Create `bin/my-script`:

```bash
#!/usr/bin/env bash
# my-script: Brief description of what it does

set -euo pipefail

# Setup paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/../lib"

# Source libraries
source "${LIB_DIR}/_colors.sh" || exit 1
source "${LIB_DIR}/_validation.sh" || exit 1
source "${LIB_DIR}/_utils.sh" || exit 1

# ============================================================================
# Configuration
# ============================================================================

MY_CONFIG_VAR="value"

# ============================================================================
# Functions
# ============================================================================

my_function() {
	echo -e "${colors::ok} Running function"
}

# ============================================================================
# Main
# ============================================================================

# Validate inputs
validation::assert_not_empty "MY_CONFIG_VAR" || exit 1

# Run logic
my_function

echo -e "${colors::note} Done!"
```

Make it executable:
```bash
chmod +x bin/my-script
```

## 📋 Common Patterns

### Pattern: File Configuration

```bash
# At top of script
CONFIG_FILE="${1:-$HOME/.config/myapp/config}"

# Validate
if ! validation::assert_file_exists "$CONFIG_FILE"; then
    exit 1
fi

# Use
source "$CONFIG_FILE"
```

### Pattern: Multiple Steps with Status

```bash
echo -e "${colors::bold}Starting process...${colors::nc}\n"

echo "Step 1: ..."
if ! step_one; then
    exit 1
fi

echo "Step 2: ..."
if ! step_two; then
    exit 1
fi

echo -e "\n${colors::green}✓ All steps completed!${colors::nc}"
```

### Pattern: Dry Run Mode

```bash
DRY_RUN="${DRY_RUN:-0}"

if [[ "$DRY_RUN" == "1" ]]; then
    echo -e "${colors::warning} Running in DRY RUN mode - no changes will be made${colors::nc}"
fi

# Then check before making changes
if [[ "$DRY_RUN" != "1" ]]; then
    # Make actual changes
    fs::create_symlink "$src" "$dst"
fi
```

## 🔗 Related Documentation

- [lib/README.md](../lib/README.md) - Library reference
- [../README.md](../README.md) - Main scripts directory info

## 💡 Tips

1. **Test scripts in isolation** before adding to scripts
2. **Use meaningful exit codes**: 0 = success, 1 = failure
3. **Add -h or --help support** for complex scripts
4. **Document executable usage** in the script header
5. **Keep scripts focused** on one task per executable
6. **Use DEBUG=1 for debugging**:
   ```bash
   DEBUG=1 ./bin/my-script
   ```
