require("utils.pack").add({
	{
		src = "https://github.com/nvim-flutter/flutter-tools.nvim",
		version = "main",
		config = function()
			require("flutter-tools").setup({})
		end,
	},
})
