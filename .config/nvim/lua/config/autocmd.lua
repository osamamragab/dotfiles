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

autocmd({ "BufWritePost" }, {
	group = filetype_group,
	pattern = { "xdefaults", "Xdefaults", "xresources", "Xresources" },
	command = "!xrdb %",
})

autocmd({ "BufWritePost" }, {
	group = filetype_group,
	pattern = "sxhkdrc",
	command = "!pkill -SIGUSR1 sxhkd",
})

autocmd({ "BufReadPost" }, {
	group = augroup("curpos", { clear = true }),
	pattern = "*",
	callback = function(_)
		local ft = vim.bo.filetype
		local line =  vim.fn.line("'\"")
		if line >= 1 and line <= vim.fn.line("$") and ft ~= "commit" and ft ~= "xxd" and ft ~= "gitrebase" then
			vim.cmd("normal! g`\"")
		end
	end
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
