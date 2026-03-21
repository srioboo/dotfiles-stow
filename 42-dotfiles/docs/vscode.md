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

## 42 vscode extensions

alefragnani.project-manager
catppuccin.catppuccin-vsc
codezombiech.gitignore
dokca.42-ft-count-line
donjayamanne.git-extension-pack
donjayamanne.githistory
dracula-theme.theme-dracula
eamodio.gitlens
gruntfuggly.todo-tree
kube.42header
mariusvanwijk-joppekoers.codam-norminette-3
mhutchie.git-graph
moshfeu.compare-folders
ms-azuretools.vscode-docker
ms-dotnettools.csdevkit
ms-dotnettools.csharp
ms-dotnettools.vscode-dotnet-runtime
ms-vscode-remote.remote-containers
ms-vscode.cmake-tools
ms-vscode.cpptools
ms-vscode.cpptools-extension-pack
ms-vscode.cpptools-themes
ms-vscode.hexeditor
ms-vscode.makefile-tools
twxs.cmake
tyriar.lorem-ipsum
visualstudiotoolsforunity.vstuc
ziyasal.vscode-open-in-github

## Vscode home extensions

alefragnani.project-manager
codezombiech.gitignore
donjayamanne.git-extension-pack
donjayamanne.githistory
eamodio.gitlens
gruntfuggly.todo-tree
johnpapa.vscode-peacock
kube.42header
mariusvanwijk-joppekoers.codam-norminette-3
mhutchie.git-graph
moshfeu.compare-folders
ms-azuretools.vscode-docker
ms-dotnettools.csdevkit
ms-dotnettools.csharp
ms-dotnettools.vscode-dotnet-runtime
ms-kubernetes-tools.vscode-kubernetes-tools
ms-vscode-remote.remote-containers
ms-vscode-remote.remote-ssh
ms-vscode-remote.remote-ssh-edit
ms-vscode.cmake-tools
ms-vscode.cpptools
ms-vscode.cpptools-extension-pack
ms-vscode.cpptools-themes
ms-vscode.hexeditor
ms-vscode.makefile-tools
ms-vscode.remote-explorer
redhat.vscode-yaml
tyriar.lorem-ipsum
visualstudiotoolsforunity.vstuc
ziyasal.vscode-open-in-github
