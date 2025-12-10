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
					for _, v in ipairs(f.fallback --[[@as table]]) do
						table.insert(results, v)
					end
				end
			end
		end
		return results
	end
end

return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		init = function()
			vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
		end,
		config = function()
			local conform = require("conform")
			local prettier_fmt = { "prettierd", "prettier", stop_after_first = true }

			conform.setup({
				formatters_by_ft = {
					lua = { "stylua" },
					zig = { "zigfmt" },
					sh = { "shfmt" },
					zsh = { "shfmt" },
					asm = { "asmfmt" },
					rust = { "rustfmt", lsp_format = "fallback" },
					javascript = prettier_fmt,
					typescript = prettier_fmt,
					vue = prettier_fmt,
					go = get_formatters({
						{ "gofumpt", fallback = "gofumpt" },
						{ "goimports-reviser", fallback = "goimports" },
					}),
					python = get_formatters({
						{ "ruff_format", fallback = { "isort", "black" } },
					}),
					["*"] = { "codespell" },
					["_"] = { "trim_whitespace" },
				},
			})
		end,
	},
}
