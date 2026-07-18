# dotfiles-stow

> [!CAUTION]
> This is a testing repo the data here presented can be untested and broken.

A configuration file manager (dotfiles) using **GNU Stow** to create and maintain symlinks to your home directory.

## What is GNU Stow?

GNU Stow is a tool that facilitates the management of configuration files scattered across your system. It creates symbolic links from your dotfiles directory to the corresponding locations in your `$HOME`, enabling:

- **Version Control**: Keep your configurations in a Git repository
- **Portability**: Easily replicate your configuration on other machines
- **Organization**: Group configurations by application
- **Reversibility**: Undo changes simply by removing symlinks

## Project Structure

```text
.dotfiles-stow/
├── nvim/
│   └── .config/nvim/          # Mirror structure of $HOME
│       ├── init.lua
│       └── lua/
├── tmux/
│   └── .tmux.conf             # File at stow root
├── zsh/
│   └── .zshrc
├── starship/
│   └── .config/starship.toml
└── ghostty/
    └── .config/ghostty/config
```

**Important Rule**: The structure within each folder must exactly reflect where files go in your `$HOME`.

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/srioboo/dotfiles-stow.git ~/.dotfiles-stow
cd ~/.dotfiles-stow
```

### 2. Apply configurations with Stow

```bash
# Apply individual configuration
stow nvim -d .

# Apply multiple configurations at once
stow nvim tmux zsh starship ghostty -d .

# Preview changes without applying them
stow nvim --simulate -d .
```

**Note**: `-d .` tells stow to use the current directory as the stow directory.

## How to Use Stow Correctly

### Step 1: Create the directory structure

For a new application, create the folder hierarchy that mirrors the location in `$HOME`:

```bash
# For nvim config going to ~/.config/nvim
mkdir -p nvim/.config/nvim

# For config going to home root
mkdir -p zsh

# For nested configurations
mkdir -p ghostty/.config/ghostty
```

### Step 2: Move/copy configuration files

```bash
# Option 1: Move existing configuration (destructive)
mv ~/.config/nvim/* ~/.dotfiles-stow/nvim/.config/nvim/

# Option 2: Copy configuration (safer)
cp -r ~/.config/nvim/* ~/.dotfiles-stow/nvim/.config/nvim/

# Then delete the original folder (if you used copy)
rm -rf ~/.config/nvim
```

### Step 3: Create symlinks with stow

```bash
# Inside the .dotfiles-stow directory
cd ~/.dotfiles-stow

# Apply the configuration
stow nvim
```

Stow will automatically create the necessary symlinks. Verify:

```bash
ls -la ~/.config/nvim
# Output will show it points to .dotfiles-stow
```

## Important Commands

### Preview changes before applying

```bash
# --simulate: shows what stow would do without updating anything
stow nvim --simulate
```

### Remove symlinks

```bash
# -D: removes symlinks (delete)
stow -D nvim

# Useful if you need to revert changes
```

### Resolve conflicts

If stow encounters conflicting files:

```bash
stow nvim --verbose
# Shows which files have conflicts

# Option 1: Remove conflicting file from home
rm ~/.config/nvim/conflicting-file

# Option 2: Use --adopt to have stow adopt files from home
stow nvim --adopt
# ⚠️ This overwrites the file in dotfiles-stow
```

### Restow: update symlinks

```bash
# Useful after adding new files
stow nvim --restow
# Or in short form: stow -R nvim
```

## Typical Workflow

### Add a new configuration

```bash
# 1. Create structure
mkdir -p kitty/.config/kitty

# 2. Copy existing configuration
cp ~/.config/kitty/kitty.conf ~/.dotfiles-stow/kitty/.config/kitty/

# 3. Delete original
rm -rf ~/.config/kitty

# 4. Apply stow
cd ~/.dotfiles-stow
stow kitty

# 5. Commit to git
git add kitty/
git commit -m "Add kitty configuration"
```

### Update a configuration

```bash
# Configuration is already synchronized thanks to symlinks
# Just edit the file and changes are reflected automatically

# If you added new files:
stow -R nvim

# Commit the changes
git add nvim/
git commit -m "Update nvim configuration"
```

## Advanced Configuration

### Ignore specific files

Create a `.stow-ignore` file at the project root:

```text
# .stow-ignore
.*\.swp
.*\.tmp
\.DS_Store
```

### Stow configuration

In `~/.stowrc` or `.stowrc`:

```
--verbose
--dir=.
```

## Troubleshooting

### "ERROR: could not create..."

**Problem**: Stow cannot create symlinks

```bash
# Solution: Parent directory doesn't exist
mkdir -p ~/.config
stow nvim
```

### Symlink conflicts

**Problem**: There's a file where stow wants to create a symlink

```bash
# Option 1: Move the file
mv ~/.config/nvim ~/.config/nvim.backup

# Option 2: Use --adopt (be careful)
stow nvim --adopt --verbose
```

### Broken symlinks after moving dotfiles

```bash
# Solution: use stow with -R (restow)
cd ~/.dotfiles-stow
stow -R *
```

## Try it in Podman

Safely test this configuration in podman

```bash
podman run -e TERM -e COLORTERM -e LC_ALL=C.UTF-8 \
   --volume $HOME/WORK:/WORK -w /root -it --rm alpine:latest sh -uec '
  set -ue
  apk add --no-cache curl sudo bash zsh git stow 
  apk add --no-cache tmux neovim fzf bat eza 
  apk add --no-cache nerd-fonts-all starship
  apk add --no-cache g++ python3 nodejs
  
  git clone https://github.com/srioboo/dotfiles-stow.git .dotfiles-stow
  cd .dotfiles-stow
  stow tmux nvim zsh starship ghostty
  
  exec zsh'
```

## Resources

- [GNU Stow Documentation](https://www.gnu.org/software/stow/manual/stow.html)
- [Stow vs alternatives](https://dotfiles.github.io/)
- [Travis Media - Manage dotfiles with GNU Stow](https://travis.media/blog/manage-dotfiles-with-gnu-stow/)
- [YouTube - Getting started with Stow](https://www.youtube.com/watch?v=NoFiYOqnC4o)
