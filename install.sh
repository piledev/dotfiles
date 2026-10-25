#!/usr/bin/env bash
# dotfiles の設定を ~/.config に symlink で配置する。何度実行してもよい。
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
    echo "既存のファイルを退避: $backup"
  fi
  ln -s "$src" "$dst"
  echo "link: $dst -> $src"
}

if command -v brew >/dev/null 2>&1; then
  brew bundle --file="$DOTFILES/Brewfile"
else
  echo "Homebrew が見つからないのでツールのインストールを飛ばします" >&2
fi

link "$DOTFILES/nvim" "$HOME/.config/nvim"
# herdr のディレクトリには session やログも置かれるので、設定ファイルだけをリンクする
link "$DOTFILES/herdr/config.toml" "$HOME/.config/herdr/config.toml"
link "$DOTFILES/zsh/zshrc" "$HOME/.zshrc"

echo "完了。nvim を起動するとプラグインがインストールされます。"
