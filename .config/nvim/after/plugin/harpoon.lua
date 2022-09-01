local ui = require("harpoon.ui")
local mark = require("harpoon.mark")
local nnoremap = require("x.keymap").nnoremap

local silent = { silent = true }

nnoremap("<leader>a", function() mark.add_file() end, silent)
nnoremap("<leader>e", function() ui.toggle_quick_menu() end, silent)

nnoremap("<C-h>", function() ui.nav_file(1) end, silent)
nnoremap("<C-j>", function() ui.nav_file(2) end, silent)
nnoremap("<C-k>", function() ui.nav_file(3) end, silent)
nnoremap("<C-l>", function() ui.nav_file(4) end, silent)
