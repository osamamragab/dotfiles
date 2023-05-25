require("Comment").setup({})
require("gitsigns").setup({})
require("nvim-autopairs").setup({})
require("lualine").setup({
	options = {
		icons_enabled = false,
	},
})

require("flutter-tools").setup({
	--lsp = ,
	decorations = {
		statusline = {
			device = true,
			app_version = true,
		},
	},
	widget_guides = {
		enabled = true,
	},
})
