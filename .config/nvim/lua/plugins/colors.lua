return {
	{
		"gbprod/nord.nvim",
		config = function()
			require("nord").setup({
				transparent = true,
				errors = { mode = "fg" },
				on_highlights = function(hi, c)
					hi["@error"].undercurl = false
					hi["StatusLine"].fg = c.none
					hi["@parameter"].fg = c.none
					hi["@text.title"].fg = c.none
					hi["@punctuation.bracket"].fg = c.none
				end
			})
			vim.cmd.colorscheme("nord")
		end,
	},
}
