local M = {}

---@param done_file string? done file name relative to current file
---@return nil
function M.archive_done(done_file)
	if vim.bo.filetype ~= "todotxt" then
		return
	end
	if not done_file then
		done_file = "done.todo.txt"
	end
	local curfile = vim.api.nvim_buf_get_name(0)
	if curfile == "" then
		vim.notify("current buffer is not saved to a file", vim.log.levels.ERROR)
		return
	end
	if vim.fn.fnamemodify(curfile, ":t") == done_file then
		return
	end

	---@type { number: integer, line: string }[]
	local completed = {}
	local date = os.date("%Y-%m-%d")
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i, line in ipairs(lines) do
		if #line > 3 then
			local mark = line:sub(1, 2)
			if mark == "x " or mark == "X " then
				table.insert(completed, {
					number = i,
					line = mark .. date .. " " .. line:sub(3),
				})
			end
		end
	end
	if #completed == 0 then
		return
	end

	local ok, err = pcall(function()
		local path = vim.fn.resolve(vim.fn.fnamemodify(curfile, ":h") .. "/" .. done_file)
		local file = io.open(path, "a")
		if not file then
			error("failed to open " .. done_file .. ": " .. path)
		end
		for _, c in ipairs(completed) do
			file:write(c.line .. "\n")
		end
		file:close()
	end)
	if not ok then
		vim.notify("failed to write to done.txt: " .. tostring(err), vim.log.levels.ERROR)
		return
	end

	table.sort(completed, function(a, b)
		return a.number > b.number
	end)
	for _, c in ipairs(completed) do
		vim.api.nvim_buf_set_lines(0, c.number - 1, c.number, false, {})
	end
end

return M
