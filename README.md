# obito-dotfiles

Personal shell, Git, tmux, Code - OSS, Hyprland, Waybar, and theme config.

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

On a fresh Arch install, clone this repo and run the bootstrap:

```bash
git clone https://github.com/trevor-d-ndlovu/obito-dotfiles.git
cd obito-dotfiles
./bootstrap-arch.sh
```

The bootstrap:

- installs Arch packages used by the configs
- installs selected AUR packages through `yay`
- runs `install.sh`
- changes the default shell to `zsh`

If the packages are already installed, or you only want to relink the config files, run:

```bash
./install.sh
```

The installer:

- backs up existing target files with a timestamped `.bak.*` suffix
- creates parent directories as needed
- symlinks the tracked files into `$HOME`

## Notes

- The bootstrap installs the common dependencies, but a few hardware-specific packages may still need manual setup, especially GPU, Wi-Fi, Bluetooth, or laptop power-management packages.
- The repo includes the full local icon collection and Swirlface theme bundle, so cloning can take a while.
