return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local langs = {
				"c",
				"zig",
				"cpp",
				"rust",
				"go",
				"python",
				"lua",
				"bash",
				"json",
				"vimdoc",
				"todotxt",
			}
			local filetypes = {
				"sh",
				table.unpack(langs),
			}
			require("nvim-treesitter").install(langs)
			vim.api.nvim_create_autocmd({ "FileType" }, {
				group = vim.api.nvim_create_augroup("treesitter", { clear = true }),
				pattern = filetypes,
				callback = function(opts)
					vim.treesitter.start(opts.buf, nil)
					vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({ max_lines = 5 })
		end,
	},
	-- { "nvim-treesitter/playground" },
}
