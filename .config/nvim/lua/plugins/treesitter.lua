return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-context" },
			-- { "nvim-treesitter/playground" },
		},
		event = "VeryLazy",
		config = function()
			require("nvim-treesitter.configs").setup({
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "org" },
				},
				ensure_installed = { "c", "zig", "rust", "go", "python", "lua", "bash", "org", "vimdoc" },
			})
			require("treesitter-context").setup({ max_lines = 5 })
		end,
	},
}
