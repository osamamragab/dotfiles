vim.opt.mouse = ""
vim.opt.guicursor = ""
vim.opt.clipboard = "unnamed,unnamedplus"
vim.opt.updatetime = 50
vim.opt.termguicolors = true
vim.opt.isfname:append("@-@")
vim.opt.shortmess:append({ I = true })

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = false
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.g.netrw_banner = false
vim.g.netrw_browse_split = false
vim.g.netrw_altv = true
vim.g.netrw_winsize = 25
vim.g.netrw_fastbrowse = false

vim.g.zig_fmt_autosave = false

vim.g.python3_host_prog = vim.fn.expand("$PYENV_ROOT/versions/pynvim/bin/python")
vim.g.node_host_prog = vim.fn.expand("$PNPM_HOME/neovim-node-host")
vim.g.loaded_ruby_provider = false
vim.g.loaded_perl_provider = false
