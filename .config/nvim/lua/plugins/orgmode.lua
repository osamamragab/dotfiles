return {
	"nvim-orgmode/orgmode",
	ft = "org",
	event = "VeryLazy",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter", lazy = true },
	},
	config = function()
		require("orgmode").setup_ts_grammar()
		require("orgmode").setup({
			org_agenda_files = "~/docs/uni/**/*",
			org_default_notes_file = "~/docs/notes/refile.org",
		})
	end,
}
