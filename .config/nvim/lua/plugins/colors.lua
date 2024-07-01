return {
	{
		"AlexvZyl/nordic.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local colors = require("nordic.colors")
			require("nordic").setup({
				transparent_bg = true,
				override = {
					StatusLine = {
						fg = "none",
					},
					LineNr = {
						fg = colors.gray5,
					},
					Visual = {
						bg = colors.blue0,
					},
					PmenuSel = {
						bg = colors.blue0,
					},
				},
				telescope = {
					style = "classic",
				},
			})
			require("nordic").load()
		end,
	},
}
