# obito-dotfiles

Personal shell, Git, tmux, Code - OSS, Hyprland, Waybar, and Swirlface desktop config.

## Files

- `.gitconfig`
- `.zshrc`
- `.tmux.conf`
- `.config/Code - OSS/User/settings.json`
- `.config/hypr`
- `.config/waybar`
- `.config/rofi`
- `.config/kitty`
- `.config/dunst`
- `.config/gtk-3.0`
- `.config/gtk-4.0`
- `.config/Kvantum`
- `.config/qt5ct`
- `.config/qt6ct`
- `.config/swirlface`
- `.config/wlogout`
- `.config/swaylock`
- `.config/fastfetch`
- `.config/swappy`
- `.local/share/bin`
- `.local/share/swirlface`
- `.themes`
- `.icons`

## Install

On a fresh Arch install, clone this repo and run the installer:

```bash
git clone https://github.com/trevor-d-ndlovu/obito-dotfiles.git
cd obito-dotfiles
./install.sh
```

The installer works like the old Hyprdots flow:

- installs Arch packages used by the configs
- installs selected AUR packages through `yay`
- restores the tracked config files into `$HOME`
- backs up replaced files under `~/.config/cfg_backups`
- enables desktop services listed in `Scripts/system_ctl.lst`
- changes the default shell to `zsh`

Useful modes:

```bash
./install.sh        # install packages, restore configs, enable services
./install.sh -d     # same as default, but uses --noconfirm
./install.sh -i     # install packages only
./install.sh -r     # restore configs only
./install.sh -s     # enable services only
./install.sh Scripts/custom_apps.lst
```

Add extra packages to `Scripts/custom_apps.lst`, or pass another package list as the first argument.

## Notes

- The installer installs common dependencies, but a few hardware-specific packages may still need manual setup, especially GPU, Wi-Fi, Bluetooth, or laptop power-management packages.
- The repo includes the full local icon collection and Swirlface theme bundle, so cloning can take a while.
