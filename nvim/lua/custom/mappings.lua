---@type MappingsTable
local M = {}

M.general = {
	n = {
		[";"] = { ":", "enter command mode", opts = { nowait = true } },
		["[f"] = { ":cne<cr>", "next quick fix", opts = { nowait = true } },
		["[F"] = { ":cprev<cr>", "previous quick fix", opts = { nowait = true } },
		["<leader>o"] = { ":%bd|e#<cr>", "close other buffers", opts = { nowait = true } },
		["<leader>h"] = { ":HopWord<cr>", "hop word", opts = { nowait = true } },
		["<leader>gm"] = { ":make<cr><cr>", "run make", opts = { nowait = true } },
		["<leader>wt"] = { "<cmd>TroubleToggle<cr>", "toggle truoble", opts = { silent = true, noremap = true } },
		-- ["<leader>do"] = { "<cmd>TroubleToggle quickfix<CR>", "show quickfix", opts = {silent = true, noremap = true} },

		["<leader>v"] = {
			":vimgrep /t\\.partial/g ./packages/libs/domain/src/**/*.ts<cr>",
			"find partials in domain",
			opts = { nowait = true },
		},
		-- vimgrep /t\.partial/g ./packages/libs/domain/src/**/*.ts
		["<leader>do"] = { ":copen<cr>", "show quickfix", opts = { silent = true, noremap = true } },
		["<leader>ww"] = { ":VimwikiMakeDiaryNote<cr>", "Vimwiki diary note", opts = { silent = true, noremap = true } },
		["<leader>wi"] = { ":VimwikiIndex<cr>", "Vimwiki diary note", opts = { silent = true, noremap = true } },

		["<leader>gd"] = {
			":Gvdiffsplit develop<cr>",
			"diff with develop (local)",
			opts = { silent = true, noremap = true },
		},
		["<leader>gh"] = { ":Gllog! -- %<cr>", "git log for current buffer", opts = { silent = true, noremap = true } },
		["<leader>go"] = { ":GBrowse<cr>", "GBrowse", opts = { silent = true, noremap = true } },
		-- vim.diagnostic.show()
		["<C-S-k>"] = { ":m .-2<cr>==", "move line up", opts = { nowait = true } },
		["<C-S-j>"] = { ":m .+1<cr>==", "move line down", opts = { nowait = true } },
		["<leader>,"] = { ":colder <cr>==", "older quickfix", opts = { nowait = true } },
		["<leader>."] = { ":cnewer <cr>==", "older quickfix", opts = { nowait = true } },
		["<leader>ff"] = {
			":lua vim.diagnostic.open_float()<CR>",
			"show_line_diagnostics",
			opts = { silent = true, noremap = true },
		},
		["<leader>fj"] = {
			":%!jq '.'<CR>",
			"Forman JSON",
			opts = { silent = true, noremap = true },
		},
		["<leader>db"] = {
			":lua require'dap'.toggle_breakpoint()<CR>",
			"Set break point",
			opts = { silent = true, noremap = true },
		},
		["<leader>dc"] = {
			":lua require'dap'.continue()<CR>",
			"Debug - continue",
			opts = { silent = true, noremap = true },
		},
	},
	v = {
		["<C-S-k>"] = { ":m '<-2<CR>gv=gv", "move line up", opts = { nowait = true } },
		["<C-S-j>"] = { ":m '>+1<CR>gv=gv", opts = { nowait = true } },
	},
	i = {
		["<C-J>"] = {
			'copilot#Accept("<CR>")',
			"Copilot accept",
			opts = { silent = true, expr = true },
		},
	},
}
-- '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
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
