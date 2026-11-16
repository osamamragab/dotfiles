require("utils.pack").add({
	{
		src = "https://github.com/j-hui/fidget.nvim",
		version = vim.version.range("1.*"),
		config = function()
			require("fidget").setup({
				notification = {
					window = {
						winblend = 0,
					},
				},
			})
		end,
	},
})
