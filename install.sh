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
link_file "$repo_dir/.config/hypr" "$HOME/.config/hypr"
link_file "$repo_dir/.config/waybar" "$HOME/.config/waybar"
link_file "$repo_dir/.config/rofi" "$HOME/.config/rofi"
link_file "$repo_dir/.config/kitty" "$HOME/.config/kitty"
link_file "$repo_dir/.config/dunst" "$HOME/.config/dunst"
link_file "$repo_dir/.config/gtk-3.0" "$HOME/.config/gtk-3.0"
link_file "$repo_dir/.config/gtk-4.0" "$HOME/.config/gtk-4.0"
link_file "$repo_dir/.config/Kvantum" "$HOME/.config/Kvantum"
link_file "$repo_dir/.config/qt5ct" "$HOME/.config/qt5ct"
link_file "$repo_dir/.config/qt6ct" "$HOME/.config/qt6ct"
link_file "$repo_dir/.config/swirlface" "$HOME/.config/swirlface"
link_file "$repo_dir/.config/wlogout" "$HOME/.config/wlogout"
link_file "$repo_dir/.config/swaylock" "$HOME/.config/swaylock"
link_file "$repo_dir/.config/fastfetch" "$HOME/.config/fastfetch"
link_file "$repo_dir/.config/swappy" "$HOME/.config/swappy"
link_file "$repo_dir/.local/share/bin" "$HOME/.local/share/bin"
link_file "$repo_dir/.local/share/swirlface" "$HOME/.local/share/swirlface"
link_file "$repo_dir/.themes" "$HOME/.themes"
link_file "$repo_dir/.icons" "$HOME/.icons"
