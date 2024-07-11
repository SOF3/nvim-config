vim.call('plug#begin')

local Plug = vim.fn['plug#']

-- Language
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-dap'
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})

-- Behaviour
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'windwp/nvim-autopairs'
Plug 'preservim/nerdtree'
Plug 'haya14busa/incsearch.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-eunuch'
Plug 'salsifis/vim-transpose'
Plug 'hrsh7th/nvim-cmp'
Plug('L3MON4D3/LuaSnip', {['tag'] = 'v2.*', ['do'] = 'make install_jsregexp'})
Plug 'hrsh7th/cmp-nvim-lsp'

-- Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-file-browser.nvim'

-- Cosmetic
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'enricobacis/vim-airline-clock'
Plug 'Yggdroot/indentLine'
Plug 'f-person/git-blame.nvim'
Plug 'catppuccin/nvim'

vim.call('plug#end')
