" General.
set title
set nocompatible
set shell=/bin/sh
set clipboard=unnamed,unnamedplus
set backspace=indent,eol,start
set number
set autoindent
set autoread
set cursorline
set expandtab
set hidden
set hlsearch ignorecase incsearch
set shiftwidth=2 softtabstop=2 tabstop=2 smarttab
set shortmess=atI showtabline=2 sidescrolloff=3 smartcase
set splitbelow splitright
set scrolloff=3
set formatoptions=c,r,o,1,n,2,l,1 history=500
set lazyredraw magic
set mouse=a
set noerrorbells
set nojoinspaces noshowmode nostartofline
set ttyfast
set undofile switchbuf=""
set wildmenu wildmode=list:longest winminheight=0 wrapscan
set suffixes=.bak,~,.swp,.swo,.o,.d,.info,.aux,.log,.dvi,.pdf,.bin,.bbl,.blg,
      \.brf,.cb,.dmg,.exe,.ind,.idx,.ilg,.inx,.out,.toc,.pyc,.pyd,.dll
set wildchar=<TAB>
set wildignore+=.DS_Store,*.jpg,*.jpeg,*.gif,*.png,*.gif,*.psd,*.o,*.obj,*.min.js
set wildignore+=*/bower_components/*,*/node_modules/*,*/smarty/*,*/vendor/*,
      \*/.git/*,*/.hg/*,*/.svn/*,*/.sass-cache/*,*/log/*,*/tmp/*,*/build/*,
      \*/doc/*,*/source_maps/*,*/dist/*

set wrap laststatus=2
set textwidth=80
autocmd FileType gitcommit set textwidth=72

set colorcolumn=+1
autocmd FileType gitcommit set colorcolumn+=51

set foldcolumn=0 foldenable foldlevel=0 foldmethod=indent
set foldminlines=10 foldnestmax=5
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" Plugin.
call plug#begin('~/.local/share/nvim/plugged')
Plug 'junegunn/vim-plug'

Plug 'scrooloose/nerdtree'
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'itchyny/lightline.vim'

Plug 'tpope/vim-commentary'
Plug 'godlygeek/tabular'
Plug 'vim-scripts/autoclose'
Plug 'alvan/vim-closetag', {'for': 'html'}

Plug 'sheerun/vim-polyglot'
Plug 'dense-analysis/ale'
Plug 'maximbaz/lightline-ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'itchyny/landscape.vim'
Plug 'ayu-theme/ayu-vim'
call plug#end()

" Colors and Syntax.
filetype plugin indent on
" syntax enable
syntax on
set encoding=utf-8
set updatetime=300
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

let mapleader=","
inoremap <leader>, <C-x><C-o>

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

" Directories.
" set backupdir=~/.local/share/nvim/backup
" set directory=~/.local/share/nvim/swap
" set undodir=~/.local/share/nvim/undo
set nobackup
set noundofile
set noswapfile

set redrawtime=10000

" colorscheme & lightline
set t_Co=256
set termguicolors
let ayucolor="dark"
colorscheme ayu
" colorscheme landscape

function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction
let g:lightline = {
\  'colorscheme': 'ayu',
\  'component': { 'lineinfo': "%{printf('%03d/%03d:%03d', line('.'),  line('$'), col('.'))}" },
\  'component_function': {'gitbranch': 'FugitiveHead', 'gitstatus': 'GitStatus'},
\  }
let g:lightline.component_expand = {
\  'linter_checking': 'lightline#ale#checking',
\  'linter_infos': 'lightline#ale#infos',
\  'linter_warnings': 'lightline#ale#warnings',
\  'linter_errors': 'lightline#ale#errors',
\  'linter_ok': 'lightline#ale#ok',
\  }
let g:lightline.component_type = {
\  'linter_checking': 'right',
\  'linter_infos': 'right',
\  'linter_warnings': 'warning',
\  'linter_errors': 'error',
\  'linter_ok': 'right',
\  }
let g:lightline.active = {
\  'left': [
\    ['mode', 'paste'],
\    ['gitbranch', 'gitstatus', 'readonly', 'filename', 'modified'],
\    ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_infos', 'linter_ok'],
\  ]}

" NERDTree.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
let NERDTreeMinimalUI = 1
let g:NERDTreeWinSize = 20
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__', 'dist', 'node_modules']

" ALE
nmap <silent> <F3> <Plug>(ale_lint)
nmap <silent> <F4> <Plug>(ale_fix)
nmap <silent> l[ <Plug>(ale_previous_wrap)
nmap <silent> l] <Plug>(ale_next_wrap)
" highlight ALEWarning ctermfg=0 ctermbg=214
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 1
let g:ale_linters_explicit = 1
let g:ale_linters = {
\  'c': ['gcc', 'clang', 'cppcheck', 'clangd'],
\  'cpp': ['gcc', 'clang', 'cppcheck', 'clangd'],
\  'python': ['autopep8', 'pyls'],
\  'typescript': ['prettier', 'tslint'],
\  'javascript': ['prettier', 'eslint'],
\  'java': ['javac'],
\  'scala': ['scalac', 'sbtserver', 'metals'],
\  } " clangtidy taking to much resource
let g:ale_fixers = {
\  'c': ['clangtidy', 'clang-format'],
\  'cpp': ['clangtidy', 'clang-format'],
\  'python': ['autopep8', 'isort', 'yapf'],
\  'typescript': ['prettier', 'tslint'],
\  'javascript': ['prettier', 'eslint'],
\  'json': ['prettier'],
\  'xml': ['xmllint'],
\  'java': ['javac', 'google-java-format'],
\  'scala': ['scalac', 'sbtserver', 'metals'],
\  }

" coc.vim
" nvim -c 'CocInstall -sync coc-actions coc-angular coc-clangd coc-css coc-eslint coc-jedi coc-markdownlint coc-spell-checker coc-tsserver coc-yaml coc-json coc-html|q'
" let g:coc_node_path = '/usr/bin/node'
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <leader>, coc#refresh()
autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <silent> g[ <Plug>(coc-diagnostic-prev)
nmap <silent> g] <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>rn <Plug>(coc-rename)

vmap <leader>sp <Plug>(coc-codeaction-selected)<CR>g@
nmap <leader>sp <Plug>(coc-codeaction-selected)<CR>g@

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"" Abbreviations
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

nnoremap <A-1> 1gt
nnoremap <A-2> 2gt
nnoremap <A-3> 3gt
nnoremap <A-4> 4gt
nnoremap <A-5> 5gt
nnoremap <A-6> 6gt
nnoremap <A-7> 7gt
nnoremap <A-8> 8gt
nnoremap <A-9> 9gt
nnoremap <A-0> 10gt

