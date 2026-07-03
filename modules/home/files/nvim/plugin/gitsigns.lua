require("utils.pack").add({
	{
		src = "https://github.com/lewis6991/gitsigns.nvim",
		version = vim.version.range("2.*"),
		config = function()
			require("gitsigns").setup({})
		end,
	},
})
