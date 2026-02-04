local augroup = vim.api.nvim_create_augroup("format_trim", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup,
	pattern = "*",
	callback = function(_)
		local cur = vim.fn.getpos(".")
		vim.cmd("%s/\\s\\+$//e")
		vim.fn.setpos(".", cur)
	end,
})
