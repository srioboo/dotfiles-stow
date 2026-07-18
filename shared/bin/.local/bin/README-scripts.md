# Scripts Directory

Professional shell script organization with clear separation between **reusable libraries** and **executable scripts**.

## 📁 Directory Structure

```
scripts/
├── lib/                    # 📚 Reusable Libraries
│   ├── _colors.sh         # Terminal colors & formatting
│   ├── _utils.sh          # General utilities
│   ├── _fs.sh             # File system operations
│   ├── _validation.sh     # Input validation & assertions
│   └── README.md          # Library documentation
│
├── bin/                    # 🔧 Executable Scripts
│   ├── dot-install        # Setup symbolic links
│   ├── dot-test           # Run tests
│   └── README.md          # Executable documentation
│
├── tests/                  # 🧪 Test Files
├── examples/               # 📖 Example Scripts
├── README.md               # This file
└── .editorconfig           # Editor configuration
```

## 🎯 Key Principles

### 1. **Libraries vs Executables**

**Libraries** (`lib/` directory):
- Prefixed with underscore: `_name.sh`
- Contain reusable functions with namespaces
- Used by `source` command, never executed directly
- Example: `_colors.sh`, `_utils.sh`

**Executables** (`bin/` directory):
- No `.sh` extension
- Standalone scripts that perform tasks
- Use libraries from `lib/`
- Example: `dot-install`, `dot-test`

### 2. **Namespace Convention**

All functions use namespace prefix for clarity:

| Type | Pattern | Example |
|------|---------|---------|
| Public function | `namespace::function` | `colors::init()` |
| Private function | `namespace::_function` | `colors::_init_tput()` |
| Variable | `namespace::var_name` | `colors::red` |

### 3. **Function Organization**

```bash
# ============================================================================
# Section Name
# ============================================================================

# Public function
namespace::public_function() {
	# ...
}

# Private helper
namespace::_private_helper() {
	# ...
}
```

## 📚 Available Libraries

### colors:: - Terminal Output
Terminal colors, text formatting, and pretty printing

```bash
source lib/_colors.sh
echo -e "${colors::error} Error message"
echo -e "${colors::ok} Success message"
```

**Functions**: `colors::init()`, `colors::print_palette()`, color variables

---

### utils:: - General Utilities
System detection, string operations, path handling

```bash
source lib/_utils.sh
utils::is_mac && echo "macOS"
trimmed=$(utils::trim "  text  ")
```

**Functions**: `utils::is_mac()`, `utils::to_lower()`, `utils::abspath()`, etc.

---

### fs:: - File System Operations
Symlinks, directories, file checks, backups

```bash
source lib/_fs.sh
fs::create_symlink "$source" "$target"
fs::backup "$file"
```

**Functions**: `fs::create_symlink()`, `fs::ensure_dir()`, `fs::backup()`, etc.

---

### validation:: - Input Validation
String checks, path validation, assertions

```bash
source lib/_validation.sh
validation::is_file "$path" && echo "File exists"
validation::assert_not_empty "var_name" || exit 1
```

**Functions**: `validation::is_empty()`, `validation::is_file()`, `validation::assert_*()`, etc.

## 🚀 Quick Start

### Using a Library in Your Script

```bash
#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIB_DIR="${SCRIPT_DIR}/lib"

# Source libraries
source "${LIB_DIR}/_colors.sh" || exit 1
source "${LIB_DIR}/_fs.sh" || exit 1

# Use functions
echo -e "${colors::ok} Creating symlink..."
fs::create_symlink "/source" "/target"
```

### Running an Executable Script

```bash
# Make executable
chmod +x bin/dot-install

# Run directly
./bin/dot-install

# Or if bin/ is in PATH
dot-install
```

## 📖 Documentation

- **[lib/README.md](lib/README.md)** - Complete library reference with examples
- **[bin/README.md](bin/README.md)** - Executable scripts reference and patterns

## 🎨 Color Quick Reference

```bash
source lib/_colors.sh

# Foreground colors
${colors::red}        - Red text
${colors::green}      - Green text
${colors::orange}     - Orange text
${colors::blue}       - Blue text
${colors::magenta}    - Magenta text

# Message prefixes (auto-formatted)
${colors::error}      - ✗ ERROR:
${colors::ok}         - ✓ OK:
${colors::warning}    - WARNING:
${colors::note}       - ℹ NOTE:

# Modifiers
${colors::bold}       - Bold text
${colors::nc}         - Reset (always use at end!)
```

## 💡 Best Practices

1. **Always reset colors**: End styled output with `${colors::nc}`
   ```bash
   echo -e "${colors::bold}${colors::red}Error${colors::nc}"
   ```

2. **Source with error checking**:
   ```bash
   source "lib/_colors.sh" || exit 1
   ```

3. **Use strict mode in executables**:
   ```bash
   #!/usr/bin/env bash
   set -euo pipefail
   ```

4. **Validate early**:
   ```bash
   validation::assert_file_exists "$config" || exit 1
   ```

5. **Keep libraries focused**: One responsibility per library

## 🔧 Creating New Libraries

Template for a new library file `lib/_newlib.sh`:

```bash
#!/usr/bin/env bash
# newlib:: - Brief description
# Use: source lib/_newlib.sh

source "$(dirname "${BASH_SOURCE[0]}")/_colors.sh" || exit 1

# ============================================================================
# Public Functions
# ============================================================================

newlib::public_func() {
	# implementation
	true
}

# ============================================================================
# Private Functions
# ============================================================================

newlib::_private_func() {
	# implementation
	true
}
```

## 📝 Convention Summary

| Element | Pattern | Example |
|---------|---------|---------|
| Library file | `_name.sh` | `_colors.sh` |
| Executable | `name` (no .sh) | `dot-install` |
| Public function | `ns::function` | `colors::init` |
| Private function | `ns::_function` | `colors::_init_tput` |
| Variable | `ns::var_name` | `colors::red` |
| Color reset | Always end with `nc` | `${colors::red}text${colors::nc}` |

# Dotfiles 42

Dotfiles to use at 42

## Try it in Docker

For safe testing it is better to use docker

```shell
docker run -e TERM -e COLORTERM -e LC_ALL=C.UTF-8 \
   --volume $HOME/WORK:/WORK \
   -w /root -it --rm alpine sh -uec '
  apk add curl sudo bash zsh git tmux
  apk add vim nerd-fonts g++ python3
  bash -c "$(git clone https://<USER:DOTFILES_42_TOKEN>@github.com/srioboo/dotfiles-42.git .dotfiles-42)"
  zsh'
```

## vim

If you ever want to change the indentation of a block of text, use < and >. Use this conjunction withblock-select mode (v, select a block of text, < or >).

### vim plugins

See:

- [vimawesome](https://vimawesome.com/)
- [VundleVim](https://github.com/VundleVim/Vundle.vim)
- [about tab as spaces](https://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces)

Vim 42 config: [malhyase vim42](https://github.com/malhyasa/Vim42)

