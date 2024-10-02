return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
				},
				ensure_installed = { "c", "zig", "rust", "go", "python", "lua", "bash", "vimdoc" },
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
