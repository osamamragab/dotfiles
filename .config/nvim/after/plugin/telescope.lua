local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")
local nnoremap = require("x.keymap").nnoremap

telescope.setup({
	defaults = {
		file_sorter = sorters.get_fzy_sorter,
		prompt_prefix = " > ",
		file_previewer = previewers.vim_buffer_cat.new,
		grep_previewer = previewers.vim_buffer_vimgrep.new,
		qflist_previewer = previewers.vim_buffer_qflist.new,
		mappings = {
			i = {
				["<C-x>"] = false,
				["<C-q>"] = actions.send_to_qflist,
			},
		},
	},
	pickers = {
		find_files = {
			hidden = true,
			file_ignore_patterns = {
				".git",
				".pyc",
				"*_build",
				"target",
				"coverage",
				"node_modules",
				"andorid",
				"ios",
			},
		},
	},
	extensions = {
		fzy_native = {
			override_generic_sorter = false,
			override_file_sorter = true,
		},
	},
})

telescope.load_extension("fzy_native")
telescope.load_extension("harpoon")
telescope.load_extension("git_worktree")

nnoremap("<leader>ff", function()
	builtin.find_files()
end)
nnoremap("<leader>fg", function()
	builtin.live_grep()
end)
nnoremap("<C-p>", function()
	builtin.git_files()
end)
nnoremap("<leader>fw", function()
	builtin.grep_string({ search = vim.fn.expand("<cword>") })
end)
nnoremap("<leader>fb", function()
	builtin.buffers()
end)
nnoremap("<leader>fh", function()
	builtin.help_tags()
end)
nnoremap("<leader>gs", function()
	builtin.git_branches()
end)
nnoremap("<leader>gw", function()
	telescope.extensions.git_worktree.git_worktrees()
end)
nnoremap("<leader>gc", function()
	telescope.extensions.git_worktree.create_git_worktree()
end)
