# 📚 Script Libraries

This directory contains reusable shell script libraries organized with namespaces for clarity and maintainability.

## 🏗️ Structure

Libraries use the **namespace convention** to clearly identify functions and avoid naming conflicts:

- **`_colors.sh`** - Terminal colors and formatting  
  Functions: `colors::init()`, `colors::print_palette()`, etc.
  
- **`_utils.sh`** - General utility functions  
  Functions: `utils::is_mac()`, `utils::command_exists()`, `utils::trim()`, etc.
  
- **`_fs.sh`** - File system operations  
  Functions: `fs::create_symlink()`, `fs::ensure_dir()`, `fs::backup()`, etc.
  
- **`_validation.sh`** - Input validation and assertions  
  Functions: `validation::is_email()`, `validation::is_directory()`, `validation::assert_not_empty()`, etc.

## 📖 Usage Examples

### Basic Library Import

```bash
#!/usr/bin/env bash

# Source the library
source "lib/_colors.sh"

# Initializes color variables and sets up message prefixes automatically
echo -e "${colors::error} Something went wrong!"
echo -e "${colors::ok} Operation successful!"
echo -e "${colors::warning} Be careful here"
echo -e "${colors::note} FYI: This is important"
```

### Using Multiple Libraries

```bash
#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/lib"

source "${LIB_DIR}/_colors.sh"      # Terminal output
source "${LIB_DIR}/_utils.sh"       # Utilities
source "${LIB_DIR}/_validation.sh"  # Validation
source "${LIB_DIR}/_fs.sh"          # File operations

# Check platform
if utils::is_mac; then
	echo -e "${colors::note} Running on macOS"
fi

# Validate input
if ! validation::assert_not_empty "CONFIG_FILE"; then
	exit 1
fi

# Create symlink with error handling
if fs::create_symlink "/path/to/source" "/path/to/link"; then
	echo -e "${colors::ok} Setup complete!"
else
	echo -e "${colors::error} Setup failed!"
	exit 1
fi
```

### File System Operations

```bash
source "lib/_fs.sh"

# Create symlinks
fs::create_symlink "$SOURCE_DIR/config" "$HOME/.config/myapp"

# Ensure directories exist
fs::ensure_dir "$HOME/.local/bin"

# Back up files before modifying
fs::backup "$HOME/.bashrc"

# Check file properties
if fs::is_readable "$config_file"; then
	# Process file...
fi
```

### Validation

```bash
source "lib/_validation.sh"

# Check file existence
if validation::assert_file_exists "$config_file" "Configuration"; then
	echo "Config found"
fi

# Validate directory
validation::assert_dir_exists "$app_dir" "Application directory"

# Check custom conditions
if ! validation::is_positive "$count"; then
	echo "Must be positive integer"
	exit 1
fi

# Test regex patterns
if validation::matches "$email" '^[a-z]+@example\.com$'; then
	echo "Valid email"
fi
```

### String Operations

```bash
source "lib/_utils.sh"

# Case conversion
lowercase=$(utils::to_lower "HELLO")
uppercase=$(utils::to_upper "hello")

# String trimming
trimmed=$(utils::trim "  some text  ")

# Array operations
if utils::in_array "item" "${my_array[@]}"; then
	echo "Found in array"
fi

# Path operations
abs_path=$(utils::abspath "./relative/path")

# Command checks
if utils::command_exists "cargo"; then
	echo "Rust is installed"
fi
```

## 🎨 Color Usage

The `colors::` namespace provides standardized terminal colors and message formatting:

```bash
source "lib/_colors.sh"

# Color variables available
echo "${colors::red}Error${colors::nc}"
echo "${colors::green}Success${colors::nc}"
echo "${colors::orange}Warning${colors::nc}"
echo "${colors::blue}Info${colors::nc}"

# Predefined message types
echo -e "${colors::error} This is an error message"
echo -e "${colors::ok} This is a success message"
echo -e "${colors::warning} This is a warning"
echo -e "${colors::note} This is a note"

# Modifiers
echo "${colors::bold}${colors::green}Bold green text${colors::nc}"
echo "${colors::bg_blue}Background blue${colors::nc}"
```

## ✅ Naming Conventions

- **Private functions** (internal use): `namespace::_private_func()`  
- **Public functions** (exported): `namespace::public_func()`  
- **Variables**: `namespace::variable_name`  
- **Color variables**: Always include `${colors::nc}` to reset color

## 🔧 Best Practices

1. **Always source with error handling**:
   ```bash
   source "lib/_colors.sh" || exit 1
   ```

2. **Use absolute paths when possible**:
   ```bash
   LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/lib" && pwd)"
   source "${LIB_DIR}/_utils.sh"
   ```

3. **Validate early**:
   ```bash
   validation::assert_file_exists "$config_file" "Config" || exit 1
   ```

4. **Use color codes for clarity**:
   ```bash
   echo -e "${colors::ok} Success: ${colors::blue}$result${colors::nc}"
   ```

5. **Handle errors gracefully**:
   ```bash
   if ! fs::create_symlink "$src" "$dst"; then
       echo -e "${colors::error} Failed to create link"
       exit 1
   fi
   ```

## 📝 Adding New Libraries

When creating new libraries, follow this structure:

```bash
#!/usr/bin/env bash
# namespace:: - Brief description of what this library does
# Use: source lib/_namespace.sh
#      namespace::function_name

# Source dependencies if needed
source "$(dirname "${BASH_SOURCE[0]}")/_colors.sh" || exit 1

# ============================================================================
# Section Name
# ============================================================================

# Public function with namespace
namespace::public_function() {
	# Implementation
	true
}

# Private function (prefixed with _)
namespace::_private_helper() {
	# Implementation
	true
}
```

## 🚀 Integration with Executables

See [../bin/README.md](../bin/README.md) for how to use these libraries in executable scripts.
