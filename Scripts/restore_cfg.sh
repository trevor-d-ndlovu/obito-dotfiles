#!/usr/bin/env bash
set -euo pipefail

scrDir="$(cd -- "$(dirname -- "$0")" && pwd)"
source "$scrDir/global_fn.sh"

cfg_list="${1:-$scrDir/restore_cfg.lst}"
src_root="${2:-$cloneDir}"
backup_dir="$HOME/.config/cfg_backups/$(date +'%y%m%d_%Hh%Mm%Ss')"

[[ -f "$cfg_list" ]] || die "missing restore list: $cfg_list"
mkdir -p "$backup_dir"

while IFS='|' read -r overwrite backup target rel_path deps; do
    [[ -z "${overwrite:-}" || "${overwrite:0:1}" == "#" ]] && continue

    target="$(eval "printf '%s' \"$target\"")"
    rel_path="${rel_path%/}"
    src="$src_root/$rel_path"
    dst="$target/$(basename "$rel_path")"

    [[ -e "$src" || -L "$src" ]] || { warn skip "missing source $src"; continue; }

    if [[ -n "${deps:-}" ]]; then
        for dep in $deps; do
            if ! pkg_installed "$dep" && ! command -v "$dep" >/dev/null 2>&1; then
                warn skip "$dst needs $dep"
                continue 2
            fi
        done
    fi

    mkdir -p "$target"

    if [[ -e "$dst" || -L "$dst" ]]; then
        if [[ "$backup" == "Y" ]]; then
            bkp_target="$backup_dir${dst#$HOME}"
            mkdir -p "$(dirname "$bkp_target")"
            cp -a "$dst" "$bkp_target"
            msg backup "$dst -> $bkp_target"
        fi

        if [[ "$overwrite" != "Y" ]]; then
            warn preserve "$dst"
            continue
        fi

        rm -rf "$dst"
    fi

    cp -a "$src" "$target/"
    msg restore "$dst"
done < "$cfg_list"

msg backup "saved changed originals under $backup_dir"
