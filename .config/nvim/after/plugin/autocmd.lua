local autocmd = vim.api.nvim_create_autocmd
local filetype = vim.api.nvim_create_augroup("filetype", {})

autocmd({ "BufNewFile", "BufRead" }, {
	group = filetype,
	pattern = "*.h",
	command = "setlocal ft=c",
})

autocmd({ "BufNewFile", "BufRead" }, {
	group = filetype,
	pattern = "*.dockerfile",
	command = "setlocal ft=dockerfile",
})

autocmd("FileType", {
	group = filetype,
	pattern = { "python", "ruby", "yaml", "markdown" },
	command = "setlocal expandtab",
})

autocmd("BufWritePre", {
	group = filetype,
	pattern = "*",
	command = "%s/\\s\\+$//e",
})

autocmd("BufWritePost", {
	group = filetype,
	pattern = { "xdefaults", "Xdefaults", "xresources", "Xresources" },
	command = "!xrdb %",
})
