require("utils.pack").add({
	{
		src = "https://github.com/zk-org/zk-nvim",
		version = "main",
		config = function()
			require("zk").setup({
				picker = "fzf_lua",
				lsp = {
					config = {
						cmd = { "zk", "lsp" },
						name = "zk",
					},
					auto_attach = {
						enabled = true,
						filetypes = { "markdown" },
					},
				},
			})
		end,
	},
})
