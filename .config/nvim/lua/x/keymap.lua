local M = {}

local function bind(op, gopts)
	gopts = gopts or { noremap = true }
	return function(lhs, rhs, opts)
		opts = vim.tbl_extend("force", gopts, opts or {})
		vim.keymap.set(op, lhs, rhs, opts)
	end
end

M.nmap = bind("n", { noremap = false })
M.nnoremap = bind("n")
M.vnoremap = bind("v")
M.xnoremap = bind("x")
M.inoremap = bind("i")

return M
