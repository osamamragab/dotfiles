return {
	{
		"supermaven-inc/supermaven-nvim",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<Tab>",
					clear_suggestion = "<C-]>",
					accept_word = "<C-j>",
				},
				disable_keymaps = false,
				disable_inline_completion = false,
				log_level = "info",
				ignore_filetypes = {},
				condition = function()
					return false
				end,
			})
		end,
	},
}
