vim.opt.background = "dark"
vim.opt.termguicolors = true

vim.g.colors_name = "nord"

if vim.g.colors_name == "tokyodark" then
	vim.g.tokyodark_transparent_background = true
	vim.g.tokyodark_enable_italic_comment = true
	vim.g.tokyodark_enable_italic = false
	vim.g.tokyodark_color_gamma = 1.0
elseif vim.g.colors_name == "nord" then
	vim.g.nord_bold = true
	vim.g.nord_italic = true
	vim.g.nord_italic_comments = true
	vim.g.nord_uniform_status_lines = true
	vim.g.nord_uniform_diff_background = true
	vim.g.nord_bold_vertical_split_line = false
elseif vim.g.colors_name == "gruvbox-baby" then
	vim.g.gruvbox_baby_transparent_mode = true
	vim.g.gruvbox_baby_telescope_theme = true
elseif vim.g.colors_name == "sonokai" then
	vim.g.sonokai_style = "andromeda"
	vim.g.sonokai_better_performance = true
	vim.g.sonokai_enable_italic = false
	vim.g.sonokai_disable_italic_comment = true
	vim.g.sonokai_transparent_background = true
	vim.g.sonokai_dim_inactive_windows = true
	vim.g.sonokai_diagnostic_text_highlight = true
elseif vim.g.colors_name == "onedark" then
	vim.g.onedark_termcolors = 256
	vim.g.onedark_terminal_italics = true
elseif vim.g.colors_name == "rose-pine" then
	require("rose-pine").setup({
		variant = "moon",
		disable_italics = true,
		disable_background = true,
	})
end

vim.cmd.colorscheme(vim.g.colors_name or "habamax")

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
