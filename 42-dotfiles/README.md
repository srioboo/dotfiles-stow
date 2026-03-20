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
