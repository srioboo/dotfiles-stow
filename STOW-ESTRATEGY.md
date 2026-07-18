Estrategia completa para gestionar tus dotfiles en un solo repositorio multiplataforma con GNU Stow.## Estructura del repositorio

La clave está en separar tres capas: configuración **compartida** (la mayoría de tus tools), configuración **específica por OS**, y scripts de **automatización**.

---

## 1. Estructura de directorios

```
~/dotfiles/
├── shared/           # Todo lo que funciona igual en ambos OS
│   ├── zsh/
│   │   ├── .zshrc
│   │   └── .zshenv
│   ├── git/
│   │   └── .gitconfig
│   ├── nvim/
│   │   └── .config/nvim/
│   └── tmux/
│       └── .tmux.conf
│
├── linux/            # Solo para Linux
│   ├── i3/
│   │   └── .config/i3/
│   ├── dunst/
│   │   └── .config/dunst/
│   └── systemd-user/
│       └── .config/systemd/user/
│
├── macos/            # Solo para macOS
│   ├── macos/
│   │   ├── .skhdrc
│   │   └── .yabairc
│   ├── karabiner/
│   │   └── .config/karabiner/
│   └── homebrew/
│       └── Brewfile
│
└── scripts/
    ├── bootstrap.sh   # Instalación desde cero
    └── stow.sh        # Aplica stow según OS detectado
```

---

## 2. Gestión de configuraciones que difieren por OS

Para herramientas como `zsh` o `git` que tienen configuración compartida pero con diferencias, usa el patrón de **includes**:

```bash
# shared/zsh/.zshrc — base común
export EDITOR="nvim"
source ~/.zsh/aliases.zsh

# Al final, carga el override específico de OS (si existe)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
```

Luego creas `linux/zsh/.zshrc.local` y `macos/zsh/.zshrc.local` con las diferencias. Stow los enlaza como symlinks y cada OS carga el suyo.

Lo mismo aplica a `.gitconfig`:

```ini
# shared/git/.gitconfig
[include]
    path = ~/.gitconfig.local   # cargado si existe
```

---

## 3. El script de automatización `stow.sh`

```bash
#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
OS=$(uname -s)

# Siempre se aplica lo compartido
stow -d "$DOTFILES" -t "$HOME" shared

# Configuración específica por OS
case "$OS" in
  Linux)
    stow -d "$DOTFILES" -t "$HOME" linux
    ;;
  Darwin)
    stow -d "$DOTFILES" -t "$HOME" macos
    ;;
  *)
    echo "OS no reconocido: $OS"
    exit 1
    ;;
esac

echo "Dotfiles aplicados correctamente en $OS"
```

---

## 4. El script `bootstrap.sh` (instalación desde cero)

```bash
#!/usr/bin/env bash
set -e

OS=$(uname -s)

install_deps_linux() {
  sudo apt-get install -y stow git zsh nvim   # o tu package manager
}

install_deps_macos() {
  # Instala Homebrew si no está
  command -v brew &>/dev/null || \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew bundle --file="$HOME/dotfiles/macos/homebrew/Brewfile"
}

clone_dotfiles() {
  [ -d "$HOME/dotfiles" ] || \
    git clone https://github.com/tu-usuario/dotfiles.git "$HOME/dotfiles"
}

clone_dotfiles

case "$OS" in
  Linux)  install_deps_linux ;;
  Darwin) install_deps_macos ;;
esac

# Aplica los symlinks
bash "$HOME/dotfiles/scripts/stow.sh"
```

---

## 5. Consejos clave

**Respetar la estructura de Stow.** Dentro de cada paquete (ej. `shared/nvim/`), la ruta de los archivos debe replicar exactamente la ruta relativa desde `$HOME`. Si quieres `~/.config/nvim/init.lua`, el archivo debe estar en `shared/nvim/.config/nvim/init.lua`.

**Usa `--adopt` con cuidado.** El flag `stow --adopt` mueve tus configs actuales al repo y crea el symlink. Útil al migrar, pero revisa que no sobreescriba algo en Git.

**Simula antes de aplicar.** El flag `-n` (dry-run) junto con `-v` te muestra exactamente qué symlinks crearía sin tocar nada:
```bash
stow -nvt ~ shared   # simula sin aplicar
```

**`.stow-local-ignore`** para excluir archivos como `README.md` o `Brewfile` de los paquetes donde no quieres que Stow los enlace.

---

## Flujo de trabajo en una nueva máquina

```
git clone … ~/dotfiles
bash ~/dotfiles/scripts/bootstrap.sh
```

Un solo comando instala dependencias según el OS y aplica todos los symlinks. Desde ese momento, editas en `~/dotfiles/`, haces commit, y el cambio se refleja automáticamente porque los archivos en `$HOME` son symlinks.
