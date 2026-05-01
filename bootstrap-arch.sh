#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "$0")" && pwd)"

if [[ ! -f /etc/arch-release ]]; then
    printf 'This bootstrap is intended for Arch Linux.\n' >&2
    exit 1
fi

if [[ "${EUID}" -eq 0 ]]; then
    printf 'Run this as your normal user, not root. The script will use sudo when needed.\n' >&2
    exit 1
fi

install_pacman_packages() {
    local -a requested=("$@") available=() missing=()
    local pkg

    sudo pacman -Sy --needed --noconfirm base-devel git

    for pkg in "${requested[@]}"; do
        if pacman -Si "$pkg" >/dev/null 2>&1; then
            available+=("$pkg")
        else
            missing+=("$pkg")
        fi
    done

    if (( ${#available[@]} > 0 )); then
        sudo pacman -S --needed --noconfirm "${available[@]}"
    fi

    if (( ${#missing[@]} > 0 )); then
        printf 'Skipped unavailable pacman packages: %s\n' "${missing[*]}"
    fi
}

ensure_yay() {
    if command -v yay >/dev/null 2>&1; then
        return 0
    fi

    local build_dir
    build_dir="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "$build_dir/yay"
    (cd "$build_dir/yay" && makepkg -si --noconfirm)
    rm -rf "$build_dir"
}

install_aur_packages() {
    local -a requested=("$@") available=() missing=()
    local pkg

    ensure_yay

    for pkg in "${requested[@]}"; do
        if yay -Si "$pkg" >/dev/null 2>&1; then
            available+=("$pkg")
        else
            missing+=("$pkg")
        fi
    done

    if (( ${#available[@]} > 0 )); then
        yay -S --needed --noconfirm "${available[@]}"
    fi

    if (( ${#missing[@]} > 0 )); then
        printf 'Skipped unavailable AUR packages: %s\n' "${missing[*]}"
    fi
}

pacman_packages=(
    zsh zsh-autosuggestions zsh-syntax-highlighting zsh-theme-powerlevel10k
    tmux git github-cli code neovim
    hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk waybar rofi-wayland kitty dunst
    swaylock wlogout swww grim slurp swappy wl-clipboard cliphist
    network-manager-applet blueman bluez bluez-utils pipewire pipewire-pulse wireplumber pavucontrol pamixer
    brightnessctl playerctl polkit-kde-agent qt5ct qt6ct kvantum kvantum-qt5 nwg-look
    fastfetch btop eza bat fd fzf ripgrep zoxide atuin direnv jq imagemagick curl wget unzip
    dolphin thunar firefox spotify-launcher
    ttf-cascadia-code-nerd ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji
)

aur_packages=(
    oh-my-zsh-git
    visual-studio-code-bin
    spicetify-cli
    bibata-cursor-theme-bin
    ttf-maplemono-nf
)

install_pacman_packages "${pacman_packages[@]}"
install_aur_packages "${aur_packages[@]}"

"$repo_dir/install.sh"

if command -v zsh >/dev/null 2>&1 && [[ "${SHELL:-}" != "$(command -v zsh)" ]]; then
    chsh -s "$(command -v zsh)" "$USER"
    printf 'Default shell changed to zsh. Log out and back in for it to take effect.\n'
fi

printf 'Bootstrap complete. Reboot or log out/in before starting Hyprland.\n'
