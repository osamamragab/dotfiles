local augroup = vim.api.nvim_create_augroup

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	group = augroup("curpos", { clear = true }),
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

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("format_trim", { clear = true }),
	pattern = "*",
	callback = function(_)
		local cur = vim.fn.getpos(".")
		vim.cmd("%s/\\s\\+$//e")
		vim.fn.setpos(".", cur)
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("daddydir", { clear = true }),
	callback = function(ev)
		if ev.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(ev.match) or ev.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})
