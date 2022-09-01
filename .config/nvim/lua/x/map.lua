local keymap = require("x.keymap")
local nmap = keymap.nmap
local nnoremap = keymap.nnoremap
local vnoremap = keymap.vnoremap
local xnoremap = keymap.xnoremap
local inoremap = keymap.inoremap

vnoremap("J", ":m '>+1<cr>gv=gv")
vnoremap("K", ":m '<-2<cr>gv=gv")

nnoremap("Y", "yg$")
nnoremap("<leader>y", '"+y')
vnoremap("<leader>y", '"+y')
nmap("<leader>Y", '"+Y')

nnoremap("n", "nzzzv")
nnoremap("N", "Nzzzv")
nnoremap("J", "mzJ`z")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

xnoremap("<leader>p", '"_dP')

nnoremap("<leader>d", '"_d')
vnoremap("<leader>d", '"_d')

inoremap("<C-c>", "<esc>")

nnoremap("Q", "<nop>")

nnoremap("<C-k>", "<cmd>cnext<cr>zz")
nnoremap("<C-j>", "<cmd>cprev<cr>zz")
nnoremap("<leader>k", "<cmd>lnext<cr>zz")
nnoremap("<leader>j", "<cmd>lprev<cr>zz")

nnoremap("<leader>b", ":Ex<cr>")

nnoremap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
