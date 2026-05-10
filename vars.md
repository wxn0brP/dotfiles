# Environment Variables

This document describes the essential environment variables used across the dotfiles configuration.

## Shell Configuration

### `.zshrc`

| Variable | Value | Purpose | Location |
|----------|-------|---------|----------|
| `newll` | `false` | Controls whether prompt shows on new line | `.zshrc` |

## Editor Configuration

### `.vars`

| Variable | Value | Purpose | Location |
|----------|-------|---------|----------|
| `SUDO_EDITOR` | `kwrite` | Editor used by sudo when editing files | `.vars` |
| `VISUAL` | `nano` | Preferred visual editor | `.vars` |
| `EDITOR` | `nano` | Default command-line editor | `.vars` |

## PATH Extensions

The following directories are added to `PATH` in `.vars`:

| Directory | Purpose |
|-----------|---------|
| `~/.glob` | User's global utility scripts |
| `~/dotfiles/.glob` | Dotfiles utility scripts (destructure, viol, nit, etc.) |
| `~/.ing` | Globally linked npm executables |
| `~/.bun/bin` | Bun package manager binaries |
| `~/.npm-global/bin` | Global npm packages |
| `~/.local/bin` | User's local binaries |
| `~/.zhiva/bin` | Zhiva project binaries |

## Nit Project Generator

### `.glob/nit`

| Variable | Default | Purpose | Location |
|----------|---------|---------|----------|
| `NIT_USER` | `$(whoami)` | Git user/author name for generated projects | `.glob/nit` |

## Notes

- All variables are sourced from `~/dotfiles/.vars` and `~/.vars` in both shells
- The `newll` variable controls prompt layout in zsh
