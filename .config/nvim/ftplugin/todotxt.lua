vim.api.nvim_create_user_command("TodotxtArchiveDone", function()
	require("plugins.local.todotxt").archive_done()
end, {})
