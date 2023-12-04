return {
	{
		"luisiacc/gruvbox-baby",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			vim.g.gruvbox_baby_transparent_mode = true
			vim.cmd.colorscheme("gruvbox-baby")
		end,
	},
}
