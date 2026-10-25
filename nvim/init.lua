-- 読む・飛ぶ・tree・Markdown に絞った最小構成（Neovim 0.12 / vim.pack）

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- nvim-tree と競合するので netrw は無効化
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- 基本設定 -------------------------------------------------------------
vim.o.number = true
vim.o.signcolumn = 'yes'
vim.o.cursorline = true
vim.o.scrolloff = 8
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.clipboard = 'unnamedplus'
vim.o.undofile = true
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.updatetime = 300

-- Claude Code が書き換えたファイルを自動で読み直す
vim.o.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  callback = function()
    if vim.fn.mode() ~= 'c' then vim.cmd.checktime() end
  end,
})

-- プラグイン -----------------------------------------------------------
-- nvim-treesitter はインストール・更新時にパーサーを更新する
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
      vim.cmd('TSUpdate')
    end
  end,
})

local gh = function(x) return 'https://github.com/' .. x end
vim.pack.add({
  gh('nvim-tree/nvim-web-devicons'),
  gh('ibhagwan/fzf-lua'),
  gh('nvim-tree/nvim-tree.lua'),
  gh('neovim/nvim-lspconfig'),
  { src = gh('nvim-treesitter/nvim-treesitter'), version = 'main' },
  gh('lewis6991/gitsigns.nvim'),
  gh('sindrets/diffview.nvim'),
  gh('MeanderingProgrammer/render-markdown.nvim'),
})

-- ファイル検索・文字列検索 ---------------------------------------------
local fzf = require('fzf-lua')
fzf.setup({})
vim.keymap.set('n', '<leader><leader>', fzf.files, { desc = 'ファイルを開く' })
vim.keymap.set('n', '<leader>/', fzf.live_grep, { desc = '文字列検索' })
vim.keymap.set('n', '<leader>fw', fzf.grep_cword, { desc = 'カーソル下の単語を検索' })
vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = '開いているバッファ' })
vim.keymap.set('n', '<leader>fr', fzf.oldfiles, { desc = '最近開いたファイル' })
vim.keymap.set('n', '<leader>fs', fzf.lsp_document_symbols, { desc = 'ファイル内のシンボル' })
vim.keymap.set('n', '<leader>fh', fzf.helptags, { desc = 'ヘルプ' })

-- tree 表示 ------------------------------------------------------------
require('nvim-tree').setup({
  view = { width = 35 },
  update_focused_file = { enable = true },
  filters = { git_ignored = false },
})
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFindFileToggle<cr>', { desc = 'tree を開閉' })

-- LSP（定義ジャンプ）-----------------------------------------------------
-- サーバー本体は brew で入れる: gopls / typescript-language-server / marksman
vim.lsp.enable({ 'gopls', 'ts_ls', 'marksman' })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    -- K（ホバー）、grn（リネーム）、gra（コードアクション）は Neovim 標準
    map('gd', fzf.lsp_definitions, '定義へ')
    map('grr', fzf.lsp_references, '参照一覧')
    map('gri', fzf.lsp_implementations, '実装一覧')
    map('gy', fzf.lsp_typedefs, '型定義へ')
  end,
})

vim.diagnostic.config({ virtual_text = true })

-- シンタックスハイライト ------------------------------------------------
-- markdown 系のパーサーは Neovim 本体に同梱されている
require('nvim-treesitter').install({
  'go', 'gomod', 'gosum', 'typescript', 'tsx', 'javascript',
  'json', 'yaml', 'toml', 'sql', 'bash', 'html', 'css', 'dockerfile', 'diff',
})
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev) pcall(vim.treesitter.start, ev.buf) end,
})

-- git の変更箇所 --------------------------------------------------------
require('gitsigns').setup({
  on_attach = function(buf)
    local gs = require('gitsigns')
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = buf, desc = desc })
    end
    map(']h', function() gs.nav_hunk('next') end, '次の変更箇所')
    map('[h', function() gs.nav_hunk('prev') end, '前の変更箇所')
    map('<leader>hp', gs.preview_hunk, '変更内容を表示')
    map('<leader>hb', gs.blame_line, 'この行の blame')
  end,
})

-- 変更ファイルの tree + 左右比較（VS Code のソース管理に相当）
-- ブランチ全体の差分は :DiffviewOpen origin/main...HEAD
require('diffview').setup({})
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = '作業中の差分を開く' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'このファイルの変更履歴' })
vim.keymap.set('n', '<leader>gq', '<cmd>DiffviewClose<cr>', { desc = '差分を閉じる' })

-- Markdown ---------------------------------------------------------------
-- ノーマルモードでは整形表示、カーソル行と挿入モードでは生の記法が見える
require('render-markdown').setup({})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})
vim.keymap.set('n', '<leader>m', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Markdown 整形表示の切替' })
