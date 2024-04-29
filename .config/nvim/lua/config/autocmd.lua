local autocmd = vim.api.nvim_create_autocmd
local filetype_group = vim.api.nvim_create_augroup("filetype", {})
local format_group = vim.api.nvim_create_augroup("format", {})

autocmd({ "BufNewFile", "BufRead" }, {
	group = filetype_group,
	pattern = "*.h",
	command = "setlocal ft=c",
})

autocmd({ "BufNewFile", "BufRead" }, {
	group = filetype_group,
	pattern = { "todo.txt", "done.txt", "*.todo.txt", "*.done.txt" },
	command = "setlocal ft=todotxt",
})

autocmd("FileType", {
	group = filetype_group,
	pattern = { "python", "ruby", "yaml", "markdown" },
	command = "setlocal expandtab",
})

autocmd("BufWritePost", {
	group = filetype_group,
	pattern = { "xdefaults", "Xdefaults", "xresources", "Xresources" },
	command = "!xrdb %",
})

autocmd("BufWritePost", {
	group = filetype_group,
	pattern = "sxhkdrc",
	command = "!pkill -SIGUSR1 sxhkd",
})

autocmd("BufWritePre", {
	group = format_group,
	pattern = "*",
	callback = function(_)
		local cur = vim.fn.getpos(".")
		vim.cmd("%s/\\s\\+$//e")
		vim.fn.setpos(".", cur)
	end,
})

autocmd("BufWritePre", {
	group = format_group,
	pattern = "*.go",
	callback = function(_)
		vim.lsp.buf.format()
		vim.lsp.buf.code_action({
			context = {
				only = {
					"source.organizeImports",
				},
			},
			apply = true,
		})
	end,
})
