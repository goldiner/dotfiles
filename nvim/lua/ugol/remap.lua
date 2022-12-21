vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

local builtin = require('telescope.builtin')
vim.keymap.set("n", "<leader>pp", builtin.find_files, {})

vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
