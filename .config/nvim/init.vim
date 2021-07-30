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
set completeopt=menuone,noselect

set incsearch
set nohlsearch
set ignorecase
set smartcase

set nowrap
set linebreak
set showbreak=++

set exrc
set secure

call plug#begin(system('printf "%s" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
" Plug 'nvim-treesitter/playground'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-commentary'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'Raimondi/delimitMate'
Plug 'mhinz/vim-signify'
Plug 'simrat39/symbols-outline.nvim'
Plug 'editorconfig/editorconfig-vim'
Plug 'rust-lang/rust.vim'
Plug 'darrikonn/vim-gofmt', { 'do': ':GoUpdateBinaries' }
Plug 'psf/black'
Plug 'sbdchd/neoformat'
Plug 'itchyny/lightline.vim'
Plug 'sainnhe/sonokai'
" Plug 'gruvbox-community/gruvbox'
" Plug 'joshdick/onedark.vim'
" Plug 'arcticicestudio/nord-vim'
call plug#end()

lua require("lsp")
lua require("nvim-treesitter.configs").setup({ highlight = { enable = true } })

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

if index(['gruvbox', 'onedark', 'nord'], g:colors_name) >= 0
	hi Normal guibg=NONE ctermbg=NONE
	hi SignColumn guibg=NONE ctermbg=NONE
	if g:colors_name ==# 'gruvbox'
		hi CursorLineNr guibg=NONE ctermbg=NONE
	endif
endif

hi! def link Label Statement
hi! def link Delimiter Normal

let mapleader = ' '

let g:netrw_banner = 0
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_winsize = 25
let g:netrw_liststyle = 3
let g:netrw_list_hide = netrw_gitignore#Hide()
noremap <C-b> :Lexplore!<CR>

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

let g:fzf_buffers_jump = 1
let g:fzf_preview_window = ['right:70%', 'ctrl-/']
" let $FZF_DEFAULT_OPTS = '--reverse'

fun! RipgrepFzf(query, fullscreen)
	let cmdfmt = "rg --column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git' -- %s || true"
	let initcmd = printf(cmdfmt, shellescape(a:query))
	let relcmd = printf(cmdfmt, '{q}')
	let opts = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.relcmd]}
	call fzf#vim#grep(initcmd, 1, fzf#vim#with_preview(opts), a:fullscreen)
endfun
command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

let g:rustfmt_autosave = 1
let g:rust_recommended_style = 0

nnoremap q: :q
nnoremap <silent> Q <nop>

nnoremap Y y$
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

nnoremap <leader>d "_d
vnoremap <leader>d "_d
vnoremap <leader>p "_dP

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
nnoremap <C-j> :cnext<CR>zzzv

nnoremap <expr> k (v:count > 5 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : '') . 'j'

" moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

inoremap <C-c> <esc>

" undo breakpoints
inoremap . .<C-g>u
inoremap , ,<C-g>u
inoremap ; ;<C-g>u
inoremap ( (<C-g>u
inoremap [ [<C-g>u
inoremap { {<C-g>u

" move faster between windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-h> <C-w>h
noremap <C-l> <C-w>l

nnoremap <C-k> :cnext<CR>zz
nnoremap <C-j> :cprev<CR>zz
nnoremap <leader>k :lnext<CR>zz
nnoremap <leader>j :lprev<CR>zz

nnoremap <C-p> :GFiles<CR>
nnoremap <leader>gs :G<CR>

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

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm({ 'keys': "\<Plug>delimitMateCR", 'mode': '' })
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" write as root
cnoremap SudoWrite w !doas tee % >/dev/null

augroup filetypedetect
	au BufNewFile,BufRead *.h setlocal ft=c
	au BufNewFile,BufRead *.dockerfile setlocal ft=dockerfile
	au FileType python setlocal expandtab
	au FileType ruby setlocal expandtab
	au FileType yaml setlocal expandtab
	au FileType markdown setlocal expandtab
augroup END

" remove trailing spaces
fun! s:trimwhitespace()
    let l:view = winsaveview()
    silent! keepp %s/\s\+$//e
    call winrestview(l:view)
endfun
com! Trim call s:trimwhitespace()

fun! s:goonsave()
	GoFmt
	GoImports
endfun

augroup autofmt
	au!
	au BufWritePre *    silent! undojoin | Trim
	au BufWritePre *.go silent! undojoin | call s:goonsave()
	au BufWritePre *.py silent! undojoin | Black
augroup END

com! W w
