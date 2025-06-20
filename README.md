## My Dotfiles

Minimal ZSH setup with plugins and Fastfetch.

### 🔧 Installation

```zsh
chmod +x install.sh
./install.sh
```

This script installs Oh My Zsh, adds plugins (`zsh-autosuggestions`, `zsh-syntax-highlighting`), copies dotfiles, and backs up your existing `.zshrc` if present.

### 🐱 Nekofetch (Fastfetch Logo)

To display a custom image with Fastfetch:

```bash
~/.fastfetch/logo.png
```

Use any PNG/JPG image — for example, a `nekofetch` catgirl render.

### 📦 Contents

* `.zshrc` — main ZSH config (preferred)
* `.bashrc` — main Bash config
* `.vars` — environment variables
* `.glob/` — $PATH folder to user scripts
* `.fastfetch/` — Fastfetch config + logo

### 📋 Requirements

* `zsh`, `git`, `fastfetch`, `yad`
