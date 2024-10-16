local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local format_group = augroup("format", { clear = true })
local filetype_group = augroup("filetype", { clear = true })

autocmd({ "BufNewFile", "BufRead" }, {
	group = filetype_group,
	pattern = "*.h",
	command = "setlocal ft=c",
})

autocmd({ "BufNewFile", "BufRead" }, {
	group = filetype_group,
	pattern = { "todo.txt", "done.txt", "*.todo.txt", "*.done.txt" },
	command = "setlocal ft=todotxt",
})

autocmd({ "BufNewFile", "BufRead" }, {
	group = filetype_group,
	pattern = { "*.pcss" },
	command = "setlocal ft=css",
})

autocmd({ "BufEnter" }, {
	group = augroup("statusline", { clear = true }),
	pattern = "*",
	callback = function(_)
		vim.opt.statusline = "%f %r%m%=%y %{&fileencoding ? &fileencoding : &encoding} %{&fileformat} | %l:%c %p%%"
	end,
})

autocmd({ "BufReadPost" }, {
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

autocmd({ "BufWritePre" }, {
	group = augroup("daddydir", { clear = true }),
	callback = function(ev)
		if ev.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(ev.match) or ev.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

autocmd({ "BufWritePre" }, {
	group = format_group,
	pattern = "*",
	callback = function(_)
		local cur = vim.fn.getpos(".")
		vim.cmd("%s/\\s\\+$//e")
		vim.fn.setpos(".", cur)
	end,
})

autocmd({ "BufWritePre" }, {
	group = format_group,
	pattern = "*.go",
	callback = function(_)
		vim.lsp.buf.format()
		vim.lsp.buf.code_action({
			context = {
				only = {
					"source.organizeImports",
				},
			},
			apply = true,
		})
	end,
})
