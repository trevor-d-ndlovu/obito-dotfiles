#!/usr/bin/env bash
set -euo pipefail

scrDir="$(cd -- "$(dirname -- "$0")" && pwd)"
source "$scrDir/global_fn.sh"

if [[ -f /etc/pacman.conf && ! -f /etc/pacman.conf.swirlface.bak ]]; then
    msg PACMAN "enabling color, parallel downloads, and multilib"
    sudo cp /etc/pacman.conf /etc/pacman.conf.swirlface.bak
    sudo sed -i '/^#Color/c\Color\nILoveCandy' /etc/pacman.conf
    sudo sed -i '/^#VerbosePkgLists/c\VerbosePkgLists' /etc/pacman.conf
    sudo sed -i '/^#ParallelDownloads/c\ParallelDownloads = 5' /etc/pacman.conf
    sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf
    sudo pacman -Syyu ${use_default:-}
else
    warn skip "pacman is already configured or unavailable"
fi

nvidia_detect --verbose || true
