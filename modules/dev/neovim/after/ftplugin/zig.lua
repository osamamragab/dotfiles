vim.opt_local.expandtab = true
vim.g.zig_fmt_autosave = false
vim.g.zig_recommended_style = true

local augroup = vim.api.nvim_create_augroup("zls", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = { "*.zig", "*.zon" },
	callback = function(_)
		vim.lsp.buf.code_action({
			apply = true,
			context = {
				diagnostics = {},
				only = {
					"source.fixAll",
					"source.organizeImports",
				},
			},
		})
	end
})
