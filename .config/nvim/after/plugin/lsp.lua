local lsp = require("lspconfig")
local lsputil = require("lspconfig.util")
local cmp = require("cmp")
local cmplsp = require("cmp_nvim_lsp")
local luasnip = require("luasnip")
local keymap = require("x.keymap")
local nnoremap = keymap.nnoremap
local inoremap = keymap.inoremap

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-f>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
	}, {
		{ name = "buffer", keyword_length = 5 },
	}),
	-- experimental = {
	-- 	ghost_text = true,
	-- },
})

require("luasnip.loaders.from_vscode").lazy_load({
	paths = { (vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/nvim/plugged/friendly-snippets" },
	include = nil,
	exclude = {},
})

local capabilities = cmplsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

local function config(cfg)
	return vim.tbl_deep_extend("force", {
		capabilities = capabilities,
		on_attach = function()
			nnoremap("gd", function()
				vim.lsp.buf.definition()
			end)
			nnoremap("gi", function()
				vim.lsp.buf.implementation()
			end)
			nnoremap("K", function()
				vim.lsp.buf.hover()
			end)
			nnoremap("<leader>gws", function()
				vim.lsp.buf.workspace_symbol()
			end)
			nnoremap("<leader>gd", function()
				vim.diagnostic.open_float()
			end)
			nnoremap("[d", function()
				vim.diagnostic.goto_next()
			end)
			nnoremap("]d", function()
				vim.diagnostic.goto_prev()
			end)
			nnoremap("<leader>gca", function()
				vim.lsp.buf.code_action()
			end)
			nnoremap("<leader>grr", function()
				vim.lsp.buf.references()
			end)
			nnoremap("<leader>grn", function()
				vim.lsp.buf.rename()
			end)
			inoremap("<C-h>", function()
				vim.lsp.buf.signature_help()
			end)
			nnoremap("<leader>gf", function()
				vim.lsp.buf.formatting()
			end)
		end,
	}, cfg or {})
end

lsp.clangd.setup(config({
	cmd = { "clangd", "--background-index", "--clang-tidy", "--suggest-missing-includes", "--header-insertion=iwyu" },
	root_dir = function()
		return vim.loop.cwd()
	end,
}))

lsp.rust_analyzer.setup(config())

lsp.zls.setup(config())

lsp.gopls.setup(config({
	cmd = { "gopls", "serve" },
	filetypes = { "go", "gomod" },
	root_dir = lsputil.root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
}))

lsp.pyright.setup(config())

lsp.tsserver.setup(config())

-- lsp.denols.setup(config())

lsp.svelte.setup(config())

lsp.vuels.setup(config())

lsp.cssls.setup(config())

local sumneko_lua_path = (vim.env.PROGRAMSDIR or vim.env.HOME .. "/programs") .. "/lua-language-server"
lsp.sumneko_lua.setup(config({
	cmd = { sumneko_lua_path .. "/bin/Linux/lua-language-server", "-E", sumneko_lua_path .. "/main.lua" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				globals = { "vim", "love", "require", "use" },
			},
			workspace = {
				library = {
					[vim.env.VIMRUNTIME .. "/lua"] = true,
					[vim.env.VIMRUNTIME .. "/lua/vim/lsp"] = true,
					["/usr/share/lua/5.3"] = true,
					[(vim.env.XDG_DATA_HOME or (vim.env.HOME .. "/.local/share")) .. "/luarocks/share/lua/5.3"] = true,
				},
			},
			telemetry = {
				enable = false,
			},
		},
	},
}))

local elixirls_path = (vim.env.PROGRAMSDIR or vim.env.HOME .. "/programs") .. "/elixir-ls"
lsp.elixirls.setup(config({
	cmd = { elixirls_path .. "/bin/language_server.sh" },
	settings = {
		elixirLS = {
			dialyzerEnabled = false,
			fetchDeps = false,
		},
	},
}))

require("flutter-tools").setup({
	lsp = config(),
});
