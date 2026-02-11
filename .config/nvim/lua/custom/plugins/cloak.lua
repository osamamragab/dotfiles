return {
	{
		"laytan/cloak.nvim",
		opts = {
			patterns = {
				{
					file_pattern = ".env*",
					cloak_pattern = "=.+",
					replace = nil,
				},
			},
		},
	},
}
