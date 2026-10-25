#!/usr/bin/env bash
# Symlink the dotfiles settings into place. Safe to run more than once.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    local backup="$dst.bak.$(date +%Y%m%d%H%M%S)"
    mv "$dst" "$backup"
    echo "Backed up existing file: $backup"
  fi
  ln -s "$src" "$dst"
  echo "link: $dst -> $src"
}

if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$DOTFILES/Brewfile"
else
  echo "Homebrew not found; skipping tool installation" >&2
fi

link "$DOTFILES/nvim" "$HOME/.config/nvim"
# The herdr directory also holds sessions and logs, so link only the config file
link "$DOTFILES/herdr/config.toml" "$HOME/.config/herdr/config.toml"
link "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"

echo "Done. Plugins are installed the first time you start nvim."
