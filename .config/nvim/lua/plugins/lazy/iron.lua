return {
	{
		"Vigemus/iron.nvim",
		config = function()
			local view = require("iron.view")
			local common = require("iron.fts.common")
			require("iron.core").setup({
				config = {
					repl_open_cmd = view.bottom(40),
					repl_definition = {
						python = {
							command = { "python3" }, -- or { "ipython", "--no-autoindent" }
							format = common.bracketed_paste_python,
							block_dividers = { "# %%", "#%%" },
						},
					},
				},
				repl_open_cmd = view.center("30%", 20),
			})
		end,
	},
}
