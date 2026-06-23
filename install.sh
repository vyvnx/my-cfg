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

if [ ! -f "$HOME/.zshrc.local" ]; then
  echo
  echo "No ~/.zshrc.local yet. Create one for this machine:"
  echo "  cp $REPO_DIR/zsh/.zshrc.local.example ~/.zshrc.local && \$EDITOR ~/.zshrc.local"
fi

cat <<'EOF'

Done. Next steps:
  - exec zsh                          # reload your shell
  - tmux, then press: prefix + I      # install tmux plugins via tpm
  - open nvim                         # let the plugin manager sync
EOF
