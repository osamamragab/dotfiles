local lsp = require("lspconfig")

local cmp = require("cmp")
local cmplsp = require("cmp_nvim_lsp")

cmp.setup({
	mapping = {
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer" },
	}
})

local capabilities = vim.lsp.protocol.make_client_capabilities()

local function config(cfg)
	return vim.tbl_deep_extend("force", { capabilities = cmplsp.update_capabilities(capabilities) }, cfg or {})
end


lsp.clangd.setup(config({
	cmd = { "clangd", "--background-index", "--clang-tidy" },
	root_dir = function() return vim.loop.cwd() end
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

lsp.svelte.setup(config())

lsp.vuels.setup(config())

local sumneko_lua_path = vim.fn.expand("$HOME/programs/lua-language-server")
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
					[vim.fn.expand("$HOME/.local/share/luarocks/share/lua/5.3")] = true,
				},
			},
			telemetry = {
				enable = false,
			},
		},
	},
}))

local elixirls_path = vim.fn.expand("$HOME/programs/elixir-ls")
lsp.elixirls.setup(config({
	cmd = {elixirls_path.."/bin/language_server.sh"},
	settings = {
		elixirLS = {
			dialyzerEnabled = false,
			fetchDeps = false,
		}
	},
}))

require("symbols-outline").setup({})
