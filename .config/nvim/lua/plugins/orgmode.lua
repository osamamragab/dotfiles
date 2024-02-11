return {
	"nvim-orgmode/orgmode",
	ft = "org",
	event = "VeryLazy",
	config = function()
		require("orgmode").setup_ts_grammar()
		require("orgmode").setup({
			org_agenda_files = {"~/docs/notes/**/*", "~/docs/uni/**/*"},
			org_default_notes_file = "~/docs/notes/refile.org",
			org_todo_keywords = {"TODO(t)", "NEXT(n)", "WAITING(w)", "|", "DONE"},
		})
	end,
}
