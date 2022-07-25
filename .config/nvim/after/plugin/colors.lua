vim.g.colors_name = "nord"
vim.opt.background = "dark"
vim.opt.termguicolors = true

vim.g.nord_bold = 1
vim.g.nord_italic = 1
vim.g.nord_italic_comments = 1
vim.g.nord_uniform_status_lines = 1
vim.g.nord_uniform_diff_background = 1
vim.g.nord_cursor_line_number_background = 1

vim.g.sonokai_style = "atlantis"
vim.g.sonokai_better_performance = 1
vim.g.sonokai_transparent_background = 1
vim.g.sonokai_diagnostic_virtual_text = "colored"

vim.g.gruvbox_contrast_dark = "hard"
vim.g.gruvbox_sign_column = "dark0_hard"
vim.g.gruvbox_invert_selection = 0
vim.g.gruvbox_bold = 0

--hi Normal guibg=NONE ctermbg=NONE
--hi SignColumn guibg=NONE ctermbg=NONE
--hi CursorLineNr guibg=NONE ctermbg=NONE

vim.cmd("colorscheme " .. vim.g.colors_name)


local hl = function(name, opts)
	vim.api.nvim_set_hl(0, name, opts)
end

hl("Normal", { bg = "none" })
hl("SignColumn", { bg = "none" })
hl("CursorLineNr", { bg = "none" })
hl("ColorColumn", { bg = "none", ctermbg = 0 })
