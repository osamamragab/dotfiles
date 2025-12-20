return {
	{
		"ptdewey/pendulum-nvim",
		config = function()
			require("pendulum").setup({
				log_file = vim.fn.resolve(vim.fn.stdpath("state") .. "/pendulum_log.csv"),
			})
		end,
	},
}
