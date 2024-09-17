return {
	{
		"AlexvZyl/nordic.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local colors = require("nordic.colors")
			require("nordic").setup({
				transparent_bg = true,
				telescope = {
					style = "classic",
				},
				override = {
					Comment = {
						fg = colors.gray5,
					},
					StatusLine = {
						fg = "none",
					},
					LineNr = {
						fg = colors.gray5,
					},
					PmenuSel = {
						bg = colors.blue0,
					},
				},
			})
			require("nordic").load()
		end,
	},
}
