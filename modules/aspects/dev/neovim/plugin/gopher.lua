require("utils.pack").add({
	{
		src = "https://github.com/olexsmir/gopher.nvim",
		version = "main",
		config = function()
			require("gopher").setup({})
		end,
	},
})
