# dotfiles

Personal shell, Git, tmux, and Code - OSS config.

## Files

- `.gitconfig`
- `.zshrc`
- `.tmux.conf`
- `.config/Code - OSS/User/settings.json`

## Install

```bash
./install.sh
```

The installer:

- backs up existing target files with a timestamped `.bak.*` suffix
- creates parent directories as needed
- symlinks the tracked files into `$HOME`

## Notes

- Some tools referenced by these configs are expected to be installed separately, including `delta`, `atuin`, `direnv`, `gh`, `zoxide`, `tmux`, `eza`, `bat`, `fd`, and `fzf`.
