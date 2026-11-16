require("utils.pack").add({
	{
		src = "https://github.com/AlexvZyl/nordic.nvim",
		version = "main",
		config = function()
			require("nordic").setup({
				transparent = {
					bg = true,
					float = false,
				},
				on_highlight = function(highlights, palette)
					highlights.Comment = {
						fg = palette.gray5,
					}
					highlights.StatusLine = {
						fg = palette.while3,
						bg = palette.gray2,
					}
					highlights.LineNr = {
						fg = palette.gray5,
					}
					highlights.PmenuSel = {
						bg = palette.blue0,
					}
					highlights.PmenuThumb = {
						bg = palette.blue0,
					}
				end,
			})
			require("nordic").load({})
		end,
	},
})
