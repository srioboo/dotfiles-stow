# VS Code

## Tips and tricks

- Linux wayland flickering, you can add to code launch

```shell
alias code="code --enable-features=UseOzonePlatform,WaylandWindowDecorations --ozone-platform-hin
t=auto"

```

- dotfiles to save:

```shell
# for mac
~/Library/Application Support/Code/User/keybindings.json
~/Library/Application Support/Code/User/settings.json
~/Library/Application Support/Code/User/snippets/{language}.json

# for linux
~/.config/Code/User/keybindings.json
~/.config/Code/User/settings.json
~/.config/Code/User/snippets/{language}.json
```

### List and export extensions



```shell
# to list extensions
code --list-extensions

# to list extensions and generate a instalation procedure
code --list-extensions | xargs -L 1 echo code --install-extension
```

