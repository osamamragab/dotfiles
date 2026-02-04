local augroup = vim.api.nvim_create_augroup("curpos", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	group = augroup,
	pattern = "*",
	callback = function(opts)
		local ft = vim.bo[opts.buf].filetype
		if ft == "commit" or ft == "rebase" then
			return
		end
		local line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
		if line > 1 and line <= vim.api.nvim_buf_line_count(opts.buf) then
			vim.api.nvim_feedkeys('g`"', "nx", false)
		end
	end,
})
