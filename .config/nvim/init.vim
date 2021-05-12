set nocompatible

syntax enable
filetype plugin indent on

call plug#begin(system('printf "%s" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'rust-lang/rust.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'editorconfig/editorconfig-vim'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'junegunn/fzf.vim'
Plug 'rhysd/clever-f.vim'
Plug 'junegunn/goyo.vim'
Plug 'itchyny/lightline.vim'
Plug 'fatih/molokai'
Plug 'sainnhe/sonokai'
Plug 'joshdick/onedark.vim'
call plug#end()

set exrc
set secure

set autoread
set lazyredraw
set number
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

"let g:molokai_original=1
let g:rehash256=1

colorscheme molokai

if g:colors_name == 'molokai'
	hi! def link Label Statement
	hi! def link Delimiter cleared
	hi Special guibg=none
	hi Function ctermfg=112 guifg=#87d700
endif

hi Normal ctermbg=234 ctermfg=255 guibg=#1c1c1c guifg=#ffffff
hi LineNr ctermbg=234 guibg=#1c1c1c

hi TabLine ctermbg=233 guibg=#121212
hi TabLineFill ctermfg=233 guifg=#121212

hi Pmenu ctermbg=233 ctermfg=252 guifg=#d0d0d0
hi PmenuSel ctermbg=235 ctermfg=252 guibg=#262626
hi PmenuSbar ctermbg=233 guibg=#121212
hi PmenuThumb ctermbg=236 guibg=#303030

hi SignColumn ctermbg=234 guibg=#1c1c1c
hi SignifySignAdd ctermfg=28 guifg=#008700
hi SignifySignChange ctermfg=26 guifg=#005fd7

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

let g:signify_sign_change='~'

let g:fzf_buffers_jump=1
let g:fzf_preview_window=['right:70%', 'ctrl-/']
let $FZF_DEFAULT_OPTS='--reverse'

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
inoremap jj <esc>

" disable that stupid list
nnoremap q: :q

" delete without yanking
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP

" move faster between windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l

nnoremap <C-p> :GFiles<cr>

" completion menu
inoremap <expr> <C-space> &omnifunc == '' ? '<C-x><C-n>' : '<C-x><C-o>'

" write as root
cnoremap w!! w !doas tee >/dev/null %

augroup filetypedetect
	au BufNewFile,BufRead *.h set ft=c
	au FileType yaml setlocal expandtab
	au FileType python setlocal expandtab
	au FileType ruby setlocal expandtab
augroup END

" smart cursorline
set cursorline
au WinEnter,InsertLeave * set cursorline
au WinLeave,InsertEnter * set nocursorline

" remove trailing spaces
au BufWritePre * :%s/\s\+$//e

command! MakeTags !ctags -R
