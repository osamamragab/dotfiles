return {
	{
		"folke/zen-mode.nvim",
		config = function()
			vim.keymap.set("n", "<leader>zz", function()
				require("zen-mode").setup({
					window = {
						width = 90,
					},
				})
				require("zen-mode").toggle()
				vim.wo.number = true
				vim.wo.rnu = true
			end)
			vim.keymap.set("n", "<leader>zZ", function()
				require("zen-mode").setup({
					window = {
						width = 80,
					},
				})
				require("zen-mode").toggle()
				vim.wo.number = false
				vim.wo.rnu = false
				vim.opt.colorcolumn = "0"
			end)
		end,
	},
}
