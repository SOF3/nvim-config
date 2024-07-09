set ai " auto-indent
set showmatch " show matching brackets
set ls=2 " status line
set showcmd " Show incomplete commands. Especially useful on phones via SSH.
set smd " show mode in last line
set clipboard= " disable clipboard integration. I don't want vim to override my system clipboard.
set mouse= " disable mouse integration. I want to copy words with my mouse directly without using visual mode.
set wildmode=list:longest,longest:full " command line completion

set hidden " I'm not sure what this does, but it looks legit.
set startofline " Why does neovim change these defaults? Who wants to go to a random position in the line after `gg` or `G`?

set statusline=%f               " filename relative to current $PWD
set statusline+=%h              " help file flag
set statusline+=%m              " modified flag
set statusline+=%r              " readonly flag
set statusline+=\ [w%{&ff}]      " Fileformat [unix]/[dos] etc...
set statusline+=\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})  " last modified timestamp
set statusline+=%=              " Rest: right align
set statusline+=%l,%c%V         " Position in buffer: linenumber, column, virtual column
set statusline+=\ %P            " Position in buffer: Percentage

set autoread autowrite " reload external changes after running commands

set maxmempattern=10000

set background=dark

" Plugins
call plug#begin()

" Language
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Behaviour
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdtree'
Plug 'haya14busa/incsearch.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-eunuch'
Plug 'salsifis/vim-transpose'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}
Plug 'hrsh7th/cmp-nvim-lsp'

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim'
Plug 'nvim-treesitter/nvim-treesitter'

" Cosmetic
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'enricobacis/vim-airline-clock'
Plug 'Yggdroot/indentLine'
Plug 'f-person/git-blame.nvim'
Plug 'catppuccin/nvim'

call plug#end()
filetype plugin indent on

" Airline setup
let g:airline_powerline_fonts = v:true
let g:airline_theme='ravenpower'
let g:airline#extensions#clock#format = '%H:%M:%S'
let g:airline#extensions#clock#updatetime = 1000

" I just want the indent guides, not to conceal useful stuff...
let g:indentLine_setConceal = 0

let g:tex_flavor = 'latex'

" This keeps messing up my text if I type too fast...
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutFastWrap = ''
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutBackInsert = ''

" Do not recenter on <CR> in {}
let g:AutoPairsCenterLine = 0

" I hate being unable to type } just because the next line has one
let g:AutoPairsMultilineClose = 0
" Do not autopair ''.
" It is usually only used for single characters,
" and it should not be paired in Rust lifetimes or in English contractions
" (e.g. "it's")
let g:AutoPairs = {
			\'(':')',
			\'[':']',
			\'{':'}',
			\'"':'"',
			\"`":"`",
			\'```':'```',
			\'"""':'"""',
			\"'''":"'''"
			\}

" Autosave after 0.3s
set updatetime=300
autocmd CursorHold,CursorHoldI ?* update
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * checktime

" Configure the behavior of ^N
set completeopt=longest,menuone

" You're not a real vim user if you don't set rnu
set nu rnu

" Most of the time I want to search case-insensitively.
set ignorecase smartcase

" This is language-specific, but foldlevel=1 is probably the most likely
" default.
set fdm=expr foldlevel=1 foldexpr=nvim_treesitter#foldexpr()

" This effectively makes Alt-[ equivalent to right arrow.
nnoremap [ la

" I don't know why going to start-of-line is useful when you want to jump.
" Apparently backtick is not as reachable as aprostrophe.
nnoremap ' `

" This use case is far too common for me.
vnoremap () c()<ESC>Pl%
vnoremap [] c[]<ESC>Pl%
vnoremap {} c{}<ESC>Pl%
vnoremap {<CR> c{<CR>}<ESC>P
vnoremap "" c""<ESC>P
vnoremap '' c''<ESC>P
vnoremap `` c``<ESC>P
vnoremap <> c<lt>><ESC>P

" Copy yanked text to X11 primary selection (middle click).
command Y :call system('xclip -i', @@)
" Copy yanked text to X11 clipboard selection (^V).
command YY :call system('xclip -i -selection clipboard', @@)
" Copy yanked text to /tmp/vim-yank
command YT :call system('cat > /tmp/vim-yank', @@)

" Change %% to current dir when typing commands.
cabbr <expr> %% expand('%:p:h')

" For search commands, I would like to be able to jump back to the *s*ource
" after completing the search.
" Use case: type `/pattern`, use `n`/`N` a few times until I find the target,
" probably some `%` in the process as well, use `'m'` to jump back.
nnoremap / ms/
nnoremap ? ms?
nnoremap * ms*
nnoremap # ms#
nnoremap gg msgg
nnoremap G msG
" Start searching from start of file without overwriting the `s` position after `gg`.
nnoremap g/ mmgg/

" Opening a new tab is very common for me.
nnoremap <C-T> :tabedit<SPACE>
inoremap <C-T> <ESC>:tabedit<SPACE>

" Switching tabs is a very trivial operation.
" Why don't we jump tabs as conveniently as we'd do Alt-<number> on Firefox?
nnoremap g1 1gt
nnoremap g2 2gt
nnoremap g3 3gt
nnoremap g4 4gt
nnoremap g5 5gt
nnoremap g6 6gt
nnoremap g7 7gt
nnoremap g8 8gt
nnoremap g9 9gt


" zf = fuzzy file search!
nmap <silent> zf <cmd>Telescope git_files<cr>
" fuzzy grep search
nmap <silent> zg <cmd>Telescope live_grep<cr>

" Clear search
nnoremap H :nohls<CR>

" I have autosave anyway
nnoremap ZZ :NERDTreeFind<CR>

" I want tabs.
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" Some uncommon file extensions I have dealt with.
" set filetype=xxx overrides the filetype
" setfiletype xxx provides default filetype
autocmd BufRead,BufNewFile *.tex set filetype=tex
autocmd BufRead,BufNewFile *.rviz set filetype=yaml
autocmd BufRead,BufNewFile *.launch setfiletype xml
autocmd BufRead,BufNewFile .eslintrc setfiletype json
autocmd BufRead,BufNewFile *.json.dist setfiletype json
autocmd BufRead,BufNewFile *.rs set fdm=syntax foldlevel=0
autocmd BufRead,BufNewFile *.yml set fdm=indent foldlevel=1
autocmd BufRead,BufNewFile *.php set fdm=indent foldlevel=1
autocmd BufRead,BufNewFile *.py set foldlevel=0

" I don't do HTML in PHP.
" Let's disable the matcher so that we have `%` working properly.
" https://stackoverflow.com/a/24242461/3990767
autocmd BufWinEnter *.php set mps-=<:>

" Do not reset folds on reload
augroup remember_folds
  autocmd!
  autocmd BufWinLeave ?* mkview
  autocmd BufWinEnter ?* silent! loadview
  autocmd BufWrite ?* mkview
augroup END

command! E :call ReloadWithoutResettingFolds()
function ReloadWithoutResettingFolds()
	mkview
	edit
endfunction

" Default git blame color should disambiguate from normal code.
let g:gitblame_highlight_group = "Conceal"
let g:gitblame_message_template = '<sha> <date> <author> | <summary>'
let g:gitblame_date_format = '%r'

" LSP setup
:lua <<EOF
	local cmp = require 'cmp'
	local lsp = require 'lspconfig'
	local luasnip = require 'luasnip'
	local capabilities = require('cmp_nvim_lsp').default_capabilities()
	local treesitter = require 'nvim-treesitter.configs'
	local catppuccin = require 'catppuccin'

	local on_attach = function(client, bufnr)
		local function nmap(key, action)
			vim.keymap.set('n', key, action, {noremap=true, silent=true, buffer = bufnr})
		end


		nmap('gd', function() vim.lsp.buf.definition() end)
		nmap('gi', function() vim.lsp.buf.implementation() end)
		nmap('gy', function() vim.lsp.buf.type_definition() end)
		nmap('gr', function() vim.lsp.buf.references() end)

		local severity = vim.diagnostic.severity
		nmap('g[', function() vim.diagnostic.goto_prev{ severity = {min = severity.WARN} } end)
		nmap('g{', function() vim.diagnostic.goto_prev{ severity = severity.ERROR } end)
		nmap('g}', function() vim.diagnostic.goto_next{ severity = severity.ERROR } end)
		nmap('g]', function() vim.diagnostic.goto_next{ severity = {min = severity.WARN} } end)

		nmap('L', function() vim.lsp.buf.code_action() end)

		nmap('Kn', function() vim.lsp.buf.rename() end)
		nmap('M', function() vim.lsp.buf.hover() end)
	end

	lsp.gopls.setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
	lsp.rust_analyzer.setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}

	cmp.setup {
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert{
		      ['<C-c>'] = cmp.mapping.complete(),
		      ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		},
		sources = {
			{name = 'nvim_lsp'},
			{name = 'luasnip'},
		},
	}

	treesitter.setup {
		ensure_installed = {"vim", "go", "rust", "markdown", "lua", "make", "yaml", "vhs", "json", "typescript", "php", "python", "jq", "dockerfile", "editorconfig", "bash", "toml"},
		auto_install = true,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gsk",
				node_incremental = "gsn",
				scope_incremental = "gss",
				node_decremental = "gsp",
			},
		},
		indent = {
			enable = true,
		},
	}

	local initial_colors = {
		all = {
			base = '#1e031e',
		},
	}

	catppuccin.setup {
		color_overrides = initial_colors,
		custom_highlights = function(colors)
			return {
				LineNr = { fg = colors.green },
				LineNrAbove = { fg = colors.flamingo },
				LineNrBelow = { fg = colors.sky, }
			}
		end,
	}
	vim.cmd.colorscheme "catppuccin-mocha"

	vim.api.nvim_create_autocmd('FocusGained', {
		callback = function()
			catppuccin.setup {
				color_overrides = initial_colors,
			}
			vim.cmd.colorscheme "catppuccin-mocha"
		end,
	})

	vim.api.nvim_create_autocmd('FocusLost', {
		callback = function()
			catppuccin.setup {
				color_overrides = {
					all = {
						base = '#2e3e2e',
					},
				},
			}
			vim.cmd.colorscheme "catppuccin-mocha"
		end,
	})
EOF

let local_vimrc = expand("~/local.vimrc")
if filereadable(local_vimrc)
	execute "source " . local_vimrc
endif
