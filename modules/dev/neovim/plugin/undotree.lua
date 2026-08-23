require("utils.pack").add({
	{
		src = "https://github.com/mbbill/undotree",
		version = "master",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
})
