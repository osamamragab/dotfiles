return {
	{
		"nvim-flutter/flutter-tools.nvim",
		lazy = true,
		ft = "dart",
		config = function()
			require("flutter-tools").setup({})
		end
	}
}
