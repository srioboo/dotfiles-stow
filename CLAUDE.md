# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Key Commands

Apply dotfiles to `$HOME` (auto-detects macOS vs Linux):
```bash
./scripts/stow.sh
```

Full bootstrap (installs Oh My Zsh, packages, then stows):
```bash
./bootstrap.sh
```

Stow a single package manually:
```bash
stow -d shared -t "$HOME" nvim       # shared package
stow -d macos -t "$HOME" homebrew    # macOS-only package
stow --simulate -d shared -t "$HOME" nvim  # dry-run preview
stow -D -d shared -t "$HOME" nvim    # remove symlinks
stow -R -d shared -t "$HOME" nvim    # restow after adding files
```

## Repository Structure

```
.dotfiles-stow/
├── shared/          # Applied on all platforms
├── macos/           # Applied on Darwin only
├── linux/           # Applied on Linux only
├── 42-dotfiles/     # School (42) environment configs (not managed by stow.sh)
├── scripts/         # Standalone utility scripts (not stowed)
│   └── core/        # Shell libraries sourced by scripts
└── docs/            # Reference documentation
```

**Stow rule**: Each subdirectory within `shared/`, `macos/`, and `linux/` is a stow *package*. Its internal directory tree must exactly mirror where the files belong under `$HOME`. For example, `shared/nvim/.config/nvim/init.lua` symlinks to `~/.config/nvim/init.lua`.

`scripts/stow.sh` iterates every directory inside `shared/` and the OS-appropriate folder, stowing each as a package targeting `$HOME`.

## Adding a New Config

1. Create the mirrored directory tree: `mkdir -p shared/kitty/.config/kitty`
2. Move or copy existing config into it: `mv ~/.config/kitty shared/kitty/.config/kitty/`
3. Stow it: `stow -d shared -t "$HOME" kitty`
4. Commit: `git add shared/kitty/ && git commit -m "feat: add kitty config"`

For macOS-specific configs (e.g., `~/Library/…`), put the package under `macos/` instead.

## Shell Script Conventions

All scripts (in `scripts/` and `shared/bin/.local/bin/`) follow the conventions in `shared/bin/.local/bin/BASH_BEST_PRACTICES.md`:

- Shebang: `#!/usr/bin/env bash`
- Strict mode: `set -euo pipefail`
- No file extension — shebang determines interpreter
- UPPER_CASE for script-level variables, `lower_case` for function locals
- Errors go to stderr: `echo "..." >&2`
- Use `[[ ]]` over `[ ]`

Scripts in `scripts/` can source core libraries from `scripts/core/` (e.g., `output.sh`, `platform.sh`, `log.sh`).

Personal executable scripts that should be on `$PATH` go in `shared/bin/.local/bin/` — stowed to `~/.local/bin/`.
