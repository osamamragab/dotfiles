require("utils.pack").add({
	{
		src = "https://github.com/stevearc/oil.nvim",
		version = vim.version.range("2.*"),
		config = function()
			require("oil").setup({})
		end,
	},
})
