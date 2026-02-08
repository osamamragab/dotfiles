return {
	{
		"zk-org/zk-nvim",
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
}
