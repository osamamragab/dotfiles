return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-context" },
			-- { "nvim-treesitter/playground" },
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = { "c", "zig", "rust", "go", "python", "lua", "bash", "vimdoc" },
				sync_install = false,
				auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
			})
			require("treesitter-context").setup({ max_lines = 5 })
		end,
	},
}
