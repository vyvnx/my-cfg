#!/usr/bin/env bash
#
# install.sh — symlink vynx.cfg into place. Idempotent and safe to re-run.
# Existing files at a target are moved to ~/.dotfiles-backup/<timestamp>/ first.
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# source-in-repo : target-on-system
LINKS=(
  "zsh/.zshrc:$HOME/.zshrc"
  "zsh/.zprofile:$HOME/.zprofile"
  "nvim:$HOME/.config/nvim"
  "tmux:$HOME/.config/tmux"
)

backup() {
  local target="$1"
  mkdir -p "$BACKUP_DIR"
  mv "$target" "$BACKUP_DIR/$(basename "$target")"
  echo "  backed up $target -> $BACKUP_DIR/$(basename "$target")"
}

link_one() {
  local src="$REPO_DIR/$1" target="$2"
  mkdir -p "$(dirname "$target")"
  if [ -L "$target" ]; then
    if [ "$(readlink "$target")" = "$src" ]; then
      echo "  ok (already linked): $target"
      return
    fi
    rm "$target"                 # stale symlink — replace, nothing to back up
  elif [ -e "$target" ]; then
    backup "$target"
  fi
  ln -s "$src" "$target"
  echo "  linked: $target -> $src"
}

echo "Installing vynx.cfg from $REPO_DIR"
for entry in "${LINKS[@]}"; do
  link_one "${entry%%:*}" "${entry#*:}"
done

# --- bootstrap dependencies ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing oh-my-zsh..."
  git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
else
  echo "  ok: oh-my-zsh present"
fi

# tpm lives at the default plugin path the tmux.conf loads (~/.tmux/plugins/tpm),
# which is independent of the config dir. Plugins themselves install here too.
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
  echo "Installing tpm..."
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "  ok: tpm present"
fi

# vim-plug — nvim's plugin manager. init.lua calls plug#begin, so this must exist
# before nvim starts or it errors out. Same bootstrap pattern as oh-my-zsh/tpm above.
PLUG_VIM="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
if [ ! -f "$PLUG_VIM" ]; then
  echo "Installing vim-plug..."
  curl -fLo "$PLUG_VIM" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
  echo "  ok: vim-plug present"
fi

# install nvim plugins headlessly (replaces the manual :PlugInstall). --sync blocks
# until done so +qall doesn't quit early. Mason servers/formatters and treesitter
# parsers still finish on the first real launch.
if command -v nvim >/dev/null 2>&1; then
  echo "Syncing nvim plugins..."
  nvim --headless +'PlugInstall --sync' +qall 2>/dev/null || true
else
  echo "  skip: nvim not found — install it, then run: nvim +'PlugInstall --sync' +qall"
fi

# install tmux plugins headlessly (replaces the manual prefix + I).
if [ -x "$TPM_DIR/bin/install_plugins" ]; then
  echo "Installing tmux plugins..."
  "$TPM_DIR/bin/install_plugins" >/dev/null 2>&1 || true
fi

if [ ! -f "$HOME/.zshrc.local" ]; then
  echo
  echo "No ~/.zshrc.local yet. Create one for this machine:"
  echo "  cp $REPO_DIR/zsh/.zshrc.local.example ~/.zshrc.local && \$EDITOR ~/.zshrc.local"
fi

cat <<'EOF'

Done. Plugins for nvim and tmux are installed. Last step:
  - exec zsh    # reload your shell (can't be done for you — it's your live shell)
EOF
