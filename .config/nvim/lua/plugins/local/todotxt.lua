local M = {}

function M.archive_done()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local completed = {}
	local completed_lines = {}
	for i, line in ipairs(lines) do
		if line:sub(1, 2) == "x " then
			table.insert(completed, line)
			table.insert(completed_lines, i - 1)
		end
	end
	if #completed == 0 then
		return
	end

	local curfile = vim.api.nvim_buf_get_name(0)
	if curfile == "" then
		vim.notify("current buffer is not saved to a file", vim.log.levels.ERROR)
		return
	end

	local ok, err = pcall(function()
		local done_path = vim.fn.resolve(vim.fn.fnamemodify(curfile, ":h") .. "/done.txt")
		local done_file = io.open(done_path, "a")
		if not done_file then
			error("failed to open done.txt: " .. done_path)
		end
		for _, task in ipairs(completed) do
			done_file:write(task .. "\n")
		end
		done_file:close()
	end)
	if not ok then
		vim.notify("failed to write to done.txt: " .. tostring(err), vim.log.levels.ERROR)
		return
	end

	table.sort(completed_lines, function(a, b) return a > b end)
	for _, ln in ipairs(completed_lines) do
		vim.api.nvim_buf_set_lines(0, ln, ln + 1, false, {})
	end
end

vim.api.nvim_create_user_command("TodotxtArchiveDone", M.archive_done, {})

return M
