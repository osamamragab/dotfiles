return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		-- build = "cargo build --release",

		---@module "blink.cmp"
		---@type blink.cmp.Config
		opts = {
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
							{ "kind_icon", "label", gap = 1 },
							{ "kind", "source_name", gap = 1 },
						},
						treesitter = { "lsp" },
					},
				},
			},
			sources = {
				default = { "lsp", "path", "buffer" },
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
		},
		opts_extend = { "sources.default" },
	},
}
