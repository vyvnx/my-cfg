# ~/.zshrc — portable config (managed by vynx.cfg)
# Machine-specific env lives in ~/.zshrc.local (gitignored), sourced at the end.

# --- oh-my-zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="half-life"
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

# --- Node / NVM ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- pnpm ---
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --- Go ---
export PATH="$PATH:/usr/local/go/bin"

# --- Neovim ---
export PATH="$PATH:/opt/nvim-linux64/bin"

# --- Aliases ---
alias py="python3"
alias pstart="python3 -m venv .venv && source .venv/bin/activate"
alias nv="nvim ."

# --- Machine-specific overrides (not tracked in git) ---
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
