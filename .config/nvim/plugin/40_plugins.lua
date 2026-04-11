local build_map = {}

local function pack_add(specs, opts)
	vim.pack.add(specs, opts)
	for _, s in ipairs(specs) do
		if type(s) == "table" then
			if type(s.config) == "function" then
				s.config()
			end
			if s.build ~= nil then
				build_map[s.src] = s.build
			end
		end
	end
end

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local src, name, kind = ev.data.spec.src, ev.data.spec.name, ev.data.kind
		if kind ~= "install" and kind ~= "update" then
			return
		end
		if not ev.data.active then
			vim.cmd.packadd(name)
		end
		if build_map[src] ~= nil then
			if type(build_map[src]) == "function" then
				build_map[src]()
			elseif type(build_map[src]) == "string" then
				vim.cmd(build_map[src])
			end
		end
	end,
})

pack_add({
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		version = "main",
		build = "TSUpdate",
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
				"nix",
				"tsx",
				"jsx",
				"typescript",
				"javascript",
				"vue",
				"svelte",
			}
			local filetypes = {
				"sh",
				"javascriptreact",
				"typescriptreact",
				(table.unpack or unpack)(langs),
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
		src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
		version = vim.version.range("1.*"),
		config = function()
			require("treesitter-context").setup({ max_lines = 5 })
		end,
	},
	{
		src = "https://github.com/neovim/nvim-lspconfig",
		version = "master",
		config = function()
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
					--[[
					vim.keymap.set("n", "<leader>bf", vim.lsp.buf.format, opts)
					if client.server_capabilities.document_range_formatting then
						vim.keymap.set("v", "<leader>bf", vim.lsp.buf.format, opts)
					end
					]]
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

			vim.lsp.config("lua_ls", {
				filetypes = { "lua" },
				settings = {
					Lua = {
						telemetry = { enable = false },
						codeLens = { enable = true },
						hint = { enable = true },
						runtime = {
							version = jit and "LuaJIT" or _VERSION or "Lua 5.1",
							pathStrict = true,
							path = {
								"lua/?.lua",
								"lua/?/init.lua",
							},
						},
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								"${3rd}/luv/library",
							},
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
	{
		src = "https://github.com/williamboman/mason.nvim",
		version = vim.version.range("2.*"),
		build = "MasonUpdate",
		config = function()
			require("mason").setup({})
		end,
	},
	{
		src = "https://github.com/williamboman/mason-lspconfig.nvim",
		version = vim.version.range("2.*"),
		build = "MasonUpdate",
		config = function()
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
		end,
	},
	{
		src = "https://github.com/AlexvZyl/nordic.nvim",
		version = "main",
		config = function()
			require("nordic").setup({
				transparent = {
					bg = true,
					float = false,
				},
				on_highlight = function(highlights, palette)
					highlights.Comment = {
						fg = palette.gray5,
					}
					highlights.StatusLine = {
						fg = palette.while3,
						bg = palette.gray2,
					}
					highlights.LineNr = {
						fg = palette.gray5,
					}
					highlights.PmenuSel = {
						bg = palette.blue0,
					}
					highlights.PmenuThumb = {
						bg = palette.blue0,
					}
				end,
			})
			require("nordic").load({})
		end,
	},
	{
		src = "https://github.com/stevearc/oil.nvim",
		version = vim.version.range("2.*"),
		config = function()
			require("oil").setup({})
		end,
	},
	{
		src = "https://github.com/mbbill/undotree",
		version = "master",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
	{
		src = "https://github.com/ibhagwan/fzf-lua",
		version = "main",
		config = function()
			local fzf = require("fzf-lua")
			local pick_opts = {
				cwd_prompt = false,
				hidden = true,
				follow = true,
			}
			fzf.setup({
				fzf_opts = {
					["--tiebreak"] = "begin",
				},
				files = pick_opts,
				grep = {
					cmd = table.concat({
						"rg",
						"--vimgrep",
						"--hidden",
						"--follow",
						"--glob",
						'"!**/.git/*"',
						"--column",
						"--line-number",
						"--no-heading",
						"--color=always",
						"--smart-case",
						"--max-columns=4096",
						"-e",
					}, " "),
					(table.unpack or unpack)(pick_opts),
				},
			})
			vim.keymap.set("n", "<leader>ff", fzf.files)
			vim.keymap.set("n", "<leader>fg", fzf.live_grep)
			vim.keymap.set("n", "<C-p>", fzf.git_files)
			vim.keymap.set("n", "<leader>fs", function()
				fzf.grep({ search = vim.fn.input("Grep> ") })
			end)
			vim.keymap.set("n", "<leader>fw", function()
				fzf.grep({ search = vim.fn.expand("<cword>") })
			end)
		end,
	},
	{
		src = "https://github.com/tpope/vim-fugitive",
		version = vim.version.range("3.*"),
		config = function()
			vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
		end,
	},
	{
		src = "https://github.com/lewis6991/gitsigns.nvim",
		version = vim.version.range("2.*"),
		config = function()
			require("gitsigns").setup({})
		end,
	},
	{
		src = "https://github.com/nvim-lua/plenary.nvim",
		version = "master",
	},
	{
		src = "https://github.com/ThePrimeagen/harpoon",
		version = "harpoon2",
		config = function()
			local harpoon = require("harpoon")
			harpoon:setup()
			vim.keymap.set("n", "<leader>e", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<leader>E", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "<C-h>", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<C-j>", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<C-k>", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<C-l>", function()
				harpoon:list():select(4)
			end)
			vim.keymap.set("n", "<C-[>", function()
				harpoon:list():prev()
			end)
			vim.keymap.set("n", "<C-]>", function()
				harpoon:list():next()
			end)
		end,
	},
	{
		src = "https://github.com/j-hui/fidget.nvim",
		version = vim.version.range("1.*"),
		config = function()
			require("fidget").setup({
				notification = {
					window = {
						winblend = 0,
					},
				},
			})
		end,
	},
	{
		src = "https://github.com/laytan/cloak.nvim",
		version = "main",
		config = function()
			require("cloak").setup({
				patterns = {
					{
						file_pattern = ".env*",
						cloak_pattern = "=.+",
						replace = nil,
					},
				},
			})
		end,
	},
	{
		src = "https://github.com/zk-org/zk-nvim",
		version = "main",
		config = function()
			require("zk").setup({
				picker = "fzf_lua",
				lsp = {
					config = {
						cmd = { "zk", "lsp" },
						name = "zk",
					},
					auto_attach = {
						enabled = true,
						filetypes = { "markdown" },
					},
				},
			})
		end,
	},
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
		config = function()
			require("blink.cmp").setup({
				keymap = {
					preset = "default",
				},
				appearance = {
					nerd_font_variant = "mono",
					kind_icons = {},
				},
				cmdline = {
					keymap = {
						preset = "inherit",
					},
					completion = {
						menu = {
							auto_show = false,
						},
						ghost_text = {
							enabled = true,
						},
					},
				},
				completion = {
					list = {
						selection = {
							preselect = true,
							auto_insert = false,
						},
					},
					documentation = {
						auto_show = false,
					},
					ghost_text = {
						enabled = true,
					},
					menu = {
						draw = {
							components = {
								source_name = {
									width = { max = 30 },
									text = function(ctx)
										return "[" .. ctx.source_name .. "]"
									end,
									highlight = "BlinkCmpSource",
								},
							},
							columns = {
								{ "kind_icon", "label",       gap = 1 },
								{ "kind",      "source_name", gap = 1 },
							},
							treesitter = { "lsp" },
						},
					},
				},
				sources = {
					default = { "lsp", "snippets", "path", "buffer" },
				},
				signature = {
					enabled = true,
				},
				fuzzy = {
					implementation = "prefer_rust_with_warning",
					sorts = {
						"score",
						"sort_text",
						"label",
					},
				},
			})
		end,
	},
	{
		src = "https://github.com/stevearc/conform.nvim",
		version = vim.version.range("9.*"),
		config = function()
			---@param formatters { [1]: string, fallback?: string|string[] }[]
			---@return fun(bufnr: integer): string[]
			local function get_formatters(formatters)
				local conform = require("conform")
				return function(bufnr)
					---@type string[]
					local results = {}
					for _, f in ipairs(formatters) do
						if conform.get_formatter_info(f[1], bufnr).available then
							table.insert(results, f[1])
						elseif f.fallback ~= nil then
							if type(f.fallback) == "string" then
								table.insert(results, f.fallback)
							elseif type(f.fallback) == "table" then
								local fallback = f.fallback --[[@as string[]=]]
								for _, v in ipairs(fallback) do
									table.insert(results, v)
								end
							end
						end
					end
					return results
				end
			end
			vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
			local conform = require("conform")
			local prettier_fmt = { "prettierd", "prettier", stop_after_first = true }
			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					zig = { "zigfmt" },
					sh = { "shfmt" },
					zsh = { "shfmt" },
					bash = { "shfmt" },
					asm = { "asmfmt" },
					rust = { "rustfmt", lsp_format = "fallback" },
					go = get_formatters({
						{ "gofumpt",           fallback = "gofmt" },
						{ "goimports-reviser", fallback = "goimports" },
					}),
					python = get_formatters({
						{ "ruff_format", fallback = { "isort", "black" } },
					}),
					cs = { "omnisharp", lsp_format = "fallback" },
					proto = { "buf", "clang-format", stop_after_first = true },
					javascript = prettier_fmt,
					typescript = prettier_fmt,
					json = prettier_fmt,
					jsonc = prettier_fmt,
					html = prettier_fmt,
					css = prettier_fmt,
					scss = prettier_fmt,
					sass = prettier_fmt,
					less = prettier_fmt,
					vue = prettier_fmt,
					svelte = prettier_fmt,
					javascriptreact = prettier_fmt,
					typescriptreact = prettier_fmt,
					["*"] = { "codespell" },
					["_"] = { "trim_whitespace" },
				},
			})
		end,
	},
	{
		src = "https://github.com/olexsmir/gopher.nvim",
		version = "main",
		config = function()
			require("gopher").setup({})
		end,
	},
	{
		src = "https://github.com/nvim-flutter/flutter-tools.nvim",
		version = "main",
		config = function()
			require("flutter-tools").setup({})
		end,
	},
	{
		src = "https://github.com/supermaven-inc/supermaven-nvim",
		version = "main",
		config = function()
			require("supermaven-nvim").setup({
				keymaps = {
					accept_suggestion = "<Tab>",
					clear_suggestion = "<C-\\>",
					--accept_word = "<C-j>",
				},
				disable_keymaps = false,
				disable_inline_completion = false,
				log_level = "info",
				ignore_filetypes = {},
				condition = function()
					return false
				end,
			})
		end,
	},
})
