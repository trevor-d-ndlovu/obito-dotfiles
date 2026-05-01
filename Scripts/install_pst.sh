#!/usr/bin/env bash
set -euo pipefail

scrDir="$(cd -- "$(dirname -- "$0")" && pwd)"
source "$scrDir/global_fn.sh"

if command -v xdg-mime >/dev/null 2>&1 && pkg_installed dolphin; then
    xdg-mime default org.kde.dolphin.desktop inode/directory
    msg FILEMANAGER "set Dolphin as default file manager"
fi

if command -v zsh >/dev/null 2>&1 && [[ "${SHELL:-}" != "$(command -v zsh)" ]]; then
    chsh -s "$(command -v zsh)" "$USER"
    msg SHELL "changed default shell to zsh; log out and back in"
fi

mkdir -p "$cacheDir"

if command -v swwwallcache.sh >/dev/null 2>&1; then
    swwwallcache.sh -t "" || true
fi
