# dotfiles

Settings for nvim (Neovim 0.12 / vim.pack), herdr, and zsh.
Keys and commands worth remembering: [CHEATSHEET.md](CHEATSHEET.md).

## Setup

```sh
git clone https://github.com/piledev/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

- Installs the tools in `Brewfile` (Neovim, ghostty, LSP servers, etc.) and symlinks the settings into place
- Moves any existing settings aside to `*.bak.<timestamp>`
- herdr is not in the Brewfile; install it with the official instructions

### zsh

Install oh-my-zsh and zsh-autosuggestions separately.

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
```

Put machine-specific settings (work PATHs, credentials, etc.) in `~/.zshrc.local`.
This file is not tracked in the repository.

## Updating nvim plugins

`:lua vim.pack.update()`, then `:w` in the confirmation buffer to apply or `:q` to cancel.
Updating changes `nvim/nvim-pack-lock.json`, so commit it.
