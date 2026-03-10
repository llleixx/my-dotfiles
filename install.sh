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

if [ "$INSTALL_ALL" = true ]; then
    INSTALL_ZSH=true
    INSTALL_VIM=true
    INSTALL_GIT=true
fi

# =============================================================================
# Dependency Resolution
# =============================================================================
echo "📦 Resolving system dependencies..."
PACKAGES=("curl" "tar")

# Note: fzf has been removed from apt packages to avoid outdated versions
[ "$INSTALL_ZSH" = true ] && PACKAGES+=("zsh" "zoxide")
[ "$INSTALL_VIM" = true ] && PACKAGES+=("vim")
[ "$INSTALL_GIT" = true ] && PACKAGES+=("git")

sudo apt update
sudo apt install -y "${PACKAGES[@]}"

# =============================================================================
# Deployment Execution
# =============================================================================

if [ "$INSTALL_ZSH" = true ]; then
    echo "🚀 Deploying Zsh environment..."

    # --- 🌟 Install Latest fzf via Pre-compiled Release ---
    # Remove the outdated apt version if it exists
    if dpkg -l | grep -q "^ii  fzf"; then
        echo "🗑️ Removing outdated apt version of fzf..."
        sudo apt remove -y fzf
    fi

    # Determine system architecture
    ARCH=$(uname -m)
    case $ARCH in
        x86_64) FZF_ARCH="amd64" ;;
        aarch64|arm64) FZF_ARCH="arm64" ;;
        *) echo "⚠️ Unsupported architecture for fzf auto-install: $ARCH. Skipping fzf."; FZF_ARCH="" ;;
    esac

    if [ -n "$FZF_ARCH" ]; then
        echo "🔍 Fetching latest fzf version from GitHub..."
        # Use GitHub API to get the latest release tag dynamically
        FZF_VERSION=$(curl -s https://api.github.com/repos/junegunn/fzf/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')

        # Fallback mechanism in case of API rate limit or network failure
        if [ -z "$FZF_VERSION" ]; then
            echo "⚠️ Failed to fetch version from API. Falling back to 0.70.0"
            FZF_VERSION="0.70.0"
        fi

        echo "📌 Latest version resolved: v${FZF_VERSION}"
        FZF_URL="https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_${FZF_ARCH}.tar.gz"

        echo "⬇️ Downloading fzf v${FZF_VERSION} for linux_${FZF_ARCH}..."
        curl -fsSL "$FZF_URL" -o /tmp/fzf.tar.gz

        echo "📦 Extracting and installing fzf..."
        tar -xzf /tmp/fzf.tar.gz -C /tmp
        sudo mv /tmp/fzf /usr/local/bin/fzf
        sudo chmod +x /usr/local/bin/fzf
        rm /tmp/fzf.tar.gz
        echo "✅ fzf installed successfully."
    fi
    # ---------------------------------------------------------

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
