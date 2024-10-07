return {
	{
		"AlexvZyl/nordic.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("nordic").setup({
				transparent = {
					bg = true,
					float = false,
				},
				telescope = {
					style = "classic",
				},
				on_highlight = function(highlights, palette)
					highlights.Comment = {
						fg = palette.gray5,
					}

					highlights.StatusLine = {
						fg = "none",
					}
					highlights.LineNr = {
						fg = palette.gray5,
					}
					highlights.PmenuSel = {
						bg = palette.blue0,
					}
				end,
			})
			require("nordic").load()
		end,
	},
}
