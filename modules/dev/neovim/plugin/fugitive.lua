require("utils.pack").add({
	{
		src = "https://github.com/tpope/vim-fugitive",
		version = vim.version.range("3.*"),
		config = function()
			vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
		end,
	},
})
