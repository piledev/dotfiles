# dotfiles

nvim（Neovim 0.12 / vim.pack）、herdr、zsh の設定。

## セットアップ

```sh
git clone https://github.com/piledev/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

- `Brewfile` のツール（Neovim、ghostty、LSP サーバーなど）を入れ、設定を symlink で配置する
- 既存の設定があれば `*.bak.<日時>` に退避する
- herdr は Brewfile に含めていないので、公式の手順でインストールする

### zsh

oh-my-zsh と zsh-autosuggestions は別途入れる。

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
```

PC 固有の設定（業務用の PATH、認証まわりなど）は `~/.zshrc.local` に書く。
このファイルはリポジトリに入れない。

## nvim のプラグイン更新

`:lua vim.pack.update()` → 確認画面で `:w` で反映、`:q` で取り消し。
更新すると `nvim/nvim-pack-lock.json` が変わるので commit する。
