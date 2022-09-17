vim.opt.background = "dark"
vim.opt.termguicolors = true

vim.g.nord_bold = 1
vim.g.nord_italic = 1
vim.g.nord_italic_comments = 1
vim.g.nord_uniform_status_lines = 1
vim.g.nord_uniform_diff_background = 1
vim.g.nord_bold_vertical_split_line = 0

vim.cmd("colorscheme nord")

for _, name in ipairs({"Normal", "SignColumn", "CursorLineNr", "ColorColumn"}) do
	vim.api.nvim_set_hl(0, name, { bg = "NONE" })
end
