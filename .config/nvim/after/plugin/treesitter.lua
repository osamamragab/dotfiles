local nnoremap = require("x.keymap").nnoremap

require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	sync_install = false,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

function ContextSetup(show_all_context)
	require("treesitter-context").setup({
		enable = true,
		throttle = true,
		max_lines = 0,
		show_all_context = show_all_context,
		patterns = {
			default = {
				"function",
				"method",
				"for",
				"while",
				"if",
				"switch",
				"case",
			},
			rust = {
				"loop_expression",
				"impl_item",
			},
			typescript = {
				"class_declaration",
				"abstract_class_declaration",
				"else_clause",
			},
		},
	})
end

nnoremap("<leader>cf", function()
	ContextSetup(true)
end)
nnoremap("<leader>cd", function()
	ContextSetup(false)
end)
ContextSetup(false)
