vim.filetype.add({
	extension = {
		h = "c",
		pcss = "css",
	},
	pattern = {
		["todo.txt"] = "todotxt",
		[".*.todo.txt"] = "todotxt",
	},
})
