return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").install({
				"c",
				"zig",
				"cpp",
				"rust",
				"go",
				"python",
				"lua",
				"bash",
				"vimdoc",
				"todotxt",
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({ max_lines = 5 })
		end,
	},
	-- { "nvim-treesitter/playground" },
}
