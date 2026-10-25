# Cheatsheet

Only the keys worth remembering. For the full list, ask the tool itself:

| Tool | Full list |
| --- | --- |
| nvim | `<Space>fk` (search keymaps by description) |
| herdr | `Ctrl-b ?`, or `herdr --default-config` |
| ghostty | `Cmd-Shift-P` (command palette), or `ghostty +list-keybinds --default` |

## herdr

Prefix is `Ctrl-b`: press it, release, then press the key below.

### Panes

| Key | Action |
| --- | --- |
| `v` | Split right |
| `-` | Split down |
| `h` `j` `k` `l` | Focus left / down / up / right |
| `Tab` / `Shift-Tab` | Cycle panes |
| `z` | Zoom pane |
| `r` | Resize mode |
| `x` | Close pane |
| `e` | Edit scrollback in an editor |

### Tabs

| Key | Action |
| --- | --- |
| `c` | New tab |
| `n` / `p` | Next / previous tab |
| `1`..`9` | Go to tab |
| `Shift-T` | Rename tab |
| `Shift-X` | Close tab |

### Workspaces and session

| Key | Action |
| --- | --- |
| `w` | Workspace picker |
| `Shift-N` | New workspace |
| `Shift-G` | New git worktree |
| `Shift-W` | Rename workspace |
| `Shift-D` | Close workspace |
| `g` | Go to |
| `o` | Jump to the notification's pane |
| `b` | Toggle sidebar |
| `s` | Settings |
| `q` | Detach (panes keep running; `herdr` reattaches) |
| `Shift-R` | Reload config |
| `?` | Show all bindings |

## ghostty

| Key | Action |
| --- | --- |
| `Cmd-T` / `Cmd-W` | New tab / close |
| `Cmd-1`..`Cmd-8` / `Cmd-9` | Go to tab / last tab |
| `Cmd-Shift-[` / `Cmd-Shift-]` | Previous / next tab |
| `Cmd-F` / `Cmd-G` | Search / next match |
| `Cmd-Up` / `Cmd-Down` | Jump to previous / next prompt |
| `Cmd-K` | Clear screen |
| `Cmd-=` / `Cmd--` / `Cmd-0` | Font size up / down / reset |
| `Cmd-Enter` | Toggle fullscreen |
| `Cmd-Shift-P` | Command palette |
| `Cmd-,` / `Cmd-Shift-,` | Open / reload config |

Splits (`Cmd-D`, `Cmd-Shift-D`) also exist, but use herdr for panes.

## nvim

Leader is `Space`.

### Find

| Key | Action |
| --- | --- |
| `<Space><Space>` | Find files |
| `<Space>/` | Live grep |
| `<Space>fw` | Grep word under cursor |
| `<Space>fb` | Open buffers |
| `<Space>fr` | Recent files |
| `<Space>fs` | Document symbols |
| `<Space>fh` | Help tags |
| `<Space>fk` | Search keymaps |
| `<Space>e` | Toggle file tree |

In a picker: `Enter` open, `Ctrl-v` / `Ctrl-s` open in vertical / horizontal split.
In the tree: `l` expand / open, `h` collapse to parent, `a` add, `r` rename, `d` delete, `f` / `F` filter / clear filter, `Ctrl-]` / `-` set root here / root up, `g?` help.
Move between tree and editor: `Ctrl-w h` to the tree, `Ctrl-w p` back (`<Space>e` closes an open tree instead of focusing it).

### Code (LSP)

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `gy` | Go to type definition |
| `grr` | List references |
| `gri` | List implementations |
| `K` | Hover docs |
| `grn` | Rename |
| `gra` | Code action |
| `]d` / `[d` | Next / previous diagnostic |
| `Ctrl-o` / `Ctrl-i` | Jump back / forward |
| `gcc` | Toggle comment |

### Git

| Key | Action |
| --- | --- |
| `]h` / `[h` | Next / previous hunk |
| `<Space>hp` | Preview hunk |
| `<Space>hb` | Blame line |
| `<Space>gb` | Branches (`Enter` switches) |
| `<Space>gd` | Open working tree diff |
| `<Space>gh` | History of this file |
| `<Space>gq` | Close diff |

In the diff view: `Tab` / `Shift-Tab` next / previous file.
Whole branch: `:DiffviewOpen origin/main...HEAD`.

### Other

| Key | Action |
| --- | --- |
| `<Space>m` | Toggle Markdown rendering |
| `:lua vim.pack.update()` | Update plugins (`:w` apply, `:q` cancel) |

## zsh

| Key / command | Action |
| --- | --- |
| `Ctrl-T` | Insert a file path with fzf |
| `Ctrl-R` | Search history (`Ctrl-Y` copies the command) |
| `Alt-C` | cd into a directory with fzf |
| `fbr` | Check out a branch with fzf |
| `fshow` | Browse commits with fzf |
| `nv` / `hd` | nvim / herdr |
| `zconf` | Edit `~/.zshrc` |
