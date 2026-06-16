local build_map = {}

local M = {}

vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("pack", { clear = true }),
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

function M.add(specs, opts)
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

return M
