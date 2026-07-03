require("utils.pack").add({
	{
		src = "https://github.com/laytan/cloak.nvim",
		version = "main",
		config = function()
			require("cloak").setup({
				patterns = {
					{
						file_pattern = ".env*",
						cloak_pattern = "=.+",
						replace = nil,
					},
				},
			})
		end,
	},
})
