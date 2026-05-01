#!/usr/bin/env bash
set -euo pipefail

scrDir="$(cd -- "$(dirname -- "$0")" && pwd)"
source "$scrDir/global_fn.sh"

cat <<'EOF'
-------------------------------------------------
        swirlface desktop installer
-------------------------------------------------
EOF

flg_Install=0
flg_Restore=0
flg_Service=0

while getopts idrs opt; do
    case "$opt" in
        i) flg_Install=1 ;;
        d) flg_Install=1; export use_default="--noconfirm" ;;
        r) flg_Restore=1 ;;
        s) flg_Service=1 ;;
        *)
            printf 'valid options:\n'
            printf '  -i install packages only\n'
            printf '  -d install packages with pacman/yay --noconfirm\n'
            printf '  -r restore configs only\n'
            printf '  -s enable system services only\n'
            exit 1
            ;;
    esac
done

if (( OPTIND == 1 )); then
    flg_Install=1
    flg_Restore=1
    flg_Service=1
fi

shift $((OPTIND - 1))
custom_pkg="${1:-}"

if (( flg_Install == 1 && flg_Restore == 1 )); then
    "$scrDir/install_pre.sh"
fi

if (( flg_Install == 1 )); then
    pkg_list="$scrDir/install_pkg.lst"
    cp "$scrDir/custom_swirlface.lst" "$pkg_list"

    if [[ -n "$custom_pkg" && -f "$custom_pkg" ]]; then
        cat "$custom_pkg" >> "$pkg_list"
    fi

    if nvidia_detect; then
        nvidia_detect --drivers >> "$pkg_list"
    fi

    "$scrDir/install_pkg.sh" "$pkg_list"
    rm -f "$pkg_list"
fi

if (( flg_Restore == 1 )); then
    "$scrDir/restore_cfg.sh"
fi

if (( flg_Install == 1 && flg_Restore == 1 )); then
    "$scrDir/install_pst.sh"
fi

if (( flg_Service == 1 )); then
    while read -r service; do
        [[ -z "$service" || "${service:0:1}" == "#" ]] && continue
        if systemctl list-unit-files "${service}.service" >/dev/null 2>&1; then
            msg systemctl "enabling ${service}"
            sudo systemctl enable --now "${service}.service"
        else
            warn skip "${service}.service is unavailable"
        fi
    done < "$scrDir/system_ctl.lst"
fi

msg done "reboot or log out/in before starting Hyprland"
