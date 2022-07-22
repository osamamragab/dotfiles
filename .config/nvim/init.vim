syntax enable
filetype plugin indent on

set path+=**
set lazyredraw
set hidden
set clipboard^=unnamed,unnamedplus
set mouse=a
set updatetime=300
set belloff=all

set nobackup
set nowritebackup
set swapfile
set undolevels=1000
set undofile

set number
set relativenumber
set signcolumn=yes
set conceallevel=0
set cmdheight=1
set pumheight=10
set scrolloff=8
set splitright
set splitbelow

set autoindent
set smarttab
set noexpandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

set wildmode=longest,full
set wildmenu
set wildignore+=**/.git/*
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/target/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*

set completeopt=menu,menuone,noselect

set incsearch
set nohlsearch
set ignorecase
set smartcase

set nowrap
set linebreak
set showbreak=++

set exrc
set secure

call plug#begin(($XDG_CONFIG_HOME != '' ? $XDG_CONFIG_HOME : $HOME . '/.config') . "/nvim/plugged")
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
" Plug 'nvim-treesitter/playground'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-commentary'
Plug 'ThePrimeagen/git-worktree.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'junegunn/goyo.vim'
Plug 'Raimondi/delimitMate'
Plug 'mhinz/vim-signify'
Plug 'simrat39/symbols-outline.nvim'
Plug 'editorconfig/editorconfig-vim'
Plug 'rust-lang/rust.vim'
Plug 'darrikonn/vim-gofmt', { 'do': ':GoUpdateBinaries' }
Plug 'psf/black', { 'tag': 'stable' }
Plug 'sbdchd/neoformat'
Plug 'elixir-editors/vim-elixir'
Plug 'itchyny/lightline.vim'
Plug 'sainnhe/sonokai'
" Plug 'joshdick/onedark.vim'
" Plug 'arcticicestudio/nord-vim'
" Plug 'gruvbox-community/gruvbox'
" Plug 'luisiacc/gruvbox-baby'
call plug#end()

lua require("x")

set background=dark
set termguicolors

if has('termguicolors')
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
endif

let g:sonokai_style = 'atlantis'
let g:sonokai_better_performance = 1
let g:sonokai_transparent_background = 1
let g:sonokai_diagnostic_virtual_text = 'colored'

" let g:gruvbox_contrast_dark = 'hard'
" let g:gruvbox_sign_column = 'dark0_hard'
" let g:gruvbox_invert_selection = 0
" let g:gruvbox_bold = 0

colorscheme sonokai

hi Normal guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi CursorLineNr guibg=NONE ctermbg=NONE

hi! def link Label Statement
hi! def link Delimiter Normal

let mapleader = ' '

let g:netrw_banner = 0
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_winsize = 25

let g:user_emmet_settings = {'svelte': {'extends': 'html'}}

let g:lightline = {
	\ 'colorscheme': 'wombat',
	\ 'component_function': {'gitbranch': 'FugitiveHead', 'filename': 'LightlineFilename'},
	\ 'active': {
			\ 'left': [['mode', 'paste'], ['gitbranch', 'filename', 'modified', 'readonly']],
			\ 'right': [['lineinfo'], ['percent'], ['filetype', 'fileencoding', 'fileformat']],
	\ },
\ }

if index(['sonokai', 'gruvbox', 'onedark', 'nord'], g:colors_name) >= 0
	let g:lightline.colorscheme=g:colors_name
endif

fun! LightlineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfun

let g:signify_sign_change = '~'

let g:rustfmt_autosave = 1
let g:rust_recommended_style = 0

let g:black_quiet = 1

nnoremap q: :q
nnoremap <silent> Q <nop>

nnoremap Y y$
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
nnoremap <C-j> :cnext<CR>zzzv

nnoremap <expr> k (v:count > 5 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : '') . 'j'

" move selected text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

inoremap <C-c> <esc>

" undo breakpoints
inoremap . .<C-g>u
inoremap , ,<C-g>u
inoremap ; ;<C-g>u
inoremap : :<C-g>u

nnoremap <C-k> :cnext<CR>zz
nnoremap <C-j> :cprev<CR>zz
nnoremap <leader>k :lnext<CR>zz
nnoremap <leader>j :lprev<CR>zz

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <leader>gd  :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>gi  :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>gsh :lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>grr :lua vim.lsp.buf.references()<CR>
nnoremap <leader>grn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>gh  :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>gca :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>gsd :lua vim.lsp.diagnostic.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>
nnoremap <leader>gn  :lua vim.lsp.diagnostic.goto_next()<CR>
" nnoremap <leader>gll :lua vim.lsp.diagnostic.set_loclist({ open_loclist = false })<CR>

imap <silent><expr> <tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<tab>'

" write as root
cnoremap SudoWrite w !doas tee % >/dev/null

augroup filetypedetect
	autocmd BufNewFile,BufRead *.h setlocal ft=c
	autocmd BufNewFile,BufRead *.dockerfile setlocal ft=dockerfile
	autocmd FileType c,cpp setlocal commentstring=//\ %s
	autocmd FileType python setlocal expandtab
	autocmd FileType ruby setlocal expandtab
	autocmd FileType yaml setlocal expandtab
	autocmd FileType markdown setlocal expandtab
	autocmd BufNewFile,BufRead xdefaults,Xdefaults,xresources,Xresources setlocal ft=xdefaults
augroup END

" remove trailing spaces
fun! s:trimwhitespace()
    let l:view = winsaveview()
    silent! keepp %s/\s\+$//e
    call winrestview(l:view)
endfun
command! Trim call s:trimwhitespace()

fun! s:goonsave()
	GoFmt
	GoImports
endfun

command! InlayHints :lua require("lsp_extensions").inlay_hints({ prefix = "-> ", highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint" }})

augroup autofmt
	autocmd!
	autocmd BufWritePre * silent! undojoin | Trim
	" autocmd BufWritePre c,h,cpp,hpp,lua Neoformat
	autocmd BufWritePre *.go silent! undojoin | call s:goonsave()
	autocmd BufWritePre *.py silent! undojoin | Black
	autocmd BufEnter,BufWinEnter,TabEnter *.rs silent! InlayHints
	autocmd BufWritePost xdefaults,Xdefaults,xresources,Xresources !xrdb %
augroup END

command! W w
