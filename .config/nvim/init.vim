set nocompatible

syntax enable
filetype plugin indent on

call plug#begin(system('printf "%s" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'editorconfig/editorconfig-vim'
Plug 'voldikss/vim-floaterm'
Plug 'Raimondi/delimitMate'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'rhysd/clever-f.vim'
Plug 'junegunn/goyo.vim'
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'fatih/molokai'
Plug 'sainnhe/sonokai'
Plug 'joshdick/onedark.vim'
call plug#end()

set exrc
set secure

set autoread
set autowrite
set ttyfast
set lazyredraw
set number
set linebreak
set showbreak=++
set ruler
set undolevels=1000
set belloff=all
set splitright
set splitbelow
set noshowmode
set noshowmatch
set hidden
set nowrap
set path+=**
set wildmenu

set hlsearch
set smartcase
set ignorecase
set incsearch

set nobackup
set nowritebackup
set swapfile

set autoindent
set noexpandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set backspace=indent,eol,start

set clipboard^=unnamed
set clipboard^=unnamedplus

set display+=lastline

set mouse=a

set updatetime=300

set completeopt=menu,menuone
set nocursorcolumn
set nocursorline
set pumheight=10
set conceallevel=2

set fileformats=unix,dos,mac

set background=dark

"let g:molokai_original=1
let g:rehash256=1

colorscheme molokai

if g:colors_name == "molokai"
	hi Function ctermfg=83 guifg=#5fff5f
endif

hi! def link Label Statement

hi Normal ctermfg=255
hi LineNr ctermbg=234

hi TabLine ctermbg=233
hi TabLineFill ctermfg=233

hi Pmenu ctermbg=233 ctermfg=252 guifg=none
hi PmenuSel ctermbg=235 ctermfg=252 guibg=grey20
hi PmenuSbar ctermbg=233
hi PmenuThumb ctermbg=236

hi SignColumn ctermbg=234
hi SignifySignAdd ctermfg=28
hi SignifySignChange ctermfg=26

hi FloatermBorder guibg=none

let mapleader=' '

let g:netrw_banner=0
let g:netrw_browse_split=4
let g:netrw_altv=1
let g:netrw_liststyle=3
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

let g:NERDTreeWinPos='right'
let NERDTreeShowHidden=1

let g:lightline = {
	\ 'colorscheme': 'wombat',
	\ 'active': {'right': [['lineinfo'], ['percent'], ['filetype', 'fileencoding', 'fileformat']]},
\ }

let g:signify_sign_change='~'

let g:floaterm_width=1.0
let g:floaterm_height=0.3
let g:floaterm_position='bottom'
let g:floaterm_keymap_toggle='<C-f>'
let g:floaterm_title='Terminal'

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
let g:go_diagnostics_enabled=1
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

" clear search highlight
" nnoremap <C-n> :nohl<cr>

" delete without yanking
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP

" move faster between windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l

" completion menu
inoremap <C-space> <C-x><C-o>

" nerdtree shortcuts
noremap <C-b> :NERDTreeToggle<cr>
nnoremap <leader>w <esc>:w<cr>
nnoremap <leader>q <esc>:q<cr>
nnoremap <leader>Q <esc>:q!<cr>
nnoremap <leader>n <esc>:nohlsearch<cr>

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

command! MakeTags !ctags -R .
