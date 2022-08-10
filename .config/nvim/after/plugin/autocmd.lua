local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local filetype = augroup("filetype", {})
local autofmt = augroup("autofmt", {})

autocmd({"BufNewFile", "BufRead"}, {
	group = filetype,
	pattern = "*.h",
	command = "setlocal ft=c",
})

autocmd({"BufNewFile", "BufRead"}, {
	group = filetype,
	pattern = "*.dockerfile",
	command = "setlocal ft=dockerfile",
})

autocmd({"FileType"}, {
	group = filetype,
	pattern = {"c", "cpp"},
	command = "setlocal commentstring=//\\ %s",
})

autocmd({"FileType"}, {
	group = filetype,
	pattern = {"python", "ruby", "yaml", "markdown"},
	command = "setlocal expandtab",
})

autocmd({"BufWritePost"}, {
	group = filetype,
	pattern = {"xdefaults", "Xdefaults", "xresources", "Xresources"},
	command = "!xrdb %",
})

autocmd({"BufEnter", "BufWinEnter", "TabEnter"}, {
	group = autofmt,
	pattern = "*.rs",
	callback = function()
		require("lsp_extensions").inlay_hints({ prefix = "-> ", highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint" }})
	end,
})

autocmd({"BufWritePre"}, {
	group = autofmt,
  pattern = "*",
	command = "FormatWrite",
})
