# Environment Variables

This document describes the essential environment variables used across the dotfiles configuration.

## Shell Configuration

### `.zshrc`

| Variable | Value | Purpose | Location |
|----------|-------|---------|----------|
| `newll` | `false` | Controls whether prompt shows on new line | `.zshrc` |
| `NO_DOTFILES_UPDATE` | unset | Prevents the dotfiles from being updated | `.zshrc` |
| `NO_DOTFILES_PLUGINS_UPDATE` | unset | Prevents the dotfiles zsh plugins from being updated | `.zshrc` |
| `NO_ADD_NPM_BIN_TO_PATH` | unset | Prevents the `add_npm_bin_to_path` function from adding local npm binaries to `PATH` | `.zshrc` |

## Editor Configuration

### `.vars`

| Variable | Value | Purpose | Location |
|----------|-------|---------|----------|
| `SUDO_EDITOR` | `kwrite` | Editor used by sudo when editing files | `.vars` |
| `VISUAL` | `micro` | Preferred visual editor | `.vars` |
| `EDITOR` | `micro` | Default command-line editor | `.vars` |

## Shell Aliases

The following aliases and functions are defined in `.vars`:

| Alias | Target | Description |
|-------|--------|-------------|
| `cd..` | `cd ..` | Go up one directory |
| `ll` | `ls -al` | List all files with details |
| `cls` | `clear` | Clear terminal |
| `c` | `vscodium .` | Open current directory in VSCodium |
| `ce` | `c && exit` | Open VSCodium and exit shell |
| `py` | `python` | Python shortcut |
| `g` | `./girl.sh` | Run girl script |
| `cg` | `chmod +x ./girl.sh` | Make girl.sh executable |
| `ng` | `nano ./girl.sh` | Edit girl.sh in nano |
| `p` | `cd ~/Desktop` | Go to Desktop |
| `code` | `vscodium` | Open VSCodium |
| `exot` | `exit` | Exit shell (typo variant) |
| `exut` | `exit` | Exit shell (typo variant) |
| `ipc` | `ip -br addr` | Show IP addresses |
| `dots-up` | `git pull` in dotfiles | Update dotfiles repository |
| `nit` | `nitl` | Alias for library project generator |
| `uuu` | `paru -Syu` | Full system update via paru |

## PATH Extensions

The following directories are added to `PATH` in `.vars`:

| Directory | Purpose |
|-----------|---------|
| `~/.glob` | User's global utility scripts |
| `~/dotfiles/glob` | Dotfiles utility scripts (destructure, viol, nit, etc.) |
| `~/.ing` | Globally linked npm executables |
| `~/.bun/bin` | Bun package manager binaries |
| `~/.npm-global/bin` | Global npm packages |
| `~/.local/bin` | User's local binaries |
| `~/.zhiva/bin` | Zhiva project binaries |

## Nit Project Generator

### `glob/nit`

| Variable | Default | Purpose | Location |
|----------|---------|---------|----------|
| `NIT_USER` | `$(whoami)` | Git user/author name for generated projects | `glob/nit` |

## Notes

- All variables are sourced from `~/dotfiles/.vars` and `~/.vars` in both shells
- The `newll` variable controls prompt layout in zsh
