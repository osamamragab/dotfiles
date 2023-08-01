local left = "%f %r%m"
local right = "%y %{&fileencoding ? &fileencoding : &encoding} %{&fileformat} | %l:%c %p%%"

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("statusline", {}),
	pattern = "*",
	callback = function()
		vim.opt.statusline = left .. "%=" .. right
	end,
})
