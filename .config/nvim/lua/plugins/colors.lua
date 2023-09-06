return {
	{
		"nordtheme/vim",
		name = "nord",
		config = function()
			vim.g.colors_name = "nord"
			vim.g.nord_bold = true
			vim.g.nord_italic = true
			vim.g.nord_italic_comments = true
			vim.g.nord_uniform_status_lines = true
			vim.g.nord_uniform_diff_background = true
			vim.g.nord_bold_vertical_split_line = false
			vim.cmd.colorscheme(vim.g.colors_name)
			vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
			vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
			vim.api.nvim_set_hl(0, "StatusLine", { bg = vim.api.nvim_get_hl(0, { name = "StatusLine" }).bg })
		end,
	},
}
