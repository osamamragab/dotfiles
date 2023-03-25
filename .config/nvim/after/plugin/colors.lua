vim.opt.background = "dark"
vim.opt.termguicolors = true

vim.g.colors_name = "tokyodark"

vim.g.tokyodark_transparent_background = true
vim.g.tokyodark_enable_italic_comment = true
vim.g.tokyodark_enable_italic = false
vim.g.tokyodark_color_gamma = 1.0

vim.g.nord_contrast = true
vim.g.nord_borders = false
vim.g.nord_bold = true
vim.g.nord_italic = false
vim.g.nord_italic_comments = true
vim.g.nord_disable_background = true
vim.g.nord_uniform_status_lines = true
vim.g.nord_uniform_diff_background = true
vim.g.nord_bold_vertical_split_line = false

vim.g.gruvbox_baby_transparent_mode = true
vim.g.gruvbox_baby_telescope_theme = true

vim.g.sonokai_style = "andromeda"
vim.g.sonokai_better_performance = true
vim.g.sonokai_enable_italic = false
vim.g.sonokai_disable_italic_comment = true
vim.g.sonokai_transparent_background = true
vim.g.sonokai_dim_inactive_windows = true
vim.g.sonokai_diagnostic_text_highlight = true

vim.g.onedark_termcolors = 256
vim.g.onedark_terminal_italics = true

require("rose-pine").setup({
	variant = "moon",
	disable_italics = true,
	disable_background = true,
})

vim.cmd.colorscheme(vim.g.colors_name or "habamax")

for _, name in ipairs({"Normal", "NormalFloat", "SignColumn"}) do
	vim.api.nvim_set_hl(0, name, { bg = "none" })
end
