# 🚀 My Dotfiles

A blazing-fast, modular, and highly optimized terminal environment setup, primarily designed for Debian-based Linux distributions. 

This repository leverages **Zinit** (with Turbo Mode) for sub-millisecond Zsh startup times, alongside modern CLI tools like `fzf`, `zoxide`, and a highly productive Git configuration.

## ✨ Core Features

* **⚡ Ultra-Fast Zsh:** Powered by [Zinit](https://github.com/zdharma-continuum/zinit) using asynchronous loading (Turbo Mode).
* **🎨 Beautiful Prompt:** [Powerlevel10k](https://github.com/romkatv/powerlevel10k) pre-configured for instant rendering and Git status integration.
* **🔍 Fuzzy Finding Everywhere:** Deep integration with `fzf` for command history (`Ctrl+R`), file searching (`Ctrl+T`), and interactive tab completion (`fzf-tab`).
* **🚀 Smart Navigation:** Directory jumping using `zoxide`.
* **⌨️ Vim Mode:** Full Vi keybindings in the terminal with visual mode indicators.
* **🛠️ Supercharged Git:** Custom aliases including a beautiful commit graph (`git lg`), quick undo (`git undo`), and streamlined rebase pulling.
* **📦 Modular Deployment:** An installation script that allows you to install only what you need (e.g., just Git config, or just Zsh).

## 🚀 Installation

### Prerequisites

* A Debian-based system (Ubuntu, Debian, Linux Mint, etc.) with `apt` package manager.
* `curl` installed (`sudo apt install curl`).

### One-Line Installation (Default)

To install the complete environment (Zsh, Vim, and Git configurations), run the following command in your terminal:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/llleixx/my-dotfiles/main/install.sh)"
```

### Modular Installation (Custom Flags)

If you only want to deploy specific parts of the configuration to a server, you can pass arguments to the script. 

*(Note: You must include the `--` before the flags when executing via `curl`.)*

**Available Flags:**

* `--zsh` : Installs Zsh, fzf, zoxide, and the `.zshrc` / `.p10k.zsh` configs.
* `--vim` : Installs Vim and the `.vimrc` config.
* `--git` : Installs Git and the `.gitconfig` config.
* `--all` : Installs everything (default behavior).

**Example: Install only Git and Vim configurations:**
    
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/llleixx/my-dotfiles/main/install.sh)" -- --git --vim
```

## 🏁 Post-Installation

If you installed the Zsh environment, simply restart your terminal or type:

```bash
zsh
```

On the first run, **Zinit** will automatically bootstrap itself and securely download all required plugins in the background. Enjoy your new terminal!
