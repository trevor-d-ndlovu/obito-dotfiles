#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "$0")" && pwd)"

link_file() {
    local source_path="$1"
    local target_path="$2"
    local target_dir

    target_dir="$(dirname -- "$target_path")"

    mkdir -p "$target_dir"

    if [[ -L "$target_path" ]] && [[ "$(readlink -- "$target_path")" == "$source_path" ]]; then
        printf 'skipped %s (already linked)\n' "$target_path"
        return 0
    fi

    if [[ -e "$target_path" || -L "$target_path" ]]; then
        mv "$target_path" "$target_path.bak.$(date +%Y%m%d%H%M%S)"
    fi

    ln -s "$source_path" "$target_path"
    printf 'linked %s -> %s\n' "$target_path" "$source_path"
}

link_file "$repo_dir/.gitconfig" "$HOME/.gitconfig"
link_file "$repo_dir/.zshrc" "$HOME/.zshrc"
link_file "$repo_dir/.tmux.conf" "$HOME/.tmux.conf"
link_file "$repo_dir/.config/Code - OSS/User/settings.json" "$HOME/.config/Code - OSS/User/settings.json"
