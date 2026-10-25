-- Minimal setup for reading, jumping, tree, and Markdown (Neovim 0.12 / vim.pack)

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable netrw because it conflicts with nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Basics ---------------------------------------------------------------
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

-- Automatically reload files rewritten by Claude Code
vim.o.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  callback = function()
    if vim.fn.mode() ~= 'c' then vim.cmd.checktime() end
  end,
})

-- Plugins --------------------------------------------------------------
-- nvim-treesitter updates its parsers on install and update
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

-- Find files and text --------------------------------------------------
local fzf = require('fzf-lua')
fzf.setup({})
vim.keymap.set('n', '<leader><leader>', fzf.files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>/', fzf.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fw', fzf.grep_cword, { desc = 'Grep word under cursor' })
vim.keymap.set('n', '<leader>fb', fzf.buffers, { desc = 'Open buffers' })
vim.keymap.set('n', '<leader>fr', fzf.oldfiles, { desc = 'Recent files' })
vim.keymap.set('n', '<leader>fs', fzf.lsp_document_symbols, { desc = 'Document symbols' })
vim.keymap.set('n', '<leader>fh', fzf.helptags, { desc = 'Help tags' })

-- Tree view ------------------------------------------------------------
require('nvim-tree').setup({
  view = { width = 35 },
  update_focused_file = { enable = true },
  filters = { git_ignored = false },
})
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeFindFileToggle<cr>', { desc = 'Toggle tree' })

-- LSP (go to definition) -------------------------------------------------
-- Install the servers with brew: gopls / typescript-language-server / marksman
vim.lsp.enable({ 'gopls', 'ts_ls', 'marksman' })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    -- K (hover), grn (rename), and gra (code action) are Neovim defaults
    map('gd', fzf.lsp_definitions, 'Go to definition')
    map('grr', fzf.lsp_references, 'List references')
    map('gri', fzf.lsp_implementations, 'List implementations')
    map('gy', fzf.lsp_typedefs, 'Go to type definition')
  end,
})

vim.diagnostic.config({ virtual_text = true })

-- Syntax highlighting ---------------------------------------------------
-- Markdown parsers ship with Neovim
require('nvim-treesitter').install({
  'go', 'gomod', 'gosum', 'typescript', 'tsx', 'javascript',
  'json', 'yaml', 'toml', 'sql', 'bash', 'html', 'css', 'dockerfile', 'diff',
})
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev) pcall(vim.treesitter.start, ev.buf) end,
})

-- Git changes -----------------------------------------------------------
require('gitsigns').setup({
  on_attach = function(buf)
    local gs = require('gitsigns')
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = buf, desc = desc })
    end
    map(']h', function() gs.nav_hunk('next') end, 'Next hunk')
    map('[h', function() gs.nav_hunk('prev') end, 'Previous hunk')
    map('<leader>hp', gs.preview_hunk, 'Preview hunk')
    map('<leader>hb', gs.blame_line, 'Blame line')
  end,
})

-- Changed-file tree + side-by-side diff (like VS Code's Source Control)
-- Diff of the whole branch: :DiffviewOpen origin/main...HEAD
require('diffview').setup({})
vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Open working tree diff' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'File history' })
vim.keymap.set('n', '<leader>gq', '<cmd>DiffviewClose<cr>', { desc = 'Close diff' })

-- Markdown ---------------------------------------------------------------
-- Rendered in normal mode; raw syntax on the cursor line and in insert mode
require('render-markdown').setup({})
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})
vim.keymap.set('n', '<leader>m', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Toggle Markdown rendering' })
