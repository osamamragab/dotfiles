vim.opt.background = "dark"
vim.opt.termguicolors = true

vim.g.nord_bold = 1
vim.g.nord_italic = 1
vim.g.nord_italic_comments = 1
vim.g.nord_uniform_status_lines = 1
vim.g.nord_uniform_diff_background = 1
vim.g.nord_bold_vertical_split_line = 0

vim.cmd.colorscheme(vim.g.colors_name or "nord")

for _, name in ipairs({"Normal", "NormalFloat", "SignColumn"}) do
	vim.api.nvim_set_hl(0, name, { bg = "none" })
end
