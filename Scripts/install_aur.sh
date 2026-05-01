#!/usr/bin/env bash
set -euo pipefail

scrDir="$(cd -- "$(dirname -- "$0")" && pwd)"
source "$scrDir/global_fn.sh"

if chk_list aurhlpr "${aurList[@]}"; then
    msg AUR "detected ${aurhlpr}"
    exit 0
fi

aurhlpr="${1:-yay}"
build_root="$HOME/Clone"
build_dir="$build_root/$aurhlpr"

mkdir -p "$build_root"
rm -rf "$build_dir"

pkg_installed git || sudo pacman -S --needed --noconfirm git base-devel
git clone "https://aur.archlinux.org/${aurhlpr}.git" "$build_dir"
(cd "$build_dir" && makepkg ${use_default:-} -si)

msg AUR "installed ${aurhlpr}"
