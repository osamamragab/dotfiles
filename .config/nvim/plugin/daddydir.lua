local augroup = vim.api.nvim_create_augroup("daddydir", { clear = true })

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup,
	callback = function(ev)
		if ev.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(ev.match) or ev.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})
