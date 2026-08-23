require("utils.pack").add({
	{
		src = "https://github.com/nvim-lua/plenary.nvim",
		version = "master",
	},
	{
		src = "https://github.com/ThePrimeagen/harpoon",
		version = "harpoon2",
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()
			vim.keymap.set("n", "<leader>e", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<leader>E", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)
			vim.keymap.set("n", "<C-h>", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<C-j>", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<C-k>", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<C-l>", function()
				harpoon:list():select(4)
			end)
			vim.keymap.set("n", "<C-[>", function()
				harpoon:list():prev()
			end)
			vim.keymap.set("n", "<C-]>", function()
				harpoon:list():next()
			end)
		end,
	},
})
