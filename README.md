# dotfiles-stow

> [!CAUTION]
> This is a testing repo the data here presented can be untested and broken.


Dotfiles using stow

## Try it in Docker

Safely test this configuration in docker

```bash
docker run -e TERM -e COLORTERM -e LC_ALL=C.UTF-8 -w /root -it --rm alpine sh -uec '
  apk add curl sudo bash zsh git stow 
  apk add tmux neovim fzf bat eza 
  apk add nerd-fonts starship
  apk add g++ python3
  bash -c "$(git clone https://github.com/srioboo/dotfiles-stow.git .dotfiles-stow)"
  stow tmux -d .dotfiles-stow
  stow nvim -d .dotfiles-stow
  stow zshrc -d .dotfiles-stow
  zsh'
```

## HOW TO STOW

To apply configurations use

```shell
stow <name program> -d <stow directory>

# example
stow tmux -d .dotfiles-stow
stow nvim -d .dotfiles-stow
```
