return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", lazy = true },
			{ "ThePrimeagen/harpoon", lazy = true },
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			telescope.setup({
				pickers = {
					find_files = {
						hidden = true,
						file_ignore_patterns = {
							"^.git/",
							"^zig-out/",
							"^zig-cache/",
							"^target/",
							"^__pycache__/",
							"^node_modules/",
						},
					},
				},
			})
			telescope.load_extension("fzf")
			telescope.load_extension("harpoon")
			vim.keymap.set("n", "<leader>ff", builtin.find_files)
			vim.keymap.set("n", "<leader>fg", builtin.live_grep)
			vim.keymap.set("n", "<C-p>", builtin.git_files)
			vim.keymap.set("n", "<leader>fs", function()
				builtin.grep_string({ search = vim.fn.input("Grep> ") })
			end)
			vim.keymap.set("n", "<leader>fw", function()
				builtin.grep_string({ search = vim.fn.expand("<cword>") })
			end)
		end,
	},
}
