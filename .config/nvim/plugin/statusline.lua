local left = "%f %r%m"
local right = "%y %{&fileencoding ? &fileencoding : &encoding} %{&fileformat} | %l:%c %p%%"

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("statusline", {}),
	pattern = "*",
	callback = function()
		vim.b.gitbranch = vim.fn.trim(vim.fn.system("git symbolic-ref HEAD --short 2>/dev/null"))
		vim.o.statusline = left
		if vim.b.gitbranch ~= nil and vim.b.gitbranch ~= "" then
			vim.o.statusline = vim.o.statusline .. "(%{b:gitbranch})"
		end
		vim.o.statusline = vim.o.statusline .. "%=" .. right
	end,
})
