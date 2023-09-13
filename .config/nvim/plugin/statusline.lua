vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("statusline", {}),
	pattern = "*",
	callback = function()
		vim.opt.statusline = "%f %r%m%=%y %{&fileencoding ? &fileencoding : &encoding} %{&fileformat} | %l:%c %p%%"
	end,
})
