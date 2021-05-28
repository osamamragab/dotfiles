set nocompatible

syntax enable
filetype plugin indent on

call plug#begin(system('printf "%s" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'editorconfig/editorconfig-vim'
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'Raimondi/delimitMate'
Plug 'mhinz/vim-signify'
Plug 'junegunn/fzf.vim'
" Plug 'rhysd/clever-f.vim'
Plug 'junegunn/goyo.vim'
Plug 'itchyny/lightline.vim'
Plug 'sainnhe/sonokai'
" Plug 'gruvbox-community/gruvbox'
call plug#end()

set exrc
set secure

set autoread
set lazyredraw
set number
set relativenumber
set linebreak
set showbreak=++
set undolevels=1000
set belloff=all
set splitright
set splitbelow
set noshowmode
set noshowmatch
set hidden
set nowrap
set path+=**

set ruler
set wildmenu
set laststatus=2

set hlsearch
set smartcase
set ignorecase
set incsearch

set nobackup
set nowritebackup
set swapfile

set autoindent
set backspace=indent,eol,start
set smarttab
set noexpandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

set clipboard^=unnamed,unnamedplus
set mouse=a
set display+=lastline
set updatetime=300
set fileformats=unix,dos,mac
set conceallevel=0
set completeopt=menuone,noinsert
set pumheight=10

set background=dark
set termguicolors

if has('termguicolors')
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
endif

let g:sonokai_better_performance=1
let g:sonokai_transparent_background=1
colorscheme sonokai

" let g:gruvbox_contrast_dark='hard'
" let g:gruvbox_sign_column='dark0_hard'
" let g:gruvbox_transparent_bg=2
" let g:gruvbox_invert_selection=0
" let g:gruvbox_bold=0
" colorscheme gruvbox

hi! def link Label Statement
hi! def link Delimiter Normal

let mapleader=' '

let g:netrw_banner=0
let g:netrw_browse_split=0
let g:netrw_altv=1
let g:netrw_winsize=25
let g:netrw_liststyle=3
let g:netrw_list_hide='.git' " netrw_gitignore#Hide()
noremap <C-b> :Lexplore!<cr>

let g:lightline = {
	\ 'colorscheme': 'wombat',
	\ 'component_function': {'gitbranch': 'FugitiveHead'},
	\ 'active': {
			\ 'left': [['mode', 'paste'], ['gitbranch', 'filename', 'modified', 'readonly']],
			\ 'right': [['lineinfo'], ['percent'], ['filetype', 'fileencoding', 'fileformat']],
	\ },
\ }
if g:colors_name ==# 'gruvbox' || g:colors_name ==# 'sonokai'
	let g:lightline.colorscheme=g:colors_name
endif

let g:signify_sign_change='~'

let g:fzf_buffers_jump=1
let g:fzf_preview_window=['right:70%', 'ctrl-/']
"let $FZF_DEFAULT_OPTS='--reverse'

let g:rustfmt_autosave=1
let g:rust_recommended_style=0

let g:go_fmt_autosave=1
let g:go_fmt_command='goimports'
let g:go_list_type='quickfix'
let g:go_echo_command_info=1
let g:go_autodetect_gopath=1
let g:go_metalinter_autosave_enabled=['vet', 'golint']
let g:go_metalinter_enabled=['vet', 'golint']
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_imports_mode='gopls'
let g:go_rename_command='gopls'
let g:go_implements_mode='gopls'
let g:go_gopls_complete_unimported=1
let g:go_doc_popup_window=1
let g:go_highlight_build_constraints=1
let g:go_highlight_operators=1
let g:go_fmt_fail_silently=1
let g:go_diagnostics_level=2
let g:go_imports_autosave=1
let g:go_test_show_name=1

let g:omni_sql_no_default_maps=1

" esc is far away
"inoremap jj <esc>

" disable that stupid list
nnoremap q: :q

nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

" move highlighted text
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

" move faster between windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l

nnoremap <C-p> :GFiles<cr>

" completion menu
inoremap <expr> <C-space> &omnifunc == '' ? '<C-x><C-n>' : '<C-x><C-o>'

" write as root
"cnoremap w!! w !doas tee % >/dev/null

augroup filetypedetect
	au BufNewFile,BufRead *.h setlocal ft=c
	au BufNewFile,BufRead *.dockerfile setlocal ft=dockerfile
	au FileType python setlocal expandtab
	au FileType ruby setlocal expandtab
	au FileType yaml setlocal expandtab
	au FileType markdown setlocal expandtab
augroup END

" smart cursorline
set cursorline
augroup smartcursorline
	au!
	au WinEnter,InsertLeave * set cursorline
	au WinLeave,InsertEnter * set nocursorline
augroup END

" remove trailing spaces
fun! TrimWhitespace()
    let l:view = winsaveview()
    silent! keepp %s/\s\+$//e
    call winrestview(l:view)
endfun
command! Trim call TrimWhitespace()

augroup autotrim
	au!
	au BufWritePre * call TrimWhitespace()
augroup END

" make tags file
command! MakeTags !ctags -R
