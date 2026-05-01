#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "$0")" && pwd)"

if [[ ! -f /etc/arch-release ]]; then
    printf 'This bootstrap is intended for Arch Linux.\n' >&2
    exit 1
fi

if [[ "${EUID}" -eq 0 ]]; then
    printf 'Run this as your normal user, not root. The installer will use sudo when needed.\n' >&2
    exit 1
fi

exec "$repo_dir/install.sh" -d
