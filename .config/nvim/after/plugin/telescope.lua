local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local sorters = require("telescope.sorters")
local previewers = require("telescope.previewers")

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

vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<C-p>", builtin.git_files)
vim.keymap.set("n", "<leader>fs", function()
	builtin.grep_string({ search = vim.fn.input("Grep> ") })
end)
vim.keymap.set("n", "<leader>fw", function()
	builtin.grep_string({ search = vim.fn.expand("<cword>") })
end)
