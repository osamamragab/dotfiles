local left = "%f %r%m%{get(b:, 'gitbranch', '')}"
local right = "%y %{&fileencoding ? &fileencoding : &encoding} %{&fileformat} | %l:%c %p%%"

vim.api.nvim_create_autocmd("BufEnter", {
	group = vim.api.nvim_create_augroup("statusline", {}),
	pattern = "*",
	callback = function()
		local br = vim.fn.trim(vim.fn.system("git symbolic-ref HEAD --short 2>/dev/null"))
		if br ~= nil and br ~= "" then
			vim.b.gitbranch = "(" .. br .. ")"
		end
		vim.o.statusline = left .. "%=" .. right
	end,
})
