local lsp = require("lspconfig")
local config = lsp.util.default_config

config.capabilities = vim.tbl_deep_extend(
	"force",
	config.capabilities,
	require("cmp_nvim_lsp").default_capabilities()
)

config.on_attach = function(_, bufnr)
	local opts = { buffer = bufnr, remap = false }
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>gws", vim.lsp.buf.workspace_symbol, opts)
	vim.keymap.set("n", "<leader>gd", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "<leader>gca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>grr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<leader>grn", vim.lsp.buf.rename, opts)
	vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, opts)
end

vim.diagnostic.config({ virtual_text = true })

local function server_setup(name)
	local opts = {}
	if name == "lua_ls" then
		local path = vim.split(package.path, ";")
		table.insert(path, "lua/?.lua")
		table.insert(path, "lua/?/init.lua")
		opts = vim.tbl_deep_extend("force", opts, {
			settings = {
				Lua = {
					telemetry = { enable = false },
					runtime = {
						version = "LuaJIT",
						path = path,
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						checkThirdParty = false,
						library = {
							vim.fn.expand("$VIMRUNTIME/lua"),
							vim.fn.stdpath("config") .. "/lua",
						},
					},
				},
			},
		})
	end
	lsp[name].setup(opts)
end

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
	handlers = { server_setup },
})

local cmp = require("cmp")
cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		["<C-f>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-h>"] = cmp.mapping.abort(),
		["<C-l>"] = cmp.mapping.confirm({ select = true }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<Tab>"] = nil,
		["<S-Tab"] = nil,
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer", keyword_length = 5 },
		{ name = "path" },
	}),
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
})

require("luasnip.loaders.from_vscode").lazy_load()
