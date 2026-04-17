# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# 0. Zsh Native Behavior & History Configuration
# =============================================================================
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/.zsh_history" # Location of history file
HISTSIZE=50000                 # Number of history entries kept in memory
SAVEHIST=50000                 # Number of history entries saved to file

setopt EXTENDED_HISTORY        # Record timestamps and duration of commands
setopt INC_APPEND_HISTORY      # Append commands to history immediately
setopt SHARE_HISTORY           # Share history across multiple terminal sessions
setopt HIST_IGNORE_DUPS        # Do not record consecutive duplicate commands

# =============================================================================
# 1. Zinit Core Initialization
# =============================================================================
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# =============================================================================
# 2. Powerlevel10k Theme (Synchronous loading to prevent UI flicker)
# =============================================================================
zinit ice depth"1"
zinit light romkatv/powerlevel10k

# =============================================================================
# 3. Core Plugins (Asynchronous loading via Turbo Mode)
# =============================================================================

# Completion system library
zinit ice wait"0" lucid blockf
zinit light zsh-users/zsh-completions

# Syntax highlighting (Continuum community edition)
zinit ice wait"0" lucid
zinit light zdharma-continuum/fast-syntax-highlighting

# Auto-suggestions based on command history
zinit ice wait"0" lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# =============================================================================
# 4. Completion System Initialization & Enhancement (Critical Step)
# =============================================================================
autoload -Uz compinit
compinit

# fzf-tab must be loaded strictly after compinit
zinit ice wait"0" lucid
zinit light Aloxaf/fzf-tab

# =============================================================================
# 5. User Experience & Keybindings
# =============================================================================

# Initialize fzf native keybindings and completion
source <(fzf --zsh)

# Vim mode (Synchronous loading recommended to prevent missed keystrokes on startup)
zinit ice depth"1"
zinit light jeffreytse/zsh-vi-mode

# History substring search (Bound to Up/Down arrow keys)
zinit ice wait"0" lucid atload'bindkey "$terminfo[kcuu1]" history-substring-search-up; bindkey "$terminfo[kcud1]" history-substring-search-down'
zinit light zsh-users/zsh-history-substring-search

# =============================================================================
# 6. Modern Directory Navigation: Zoxide
# =============================================================================
eval "$(zoxide init zsh)"

# =============================================================================
# 7. GNU color support and common aliases (aligned with Ubuntu .bashrc)
# =============================================================================
if [[ -x /usr/bin/dircolors ]]; then
  if [[ -r ~/.dircolors ]]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi

  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# -----------------------------------------------------------------------------
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
