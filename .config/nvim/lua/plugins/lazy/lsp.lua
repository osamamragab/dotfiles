return {
	{
		"williamboman/mason-lspconfig.nvim",
		build = ":MasonUpdate",
		dependencies = {
			{ "williamboman/mason.nvim", opts = {}, build = ":MasonUpdate" },
			{ "neovim/nvim-lspconfig" },
		},
		config = function()
			require("mason").setup({})
			require("mason-lspconfig").setup({
				automatic_enable = true,
				ensure_installed = {
					"clangd",
					"zls",
					"efm",
					"gopls",
					"rust_analyzer",
					"basedpyright",
					"ruff",
					"ts_ls",
					"lua_ls",
					"phpactor",
				},
			})

			vim.diagnostic.config({
				virtual_text = true,
				update_in_insert = true,
				float = {
					border = "rounded",
					source = true,
				},
			})

			vim.lsp.config("*", {
				capabilities = vim.lsp.protocol.make_client_capabilities(),
				on_attach = function(_, bufnr)
					local opts = { buffer = bufnr, remap = false }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>af", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "<leader>ak", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, opts)
					vim.keymap.set("n", "<leader>aj", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, opts)
					vim.keymap.set("n", "<leader>bf", function()
						require("conform").format({
							async = true,
							lsp_format = "fallback",
						})
					end, opts)
					-- vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, opts)
				end,
			})

			vim.lsp.config("clangd", {
				cmd = {
					"clangd",
					"--enable-config",
					"--clang-tidy",
					"--background-index",
				},
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
			})

			vim.lsp.config("gopls", {
				settings = {
					gopls = {
						completeUnimported = true,
						usePlaceholders = true,
						staticcheck = true,
						gofumpt = true,
						analyses = {
							unusedparams = true,
							unusedvariable = true,
							unusedwrite = true,
						},
					},
				},
			})

			vim.lsp.config("ts_ls", {
				init_options = {
					maxTsServerMemory = 3 * 1024,
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = vim.fn.expand(
								"$MASON/packages/vue-language-server/node_modules/@vue/language-server"
							),
							languages = { "vue" },
							configNamespace = "typescript",
						},
					},
				},
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			})

			vim.lsp.config("arduino_language_server", {
				cmd = {
					"arduino-language-server",
					"-cli-config",
					vim.fn.expand("$ARDUINO_DIRECTORIES_DATA/arduino-cli.yaml"),
				},
			})
		end,
	},
}
