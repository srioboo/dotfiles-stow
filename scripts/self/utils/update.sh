#!/bin/user/env bash

DOTBOT_BIN="dotbot"

self_update() {
  cd "$DOTFILES" || exit

  git fetch
  if [[ $(project_status) == "behind" ]]; then
    log::note "Needs to pull!"
    git pull && exit 0 || log::error "Failed"
  fi
}

apply_symlinks() {
  local -r CONFIG="$DOTFILES/symlinks/$1"
  shift

  echo
  "$DOTBOT_BIN" -d "$DOTFILES" -c "$CONFIG" "$@"
  echo
}

apply_common_symlinks() {
  apply_symlinks "conf.yaml"
}

apply_macos_symlinks() {
  apply_symlinks "conf.macos.yaml"

  # temporalmente comentado
  # sudo ln -sf "$DOTFILES/mac/plist/limit.maxfiles.plist" "/Library/LaunchDaemons/limit.maxfiles.plist"
  # sudo ln -sf "$DOTFILES/mac/plist/limit.maxproc.plist" "/Library/LaunchDaemons/limit.maxproc.plist"
  # sudo chmod 644 "/Library/LaunchDaemons/limit.maxfiles.plist"
  # sudo chmod 644 "/Library/LaunchDaemons/limit.maxproc.plist"
  # sudo chown root:wheel /Library/LaunchDaemons/limit.maxfiles.plist
  # sudo chown root:wheel /Library/LaunchDaemons/limit.maxproc.plist
  # sudo launchctl load -w "/Library/LaunchDaemons/limit.maxfiles.plist"
  #sudo launchctl load -w "/Library/LaunchDaemons/limit.maxproc.plist"
	# /temporalmente comentado
}

apply_linux_symlinks() {
  apply_symlinks "conf.linux.yaml"
}

project_status() {
  cd "$DOTFILES" || exit

  local -r UPSTREAM="master"
  local -r LOCAL=$(git rev-parse @)
  local -r REMOTE=$(git rev-parse "$UPSTREAM")
  local -r BASE=$(git merge-base @ "$UPSTREAM")

  if [[ "$LOCAL" == "$REMOTE" ]]; then
    echo "synced"
  elif [[ "$LOCAL" == "$BASE" ]]; then
    echo "behind"
  elif [[ "$REMOTE" == "$BASE" ]]; then
    echo "ahead"
  else
    echo "diverged"
  fi
}
