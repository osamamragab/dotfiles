vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1
vim.g.netrw_winsize = 25
vim.g.netrw_fastbrowse = 0

vim.g.rust_recommended_style = 0

require("Comment").setup({})
require("gitsigns").setup({})
require("nvim-autopairs").setup({})
require("symbols-outline").setup({})
require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = {
		rust = {
			require("formatter.filetypes.rust").rustfmt,
		},
		go = {
			require("formatter.filetypes.go").gofmt,
			require("formatter.filetypes.go").goimports,
		},
		python = {
			require("formatter.filetypes.python").black,
		},
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})
