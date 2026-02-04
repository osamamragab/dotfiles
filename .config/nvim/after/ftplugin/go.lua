local augroup = vim.api.nvim_create_augroup("gofmt", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup,
	pattern = "*.go",
	callback = function(_)
		vim.lsp.buf.format()
		vim.lsp.buf.code_action({
			context = {
				diagnostics = {},
				only = {
					"source.organizeImports",
				},
			},
			apply = true,
		})
	end,
})
