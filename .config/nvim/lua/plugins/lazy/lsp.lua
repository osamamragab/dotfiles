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
	end,
})

vim.diagnostic.config({
	virtual_text = true,
	update_in_insert = true,
	float = {
		border = "rounded",
		source = true,
	},
})

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
				ensure_installed = {
					"clangd",
					"zls",
					"rust_analyzer",
					"gopls",
					"pyright",
					"ts_ls",
					"lua_ls",
				},
			})

			vim.lsp.config("clangd", {
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

			vim.lsp.config("vtsls", {
				settings = {
					vtsls = {
						tsserver = {
							globalPlugins = {
								{
									name = "@vue/typescript-plugin",
									location = vim.fn.expand(
										"$MASON/packages/vue-language-server/node_modules/@vue/language-server"),
									languages = { "vue" },
									configNamespace = "typescript",
								},
							},
						},
					},
				},
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			})

			vim.lsp.config("vue_ls", {
				on_init = function(client)
					client.handlers["tsserver/request"] = function(_, result, context)
						local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
						if #clients == 0 then
							vim.notify("Could not find `vtsls` lsp client, vue_lsp would not work without it.",
								vim.log.levels.ERROR)
							return
						end
						local ts_client = clients[1]

						local param = unpack(result)
						local id, command, payload = unpack(param)
						ts_client:exec_cmd(
							{
								title = "vue_request_forward",
								command = "typescript.tsserverRequest",
								arguments = {
									command,
									payload,
								},
							},
							{ bufnr = context.bufnr },
							function(_, r)
								local response_data = { { id, r.body } }
								---@diagnostic disable-next-line: param-type-mismatch
								client:notify("tsserver/response", response_data)
							end
						)
					end
				end,
			})

			vim.lsp.config("arduino_language_server", {
				cmd = {
					"arduino-language-server",
					"-cli-config",
					"$ARDUINO_DIRECTORIES_DATA/arduino-cli.yaml",
				},
			})
		end,
	},
}
