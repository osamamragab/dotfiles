vim.filetype.add({
	extension = {
		h = "c",
		pcss = "css",
		http = "http",
	},
	pattern = {
		["todo.txt"] = "todotxt",
		[".*.todo.txt"] = "todotxt",
	},
})
