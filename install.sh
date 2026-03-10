#!/bin/bash

# =============================================================================
# Configuration & Flags
# =============================================================================
INSTALL_ALL=true
INSTALL_ZSH=false
INSTALL_VIM=false
INSTALL_GIT=false

# Parse command-line arguments
if [[ "$#" -gt 0 ]]; then
    INSTALL_ALL=false
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --all|-a) INSTALL_ALL=true ;;
            --zsh)    INSTALL_ZSH=true ;;
            --vim)    INSTALL_VIM=true ;;
            --git)    INSTALL_GIT=true ;;
            --help|-h)
                echo "Usage: $0 [options]"
                echo "Options:"
                echo "  --all, -a    Deploy all configurations (default behavior)"
                echo "  --zsh        Deploy only Zsh environment"
                echo "  --vim        Deploy only Vim configuration"
                echo "  --git        Deploy only Git configuration"
                echo "  --help, -h   Display this help message"
                exit 0
                ;;
            *)
                echo "❌ Unknown parameter: $1"
                echo "Run '$0 --help' for usage information."
                exit 1
                ;;
        esac
        shift
    done
fi

# If --all is passed or no arguments are provided, enable all modules
if [ "$INSTALL_ALL" = true ]; then
    INSTALL_ZSH=true
    INSTALL_VIM=true
    INSTALL_GIT=true
fi

# =============================================================================
# Dependency Resolution
# =============================================================================
echo "📦 Resolving system dependencies..."
PACKAGES=("curl")

[ "$INSTALL_ZSH" = true ] && PACKAGES+=("zsh" "fzf" "zoxide")
[ "$INSTALL_VIM" = true ] && PACKAGES+=("vim")
[ "$INSTALL_GIT" = true ] && PACKAGES+=("git")

sudo apt update
sudo apt install -y "${PACKAGES[@]}"

# =============================================================================
# Deployment Execution
# =============================================================================

if [ "$INSTALL_ZSH" = true ]; then
    echo "🚀 Deploying Zsh environment..."
    curl -fsSL https://raw.githubusercontent.com/llleixx/my-dotfiles/main/.zshrc -o ~/.zshrc
    curl -fsSL https://raw.githubusercontent.com/llleixx/my-dotfiles/main/.p10k.zsh -o ~/.p10k.zsh

    echo "🔄 Configuring default shell to Zsh..."
    sudo chsh -s $(which zsh) $(whoami)
fi

if [ "$INSTALL_VIM" = true ]; then
    echo "🚀 Deploying Vim configuration..."
    curl -fsSL https://raw.githubusercontent.com/llleixx/my-dotfiles/main/.vimrc -o ~/.vimrc
fi

if [ "$INSTALL_GIT" = true ]; then
    echo "🚀 Deploying Git configuration..."
    curl -fsSL https://raw.githubusercontent.com/llleixx/my-dotfiles/main/.gitconfig -o ~/.gitconfig
fi

echo "✅ Deployment sequence complete."
[ "$INSTALL_ZSH" = true ] && echo "Please run 'zsh' to initialize your new shell."
