local autocmd = vim.api.nvim_create_autocmd
local filetype = vim.api.nvim_create_augroup("filetype", {})

autocmd({ "BufNewFile", "BufRead" }, {
	group = filetype,
	pattern = "*.h",
	command = "setlocal ft=c",
})

autocmd("FileType", {
	group = filetype,
	pattern = { "python", "ruby", "yaml", "markdown" },
	command = "setlocal expandtab",
})

autocmd("BufWritePost", {
	group = filetype,
	pattern = { "xdefaults", "Xdefaults", "xresources", "Xresources" },
	command = "!xrdb %",
})

autocmd("BufWritePost", {
	group = filetype,
	pattern = "sxhkdrc",
	command = "!pkill -SIGUSR1 sxhkd"
})

autocmd("BufWritePre", {
	group = filetype,
	pattern = "*",
	callback = function(_)
		local cur = vim.fn.getpos(".")
		vim.cmd("%s/\\s\\+$//e")
		vim.fn.setpos(".", cur)
	end,
})
