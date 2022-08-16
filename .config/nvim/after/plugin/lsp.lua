local lsp = require("lspconfig")
local lsputil = require("lspconfig.util")
local cmp = require("cmp")
local cmplsp = require("cmp_nvim_lsp")
local luasnip = require("luasnip")
local null_ls = require("null-ls")
local keymap = require("x.keymap")
local nnoremap = keymap.nnoremap
local inoremap = keymap.inoremap
local augroupfmt = vim.api.nvim_create_augroup("LspFormatting", {})

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
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

local capabilities = cmplsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local function config(cfg)
	return vim.tbl_deep_extend("force", {
		capabilities = capabilities,
		on_attach = function(client)
			client.resolved_capabilities.document_formatting = false
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

lsp.denols.setup(config())

lsp.emmet_ls.setup(config({
	filetypes = { "html", "css", "svelte", "vue", "jsx", "tsx" },
}))

lsp.svelte.setup(config())

lsp.vuels.setup(config())

lsp.cssls.setup(config())

lsp.yamlls.setup(config())

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

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.trim_whitespace,
		null_ls.builtins.formatting.clang_format,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.black,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.completion.spell,
		null_ls.builtins.code_actions.shellcheck,
	},
	on_attach = function(client, bufnr)
		if client.resolved_capabilities.document_formatting then
			vim.api.nvim_clear_autocmds({ group = augroupfmt, buffer = bufnr })
			vim.api.nvim_create_autocmd({ "BufWritePre" }, {
				group = augroupfmt,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.formatting_sync(nil, 5000)
				end,
			})
		end
	end,
})
