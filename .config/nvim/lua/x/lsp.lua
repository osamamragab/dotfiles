local lsp = require("lspconfig")

local cmp = require("cmp")
local cmplsp = require("cmp_nvim_lsp")
local luasnip = require("luasnip")

cmp.setup({
	snippet = {
		expand = function(args) luasnip.lsp_expand(args.body) end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer" },
	})
})

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" }
	}
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" }
	}, {
		{ name = "cmdline" }
	})
})

require("luasnip.loaders.from_vscode").lazy_load({
	paths = {(vim.env.XDG_CONFIG_HOME or vim.env.HOME.."/.config") .. "/nvim/plugged/friendly-snippets"},
	include = nil,
	exclude = {},
})

local capabilities = cmplsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local function config(cfg)
	return vim.tbl_deep_extend("force", { capabilities = capabilities }, cfg or {})
end

lsp.clangd.setup(config({
	cmd = {"clangd", "--background-index", "--clang-tidy"},
	root_dir = function() return vim.loop.cwd() end,
}))

lsp.gopls.setup(config({
	cmd = {"gopls"},
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
}))

lsp.rust_analyzer.setup(config())

lsp.pyright.setup(config())

lsp.tsserver.setup(config())

lsp.denols.setup(config())

lsp.emmet_ls.setup(config({
	filetypes = {"html", "css", "svelte", "vue", "jsx", "tsx"},
}))

lsp.svelte.setup(config())

lsp.vuels.setup(config())

lsp.cssls.setup(config())

lsp.yamlls.setup(config())

local sumneko_lua_path = vim.env.HOME .. "/programs/lua-language-server"
lsp.sumneko_lua.setup(config({
	cmd = {sumneko_lua_path.."/bin/Linux/lua-language-server", "-E", sumneko_lua_path.."/main.lua"},
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				globals = {"vim", "love"},
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					["/usr/share/lua/5.3"] = true,
					[(vim.env.XDG_DATA_HOME or vim.env.HOME.."/.local/share") .. "/luarocks/share/lua/5.3"] = true,
				},
			},
			telemetry = {
				enable = false,
			},
		},
	},
}))

local elixirls_path = vim.env.HOME .. "/programs/elixir-ls"
lsp.elixirls.setup(config({
	cmd = {elixirls_path.."/bin/language_server.sh"},
	settings = {
		elixirLS = {
			dialyzerEnabled = false,
			fetchDeps = false,
		},
	},
}))

require("symbols-outline").setup({})
