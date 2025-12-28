# My Dotfiles

Minimal ZSH setup with plugins and Fastfetch.

## 🔧 Installation

### 💜 Tui for interactive setup:

```zsh
./tui.sh
```

### 💜 Manual setup

Basic setup

```zsh
./install.sh
```

Install my tools and scripts into `~/.ing` and `~/.ingr`. (requires Bun)

```zsh
./install.ing.sh
```

Install Node.js, Yarn, etc.

```zsh
./install.node.sh --step install # install Node.js (nvm)
./install.node.sh # install pkg
```

## Scripts

### `recommended.sh`

This script helps install a predefined list of recommended applications.

**Usage:**

*   **Interactive Mode:** Run the script without arguments to open an interactive menu where you can select which application(s) to install.
    ```bash
    ./recommended.sh
    ```

*   **Install All:** Install all recommended applications at once.
    ```bash
    ./recommended.sh all
    ```

*   **Install Specific Apps:** Provide the names of the applications you want to install as arguments.
    ```bash
    ./recommended.sh Lyth Zhiva
    ```

## 🐱 Nekofetch

To display a **custom image** (like a neko/catgirl render) instead of the default logo in Fastfetch, you need to place the image file in the correct location and name it precisely.

### Setup Instructions

1.  Choose any PNG or JPG image you want to use.

2.  Save this image as **`logo.png`**.

3.  Place the `logo.png` file directly into your Fastfetch configuration directory:

    ```bash
    ~/.fastfetch/logo.png
    ```

Fastfetch will automatically detect and display this image when run.

## 📦 Contents

* `.zshrc` — main ZSH config (preferred)
* `.bashrc` — main Bash config
* `.vars` — environment variables
* `.glob/` — $PATH folder to user scripts
* `.fastfetch/` — Fastfetch config + logo

### 📚 Docs

- [Glob Scripts](glob.md)

## 📋 Requirements

* `zsh`
* `git`
* `fastfetch`
* `yad`
* `bun`
