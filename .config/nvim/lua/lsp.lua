local lsp = require("lspconfig")

lsp.clangd.setup({ root_dir = function() return vim.loop.cwd() end })

lsp.rust_analyzer.setup({})

lsp.gopls.setup({
	cmd = {"gopls"},
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
})

lsp.pyright.setup({})

lsp.tsserver.setup({})
lsp.svelte.setup({})
lsp.vuels.setup({})
