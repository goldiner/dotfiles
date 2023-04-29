---@type MappingsTable
local M = {}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>o"] = { ":%bd|e#<cr>", "enter command mode", opts = { nowait = true } },
    ["<leader>wt"] = { "<cmd>TroubleToggle<cr>", "toggle truoble", opts = {silent = true, noremap = true} },
    ["<C-S-k>"] = { ":m .-2<cr>==", "move line up", opts = { nowait = true } },
    ["<C-S-j>"] = { ":m .+1<cr>==", "move line down", opts = { nowait = true } },
  },
  v = {
    ["<C-S-k>"] = { ":m '<-2<CR>gv=gv", "move line up", opts = { nowait = true } },
    ["<C-S-j>"] = { ":m '>+1<CR>gv=gv", opts = { nowait = true } },
  },
}
-- map("n", "<A-j>", ":m .+1<CR>==") -- move line up(n)
-- map("n", "<A-k>", ":m .-2<CR>==") -- move line down(n)
-- map("v", "<A-j>", ":m '>+1<CR>gv=gv") -- move line up(v)
-- map("v", "<A-k>", ":m '<-2<CR>gv=gv") -- move line down(v)
-- Extras example
-- M.symbols_outline = {
--   n = {
--     ["<leader>cs"] = { "<cmd>SymbolsOutline<cr>", "Symbols Outline" },
--   },
-- }

-- more keybinds!

return M
