local grep_cmd = {
	"rg",
	"--vimgrep",
	"--hidden",
	"--follow",
	"--glob",
	'"!**/.git/*"',
	"--column",
	"--line-number",
	"--no-heading",
	"--color=always",
	"--smart-case",
	"--max-columns=4096",
	"-e",
}

return {
	{
		"ibhagwan/fzf-lua",
		config = function()
			local fzf = require("fzf-lua")
			local pick_opts = {
				cwd_prompt = false,
				hidden = true,
				follow = true,
			}
			fzf.setup({
				fzf_opts = {
					["--tiebreak"] = "begin",
				},
				files = pick_opts,
				grep = {
					cmd = table.concat(grep_cmd, " "),
					(table.unpack or unpack)(pick_opts),
				},
			})
			vim.keymap.set("n", "<leader>ff", fzf.files)
			vim.keymap.set("n", "<leader>fg", fzf.live_grep)
			vim.keymap.set("n", "<C-p>", fzf.git_files)
			vim.keymap.set("n", "<leader>fs", function()
				fzf.grep({ search = vim.fn.input("Grep> ") })
			end)
			vim.keymap.set("n", "<leader>fw", function()
				fzf.grep({ search = vim.fn.expand("<cword>") })
			end)
		end,
	},
}
