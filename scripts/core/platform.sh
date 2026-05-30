#!/usr/bin/env bash

platform::command_exists() {
  type "$1" &>/dev/null
}

platform::is_macos() {
  [[ $(uname -s) == "Darwin" ]]
}

platform::is_linux() {
  [[ $(uname -s) == "Linux" ]]
}

platform::is_windows() {
  log::note "Platform unkwow, if you are on windows ps1 scripts are needed, windows not implemented"
}
