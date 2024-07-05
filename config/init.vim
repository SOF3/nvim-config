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
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" System
Plugin 'VundleVim/Vundle.vim'

" Language
Plugin 'neoclide/coc.nvim'
Plugin 'mfussenegger/nvim-dap'

" Behaviour
Plugin 'editorconfig/editorconfig-vim'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-abolish'
Plugin 'jiangmiao/auto-pairs'
Plugin 'preservim/nerdtree'
Plugin 'haya14busa/incsearch.vim'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'tpope/vim-eunuch'
Plugin 'salsifis/vim-transpose'

" Telescope
Plugin 'nvim-lua/plenary.nvim'
Plugin 'nvim-telescope/telescope.nvim'
Plugin 'nvim-telescope/telescope-fzf-native.nvim'
Plugin 'fannheyward/telescope-coc.nvim'
Plugin 'nvim-treesitter/nvim-treesitter'

" Cosmetic
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'enricobacis/vim-airline-clock'
Plugin 'Yggdroot/indentLine'
Plugin 'f-person/git-blame.nvim'

call vundle#end()
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

lua require('telescope').load_extension('coc')

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
set fdm=syntax foldlevel=1

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

" Some common COC bindings.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> g[ <Plug>(coc-diagnostic-prev)
nmap <silent> g] <Plug>(coc-diagnostic-next)
nmap <silent> g{ <Plug>(coc-diagnostic-prev-error)
nmap <silent> g} <Plug>(coc-diagnostic-next-error)

" Who uses `K` and `L` anyway?
nmap <silent> Kn <Plug>(coc-rename)
nmap <silent> Kf <Plug>(coc-format-selected)
nmap <silent> Kx <Plug>(coc-fix-current)
nmap <silent> Kr <Plug>(coc-refactor)

nmap <silent> Kl <Plug>(coc-codeaction)
nmap <silent> L <Plug>(coc-codeaction-line)
vmap <silent> L <Plug>(coc-codeaction-selected)

" zf = fuzzy file search!
nmap <silent> zf :set modifiable<CR><cmd>Telescope git_files<cr>
" fuzzy symbol search
nmap <silent> zs :set modifiable<CR><cmd>Telescope coc workspace_symbols<cr>
" fuzzy grep search
nmap <silent> zg :set modifiable<CR><cmd>Telescope live_grep<cr>

" I almost never use H, M and L anyway.
" I use vim because behaviour is predictable.
" H, M and L are not predictable, especially when we have `set rnu`.

" Clear search
nnoremap H :nohls<CR>
" Open documentation
nnoremap M :call CocActionAsync('doHover')<CR>

" I have autosave anyway
nnoremap ZZ :NERDTreeFind<CR>

" Happy Chinese New Year! ^C^N^Y
inoremap <silent><expr> <c-c> coc#refresh()

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

" Disallow file writing when viewing source of a cloned package
autocmd BufRead *.go set modifiable
autocmd BufRead */pkg/mod/*.go set nomodifiable
autocmd BufRead *.rs set modifiable
autocmd BufRead */.cargo/registry/src/*.rs set nomodifiable

" I don't do HTML in PHP.
" Let's disable the matcher so that we have `%` working properly.
" https://stackoverflow.com/a/24242461/3990767
autocmd BufWinEnter *.php set mps-=<:>

" Who thought it's a good idea to conceal unused symbols?
highlight CocFadeout ctermfg=248
" The default color is almost unreadable to me.
highlight FgCocErrorFloatBgCocFloating ctermfg=9 ctermbg=10
" I don't want to think twice to know whether I should `k` or `j`.
highlight link LineNrAbove Tag
" Constant color conflicts with Pmenu
highlight Constant ctermfg=132
highlight CocMenuSel ctermbg=94
highlight FgCocHintFloatBgCocFloating ctermbg=91

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
let g:gitblame_highlight_group = "Ignore"
let g:gitblame_message_template = '<sha> <date> <author> | <summary>'
let g:gitblame_date_format = '%r'

let local_vimrc = expand("~/local.vimrc")
if filereadable(local_vimrc)
	execute "source " . local_vimrc
endif
