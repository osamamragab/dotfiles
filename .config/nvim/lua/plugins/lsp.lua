vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local opts = { buffer = ev.buf, remap = false }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<leader>ws", vim.lsp.buf.workspace_symbol, opts)
		vim.keymap.set("n", "<leader>af", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>ak", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "<leader>aj", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, opts)
	end
})

vim.diagnostic.config({
	virtual_text = true,
	update_in_insert = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			local cmp_lsp = require("cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities())

			require("mason").setup({})
			require("mason-lspconfig").setup({
				ensure_installed = {
					"clangd",
					"zls",
					"rust_analyzer",
					"gopls",
					"pyright",
					"tsserver",
					"lua_ls",
				},
				handlers = {
					function(name)
						require("lspconfig")[name].setup({ capabilities = capabilities })
					end,
					["gopls"] = function()
						require("lspconfig").gopls.setup({
							capabilities = capabilities,
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
					end,
					["lua_ls"] = function()
						local path = vim.split(package.path, ";")
						table.insert(path, "lua/?.lua")
						table.insert(path, "lua/?/init.lua")
						require("lspconfig").lua_ls.setup({
							capabilities = capabilities,
							settings = {
								Lua = {
									telemetry = { enable = false },
									runtime = {
										version = "LuaJIT",
										path = path,
									},
									diagnostics = {
										globals = {
											"vim",
										},
									},
									workspace = {
										checkThirdParty = false,
										library = {
											vim.fn.expand("$VIMRUNTIME/lua"),
										},
									},
								},
							},
						})
					end,
					["arduino_language_server"] = function()
						require("lspconfig").arduino_language_server.setup({
							capabilities = capabilities,
							cmd = {
								"arduino-language-server",
								"-cli-config",
								"$ARDUINO_DIRECTORIES_DATA/arduino-cli.yaml",
							},
						})
					end,
				},
			})
		end,
	},
	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
	},
}
