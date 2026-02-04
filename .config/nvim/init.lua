vim.g.mapleader = " "

local lazypath = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = "custom.plugins",
	checker = {
		enabled = false,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
