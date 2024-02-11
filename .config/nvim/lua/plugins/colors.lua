return {
	{
		"AlexvZyl/nordic.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nordic").setup({
				override = {
					["StatusLine"] = { fg = "none" },
				},
				telescope = { style = "classic" },
			})
			require("nordic").load()
		end,
	},
}
