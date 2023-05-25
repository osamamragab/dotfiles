require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "zig", "rust", "go", "python", "lua", "bash" },
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

require("treesitter-context").setup({})
