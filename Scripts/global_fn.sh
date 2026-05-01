#!/usr/bin/env bash
set -euo pipefail

scrDir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cloneDir="$(dirname "$scrDir")"
confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
cacheDir="$HOME/.cache/swirlface"
aurList=(yay paru)
shlList=(zsh)

msg() {
    printf '\033[0;32m[%s]\033[0m %s\n' "$1" "$2"
}

warn() {
    printf '\033[0;33m[%s]\033[0m %s\n' "$1" "$2"
}

die() {
    printf 'ERROR: %s\n' "$1" >&2
    exit 1
}

pkg_installed() {
    pacman -Qi "$1" >/dev/null 2>&1
}

pkg_available() {
    pacman -Si "$1" >/dev/null 2>&1
}

aur_available() {
    "${aurhlpr}" -Si "$1" >/dev/null 2>&1
}

chk_list() {
    local var_name="$1"
    shift
    local item

    for item in "$@"; do
        if command -v "$item" >/dev/null 2>&1 || pkg_installed "$item"; then
            printf -v "$var_name" '%s' "$item"
            export "$var_name"
            return 0
        fi
    done

    return 1
}

nvidia_detect() {
    if ! command -v lspci >/dev/null 2>&1; then
        return 1
    fi

    case "${1:-}" in
        --verbose)
            lspci -k | grep -Ei '(VGA|3D).*nvidia' || true
            return 0
            ;;
        --drivers)
            printf 'nvidia-dkms\nnvidia-utils\n'
            return 0
            ;;
    esac

    lspci -k | grep -Eiq '(VGA|3D).*nvidia'
}

prompt_timer() {
    local seconds="$1"
    local prompt="$2"
    promptIn=""

    while (( seconds >= 0 )); do
        printf '\r :: %s (%ss): ' "$prompt" "$seconds"
        if read -r -t 1 -n 1 promptIn; then
            break
        fi
        ((seconds--)) || true
    done

    printf '\n'
    export promptIn
}
