#!/usr/bin/env bash
set -euo pipefail

scrDir="$(cd -- "$(dirname -- "$0")" && pwd)"
source "$scrDir/global_fn.sh"

listPkg="${1:-$scrDir/custom_swirlface.lst}"
getAur="${getAur:-yay}"
archPkg=()
aurPkg=()

sudo pacman -Sy --needed ${use_default:-} base-devel git
"$scrDir/install_aur.sh" "$getAur"
chk_list aurhlpr "${aurList[@]}"

while IFS='|' read -r pkg deps _comment; do
    pkg="${pkg%%#*}"
    pkg="${pkg//[[:space:]]/}"
    [[ -z "$pkg" ]] && continue

    if [[ -n "${deps:-}" ]]; then
        dep_ok=1
        for dep in $deps; do
            if ! pkg_installed "$dep" && ! grep -Eq "^[[:space:]]*${dep}([|[:space:]#]|$)" "$listPkg"; then
                dep_ok=0
                break
            fi
        done
        if (( dep_ok == 0 )); then
            warn skip "$pkg is missing dependency: $deps"
            continue
        fi
    fi

    if pkg_installed "$pkg"; then
        warn skip "$pkg is already installed"
    elif pkg_available "$pkg"; then
        archPkg+=("$pkg")
    elif aur_available "$pkg"; then
        aurPkg+=("$pkg")
    else
        warn skip "$pkg is unavailable"
    fi
done < <(cut -d '#' -f 1 "$listPkg")

if (( ${#archPkg[@]} > 0 )); then
    sudo pacman ${use_default:-} -S --needed "${archPkg[@]}"
fi

if (( ${#aurPkg[@]} > 0 )); then
    "$aurhlpr" ${use_default:-} -S --needed "${aurPkg[@]}"
fi
