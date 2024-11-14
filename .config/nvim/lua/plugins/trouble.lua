return {
	{
		"folke/trouble.nvim",
		config = function()
			local trouble = require("trouble")
			trouble.setup({})
			vim.keymap.set("n", "<leader>xx", function()
				trouble.toggle("diagnostics")
			end)
			vim.keymap.set("n", "<leader>xl", function()
				trouble.toggle("loclist")
			end)
			vim.keymap.set("n", "<leader>xq", function()
				trouble.toggle("qflist")
			end)
			vim.keymap.set("n", "<leader>xn", function()
				trouble.next({
					jump = true,
					skip_groups = true,
				})
			end)
			vim.keymap.set("n", "<leader>xp", function()
				trouble.preousv({
					jump = true,
					skip_groups = true,
				})
			end)
		end,
	},
}
