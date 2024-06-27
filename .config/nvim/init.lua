-- ==========================================================================
--                                Editor Settings
-- Useful Options
-- Syntax: vim.opt.opt_name = 'opt_value'
-- :help vim.opt
-- ==========================================================================
-- line number
vim.opt.number = true

-- The options I don't like
-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = 'unnamedplus'

-- mouse mode: previous mode
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- when executing search Case-insensitive searching UNLESS \C
-- or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- highlight search
vim.opt.hlsearch = true

-- autowrap line when too long
vim.opt.wrap = true

-- Preserve the indentation of a virtual line
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- The amount of space on screen a Tab
vim.opt.tabstop = 4

-- Amount of characters Neovim will use to indent a line
vim.opt.shiftwidth = 4

-- transform a Tab character to spaces
vim.opt.expandtab = true

-- color ui
vim.opt.termguicolors = true

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10


-- ==========================================================================
--                                Keybindings
-- Syntax: vim.keymap.set({mode}, {lhs}, {rhs}, {opts})
-- :help vim.keymap.set
vim.g.mapleader = ' '       -- Leader key is space
vim.g.maplocalleader = ' '  -- local leaker key is space
-- Shortcuts
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<cr>', {desc='clear highlight search'})
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>', {desc='C-A'})
vim.keymap.set({'n', 'x', 'o'}, '<leader>h', '^', {desc='jump to line start'})
vim.keymap.set({'n', 'x', 'o'}, '<leader>l', 'g_', {desc='jump to line end'})
-- Basic clipboard interaction
-- This may not take effect as I don't know how to provide a provider
vim.keymap.set({'n', 'x'}, 'gy', '"+y', {desc='Copy to clipboard'})
vim.keymap.set({'n', 'x'}, 'gp', '"+p', {desc='Paste from clipboard'})

vim.keymap.set({'n'}, '<F3>', '<cmd>Lexplore<cr>')
-- Commands
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>', {desc='Save'})
vim.keymap.set('n', '<leader>j', '<cmd>tabnext<cr>', {desc='tabnext'})
vim.keymap.set('n', '<leader>k', '<cmd>tabprev<cr>', {desc='tabprev'})
vim.keymap.set('n', '<leader>n', ':tabnew ', {desc='tabnew'})
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>', {desc='tab bd'})
vim.keymap.set('n', '<leader>bl', '<cmd>buffer #<cr>', {desc='buffer next file'})
-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
-- I don't like the following settings.
-- vim.keymap.set({'n', 'x'}, 'x', '"_x', {desc='Delete without changing the registers'})
-- vim.keymap.set({'n', 'x'}, 'X', '"_d', {desc='Delete without changing the registers'})

-- ==========================================================================
--                            Self-defined Commands
-- ==========================================================================
vim.api.nvim_create_user_command('ConfigReload', 'source $MYVIMRC', {})
vim.api.nvim_create_user_command('ConfigEcho', 'echo $MYVIMRC', {})
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- Delete trailing white space when saved file.
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

-- ==========================================================================
--                              Plugins Manager
-- ==========================================================================
-- Plugin Manager - lazy.vim
-- Install lazy.vim from github
local lazy = {}

function lazy.install(path)
  if not vim.loop.fs_stat(path) then
    print('Installing lazy.nvim...')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable', -- latest stable release
      path,
    })
  end
end

function lazy.setup(plugins)
  if vim.g.plugins_ready then
    return
  end

  -- You could "comment out" the line below after lazy.nvim is installed
  lazy.install(lazy.path)

  vim.opt.rtp:prepend(lazy.path)

  require('lazy').setup(plugins, lazy.opts)
  vim.g.plugins_ready = true
end

-- :echo stdpath('data') .. '/lazy/lazy.nvim'
lazy.path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
lazy.opts = {}
lazy.setup({
  -- List of plugins
  -- Detect tabstop and shiftwidth automatically
  {'echasnovski/mini.nvim', branch = 'stable'},
  -- colorscheme tokyonight
  {'folke/tokyonight.nvim'},
  -- colorscheme onedark
  -- {'navarasu/onedark.nvim'},
  {'folke/which-key.nvim'},
  {'hrsh7th/nvim-cmp'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'hrsh7th/cmp-buffer'},
  {'kyazdani42/nvim-web-devicons'},     -- icons
  {
      'L3MON4D3/LuaSnip',
      opts={histoy = true, delete_check_events = "TextChanged",},
      dependencies = { "rafamadriz/friendly-snippets" },
      build = "make install_jsregexp",
  },
  {'nvim-lualine/lualine.nvim'},        -- lualine (statusline)
  {'nvim-lua/plenary.nvim', build = false},
  {'nvim-treesitter/nvim-treesitter'},
  {'nvim-telescope/telescope.nvim', branch = '0.1.x', build = false},
  {'natecraddock/telescope-zf-native.nvim', build = false},
  {'neovim/nvim-lspconfig'},
  {'rafamadriz/friendly-snippets'},
  {"saadparwaiz1/cmp_luasnip"},
  {'tpope/vim-sleuth'},
  {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
})

-- ==========================================================================
--                            Plugins Configuration
-- ==========================================================================
-- colorscheme
vim.cmd.colorscheme('tokyonight')

vim.g.netrw_banner = 0
vim.g.netrw_winsize = 30
-- See :help netrw-browse-maps
vim.keymap.set('n', '<leader>e', '<cmd>Lexplore<cr>', {desc = 'Toggle file explorer'})
vim.keymap.set('n', '<leader>E', '<cmd>Lexplore %:p:h<cr>', {desc = 'Open file explorer in current file'})

-- lua plugins
require('lualine').setup({
options = {
    icons_enabled = true,
    theme = 'tokyonight',
    component_separators = '|',
    section_separators = '',
  },
})

-- See :help nvim-treesitter-modules
require('nvim-treesitter.configs').setup({
  highlight = { enable = true, },
  auto_install = true,
  ensure_installed = {'lua', 'vim', 'vimdoc', 'json'},
})

-- See :help which-key.nvim-which-key-configuration
require('which-key').setup({})
require('which-key').register({
  ['<leader>f'] = {name = 'Fuzzy Find', _ = 'which_key_ignore'},
  ['<leader>b'] = {name = 'Buffer', _ = 'which_key_ignore'},
})

-- See :help MiniAi-textobject-builtin
require('mini.ai').setup({n_lines = 500})

-- See :help MiniComment.config
require('mini.comment').setup({})

-- See :help MiniSurround.config
require('mini.surround').setup({})

-- See :help MiniBufremove.config
require('mini.bufremove').setup({})

-- Close buffer and preserve window layout
vim.keymap.set('n', '<leader>bc', '<cmd>lua pcall(MiniBufremove.delete)<cr>', {desc = 'Close buffer'})

-- See :help telescope.builtin
vim.keymap.set('n', '<leader>?', '<cmd>Telescope oldfiles<cr>', {desc = 'Search file history'})
vim.keymap.set('n', '<leader><space>', '<cmd>Telescope buffers<cr>', {desc = 'Search open files'})
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', {desc = 'Search all files'})
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', {desc = 'Search in project'})
vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<cr>', {desc = 'Search diagnostics'})
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope current_buffer_fuzzy_find<cr>', {desc = 'Buffer local search'})

require('telescope').load_extension('zf-native')

-- lsp-zero will integrate lspconfig and cmp for you
-- If you wish to do that manually, see the code here:
-- https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/lsp.md#how-does-it-work
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- See :help lsp-zero-keybindings
  lsp_zero.default_keymaps({buffer = bufnr, preserve_mappings = false})
end)

-- See :help lspconfig-setup
-- require('lspconfig').tsserver.setup({})
-- require('lspconfig').eslint.setup({})
-- require('lspconfig').rust_analyzer.setup({})

local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()
local date = function() return {os.date('%Y-%m-%d')} end

-- See :help cmp-config
cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'buffer'},
  },
  formatting = lsp_zero.cmp_format({details = true}),
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({select = false}),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

-- snippets
local ls = require("luasnip")
local snippets = require("luasnip.loaders.from_vscode")
local filetype = vim.bo.filetype

ls.config.set_config({
    keep_roots = false,
    link_roots = false,
    link_children = false,
    region_check_events = 'InsertEnter',
    delete_check_events = 'InsertLeave'
  })
snippets.lazy_load({ paths = { snippets_path } })
ls.add_snippets(nil, {
  all = {
    ls.snippet({
      trig = "date",
      namr = "Date",
      dscr = "Date in the form of YYYY-MM-DD",
    }, {
      ls.function_node(date, {}),
    }),
  },
})
if vim.fn.argc() > 0 and filetype ~= '' then
    snippets.load({include = {filetype}})
end

vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})
