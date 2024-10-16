vim.g.mapleader = " "

vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+y$')
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')
vim.keymap.set({ "n", "v" }, "<leader>D", '"_D')

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv")

vim.keymap.set("n", "<leader>k", "<cmd>cnext<cr>zz")
vim.keymap.set("n", "<leader>j", "<cmd>cprev<cr>zz")
vim.keymap.set("n", "<leader>K", "<cmd>lnext<cr>zz")
vim.keymap.set("n", "<leader>J", "<cmd>lprev<cr>zz")

vim.keymap.set("n", "Q", ":Ex<cr>")
vim.keymap.set("i", "<C-c>", "<esc>")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
