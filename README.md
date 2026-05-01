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
- `.config/hyde`
- `.config/wlogout`
- `.config/swaylock`
- `.config/fastfetch`
- `.config/swappy`
- `.themes`
- `.icons`

## Install

```bash
./install.sh
```

The installer:

- backs up existing target files with a timestamped `.bak.*` suffix
- creates parent directories as needed
- symlinks the tracked files into `$HOME`

## Notes

- Some tools referenced by these configs are expected to be installed separately, including `delta`, `atuin`, `direnv`, `gh`, `zoxide`, `tmux`, `eza`, `bat`, `fd`, `fzf`, `hyprland`, `waybar`, `rofi`, `kitty`, `dunst`, `wlogout`, `swaylock`, and `fastfetch`.
- The repo includes the current GTK themes, the current icon/cursor themes, and the active HyDE theme. The full local icon collection and inactive HyDE theme bundle are intentionally not tracked because they are large.
