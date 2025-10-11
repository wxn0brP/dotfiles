## My Dotfiles

Minimal ZSH setup with plugins and Fastfetch.

### 🔧 Installation

```zsh
chmod +x install.sh
./install.sh
```

This script installs Oh My Zsh, adds plugins, copies dotfiles, and backs up your existing `.zshrc` if present.

```zsh
chmod +x install.node.sh
./install.node.sh --step install # install Node.js (nvm)
./install.node.sh # install pkg
```

This script installs Node.js and Yarn.

```zsh
chmod +x install.ing.sh
./install.ing.sh
```

This script installs my tools and scripts into `~/.ing` and `~/.ingr`. (requires Bun)

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

[Glob Scripts](glob.md)

### 📋 Requirements

* `zsh`, `git`, `fastfetch`, `yad`, `bun`
