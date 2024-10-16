return {
	{
		"folke/trouble.nvim",
		config = function()
			local trouble = require("trouble")
			trouble.setup({
				icons = false,
				fold_open = "<",
				fold_closed = ">",
				indent_lines = true,
				use_diagnostic_signs = true,
			})
			vim.keymap.set("n", "<leader>xw", function()
				trouble.open("workspace_diagnostics")
			end)
			vim.keymap.set("n", "<leader>xd", function()
				trouble.open("document_diagnostics")
			end)
			vim.keymap.set("n", "<leader>xq", function()
				trouble.open("quickfix")
			end)
		end,
	},
}
