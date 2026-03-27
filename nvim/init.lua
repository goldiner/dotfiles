-- always set leader first!
--
-- source .vimrc
local cwd = vim.fn.getcwd()
local file = io.open(cwd .. '/.nvimrc.lua', "r")
if file then
	file:close()
	-- require(cwd .. '/.nvimrc.lua')
	dofile(vim.fn.expand(cwd .. '/.nvimrc.lua'))
end
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })

vim.keymap.set('', '<S-Up>', '<NOP>', { noremap = true, silent = true })
vim.keymap.set('', '<S-Down>', '<NOP>', { noremap = true, silent = true })

vim.keymap.set('i', '<S-Up>', '<NOP>', { noremap = true, silent = true })
vim.keymap.set('i', '<S-Down>', '<NOP>', { noremap = true, silent = true })

vim.cmd('command! W w')

vim.g.mapleader = " "

-- For Visual Mode (v) - useful for fixing selected text
-- vim.keymap.set("v", "<leader>i", ":PrtRewrite FixAndExplain<CR>", { desc = "AI Fix Grammar" })
vim.keymap.set("v", "<leader>i", ":PrtRewrite Fix with explanation<CR>", { desc = "AI Fix Grammar" })

-- vim.o.focus = true
-------------------------------------------------------------------------------
--
-- preferences
--
-------------------------------------------------------------------------------
-- never ever folding
vim.opt.foldenable = false
vim.opt.foldmethod = 'manual'
vim.opt.foldlevelstart = 99
-- very basic "continue indent" mode (autoindent) is always on in neovim
-- could try smartindent/cindent, but meh.
-- vim.opt.cindent = true
-- XXX
-- vim.opt.cmdheight = 2
-- vim.opt.completeopt = 'menuone,noinsert,noselect'
-- not setting updatedtime because I use K to manually trigger hover effects
-- and lowering it also changes how frequently files are written to swap.
-- vim.opt.updatetime = 300
-- if key combos seem to be "lagging"
-- http://stackoverflow.com/questions/2158516/delay-before-o-opens-a-new-line
-- vim.opt.timeoutlen = 300
-- keep more context on screen while scrolling
vim.opt.scrolloff = 2
-- never show me line breaks if they're not there
vim.opt.wrap = false
-- always draw sign column. prevents buffer moving when adding/deleting sign
vim.opt.signcolumn = 'yes'
-- sweet sweet relative line numbers
vim.opt.relativenumber = true
-- and show the absolute line number for the current line
vim.opt.number = true
-- keep current content top + left when splitting
vim.opt.splitright = true
vim.opt.splitbelow = true
-- infinite undo!
-- NOTE: ends up in ~/.local/state/nvim/undo/
vim.opt.undofile = true
--" Decent wildmenu
-- in completion, when there is more than one match,
-- list all matches, and only complete to longest common match
vim.opt.wildmode = 'list:longest'
-- when opening a file with a command (like :e),
-- don't suggest files like there:
vim.opt.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'
-- tabs: go big or go home
vim.opt.shiftwidth = 8
vim.opt.softtabstop = 8
vim.opt.tabstop = 8
vim.opt.expandtab = false
-- case-insensitive search/replace
vim.opt.ignorecase = true
-- unless uppercase in search term
vim.opt.smartcase = true
-- never ever make my terminal beep
vim.opt.vb = true
-- more useful diffs (nvim -d)
--- by ignoring whitespace
vim.opt.diffopt:append('iwhite')
--- and using a smarter algorithm
--- https://vimways.org/2018/the-power-of-diff/
--- https://stackoverflow.com/questions/32365271/whats-the-difference-between-git-diff-patience-and-git-diff-histogram
--- https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
vim.opt.diffopt:append('algorithm:histogram')
vim.opt.diffopt:append('indent-heuristic')
-- show a column at 80 characters as a guide for long lines
-- vim.opt.colorcolumn = '80'
--- except in Rust where the rule is 100 characters
-- vim.api.nvim_create_autocmd('Filetype', { pattern = 'rust', command = 'set colorcolumn=100' })
-- show more hidden characters
-- also, show tabs nicer
vim.opt.listchars = 'tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•'

-------------------------------------------------------------------------------
--
-- hotkeys
--
-------------------------------------------------------------------------------
-- quick-open
-- vim.keymap.set('', '<C-p>', '<cmd>Files<cr>')
vim.keymap.set('n', '<leader>e', '<cmd>Files<cr>')
-- vim.keymap.set('n', '<leader>fw', '<cmd>Rg<cr>')
-- search buffers
vim.keymap.set('n', '<leader>;', '<cmd>Buffers<cr>')
-- quick-save
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>')

-- hop word
vim.keymap.set('n', '<leader>h', '<cmd>HopWord<cr>', { nowait = true })

-- comment
-- vim.keymap.set('n', '<leader>/', 'gcc')
-- make missing : less annoying
vim.keymap.set('n', ';', ':')

-- ["<C-h>"] = { "<C-w>h", "Window left" },
-- ["<C-l>"] = { "<C-w>l", "Window right" },
-- ["<C-j>"] = { "<C-w>j", "Window down" },
-- ["<C-k>"] = { "<C-w>k", "Window up" },

-- vim.keymap.set('n', '<C-h>', '<C-w>h')
-- vim.keymap.set('n', '<C-l>', '<C-w>l')
-- vim.keymap.set('n', '<C-j>', '<C-w>j')
-- vim.keymap.set('n', '<C-k>', '<C-w>k')


-- Toggle relative number
vim.keymap.set('n', '<leader>rn', '<cmd> set rnu! <CR>')

-- Ctrl+j and Ctrl+k as Esc
vim.keymap.set('n', '<C-j>', '<Esc>')
vim.keymap.set('i', '<C-j>', '<Esc>')
vim.keymap.set('v', '<C-j>', '<Esc>')
vim.keymap.set('s', '<C-j>', '<Esc>')
vim.keymap.set('x', '<C-j>', '<Esc>')
vim.keymap.set('c', '<C-j>', '<Esc>')
vim.keymap.set('o', '<C-j>', '<Esc>')
vim.keymap.set('l', '<C-j>', '<Esc>')
vim.keymap.set('t', '<C-j>', '<Esc>')
-- Ctrl-j is a little awkward unfortunately:
-- https://github.com/neovim/neovim/issues/5916
-- So we also map Ctrl+k
vim.keymap.set('n', '<C-k>', '<Esc>')
vim.keymap.set('i', '<C-k>', '<Esc>')
vim.keymap.set('v', '<C-k>', '<Esc>')
vim.keymap.set('s', '<C-k>', '<Esc>')
vim.keymap.set('x', '<C-k>', '<Esc>')
vim.keymap.set('c', '<C-k>', '<Esc>')
vim.keymap.set('o', '<C-k>', '<Esc>')
vim.keymap.set('l', '<C-k>', '<Esc>')
vim.keymap.set('t', '<C-k>', '<Esc>')


-- Ctrl+h to stop searching
vim.keymap.set('v', '<C-h>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<C-h>', '<cmd>nohlsearch<cr>')
-- Jump to start and end of line using the home row keys
vim.keymap.set('', 'H', '^')
vim.keymap.set('', 'L', '$')
-- Neat X clipboard integration
-- <leader>p will paste clipboard into buffer
-- <leader>c will copy entire buffer into clipboard
vim.keymap.set('n', '<leader>p', '<cmd>read !wl-paste<cr>')
vim.keymap.set('n', '<leader>c', '<cmd>w !wl-copy<cr><cr>')

-- Playwright test command copier
vim.keymap.set('n', '<leader>ww', function()
	local current_file = vim.fn.expand('%:p')
	local current_line = vim.fn.line('.')

	-- Check if we're in a Playwright test file
	if not string.match(current_file, '%.spec%.ts$') and not string.match(current_file, '%.test%.ts$') then
		vim.notify('Not in a Playwright test file', vim.log.levels.WARNING)
		return
	end

	-- Get the test name from the current line or nearby lines
	local test_name = nil
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

	-- Look for test() or it() calls around the current line
	for i = math.max(1, current_line - 10), math.min(#lines, current_line + 10) do
		local line = lines[i]
		if string.match(line, 'test%s*%(') or string.match(line, 'it%s*%(') then
			-- Extract test name from the line
			local test_match = string.match(line, 'test%s*%([^,]*["\']([^"\']*)["\']')
			if not test_match then
				test_match = string.match(line, 'it%s*%([^,]*["\']([^"\']*)["\']')
			end
			if test_match then
				test_name = test_match
				break
			end
		end
	end

	if not test_name then
		vim.notify('Could not find test name around current line', vim.log.levels.WARNING)
		return
	end

	-- Get relative path from the fundguard repo root
	local repo_root = '$FG_DIR'
	local relative_path = string.gsub(current_file, repo_root .. '/', '')

	-- Build the command to run in the playwright directory with trace enabled
	local playwright_dir = repo_root .. '/automation/packages/playwright'
	local cmd = string.format(
		'cd %s && TZ=America/Los_Angeles npx playwright test %s --grep "%s" --project=e2e --workers=1 --headed --debug',
		playwright_dir, relative_path, test_name)

	-- Copy the command to clipboard using wl-copy
	vim.fn.jobstart('echo ' .. vim.fn.shellescape(cmd) .. ' | wl-copy', { detach = true })

	vim.notify('Copied Playwright command to clipboard: ' .. test_name, vim.log.levels.INFO)
end, { desc = 'Copy current Playwright test command to clipboard' })

-- Command to manually open the most recent trace file
vim.keymap.set('n', '<leader>wo', function()
	local repo_root = '/home/uri/ws/fundguard/fgrepo'
	local playwright_dir = repo_root .. '/automation/packages/playwright'

	-- Find the most recent trace file
	local trace_cmd = string.format(
		'cd %s && find test-results -name "*.zip" -type f -printf "%%T@ %%p\\n" | sort -n | tail -1 | cut -d" " -f2-',
		playwright_dir)

	vim.fn.jobstart(trace_cmd, {
		on_exit = function(_, trace_exit_code, trace_output)
			if trace_exit_code == 0 and trace_output and #trace_output > 0 then
				local trace_file = trace_output[1]
				if trace_file and trace_file ~= "" then
					local full_trace_path = playwright_dir .. '/' .. trace_file
					local show_trace_cmd = string.format(
						'cd %s && PLAYWRIGHT_TRACE_VIEWER_HOST=127.0.0.1 npx playwright show-trace "%s"',
						playwright_dir, full_trace_path)
					vim.fn.jobstart(show_trace_cmd, { detach = true })
					vim.notify('Opening trace viewer: ' .. trace_file, vim.log.levels.INFO)
				else
					vim.notify('No trace file found', vim.log.levels.WARNING)
				end
			else
				vim.notify('No trace file found', vim.log.levels.WARNING)
			end
		end
	})
end, { desc = 'Open most recent Playwright trace file' })
-- <leader><leader> toggles between buffers
vim.keymap.set('n', '<leader><leader>', '<c-^>')
-- <leader>, shows/hides hidden characters
vim.keymap.set('n', '<leader>,', ':set invlist<cr>')
-- always center search results
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })
-- "very magic" (less escaping needed) regexes by default
vim.keymap.set('n', '?', '?\\v')
vim.keymap.set('n', '/', '/\\v')
vim.keymap.set('c', '%s/', '%sm/')
-- open new file adjacent to current file
vim.keymap.set('n', '<leader>o', ':e <C-R>=expand("%:p:h") . "/" <cr>')
-- no arrow keys --- force yourself to use the home row
vim.keymap.set('n', '<up>', '<nop>')
vim.keymap.set('n', '<down>', '<nop>')
vim.keymap.set('i', '<up>', '<nop>')
vim.keymap.set('i', '<down>', '<nop>')
vim.keymap.set('i', '<left>', '<nop>')
vim.keymap.set('i', '<right>', '<nop>')
-- let the left and right arrows be useful: they can switch buffers
vim.keymap.set('n', '<left>', ':bp<cr>')
vim.keymap.set('n', '<right>', ':bn<cr>')
-- make j and k move by visual line, not actual line, when text is soft-wrapped
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
-- handy keymap for replacing up to next _ (like in variable names)
--vim.keymap.set('n', '<leader>m', 'ct_')
-- F1 is pretty close to Esc, so you probably meant Esc
vim.keymap.set('', '<F1>', '<Esc>')
vim.keymap.set('i', '<F1>', '<Esc>')

-- --vimwiki
-- vim.keymap.set('n', '<leader>ww', '<cmd>VimwikiMakeDiaryNote<cr>')
-- vim.keymap.set('n', '<leader>wi', '<cmd>VimwikiIndex<cr>')

--git
-- ["<leader>gd"] = {
--   ":Gvdiffsplit develop<cr>",
--   "diff with develop (local)",
--   opts = { silent = true, noremap = true },
-- },
vim.keymap.set('n', '<leader>gd', ':Gvdiffsplit latest-stable<cr>', { silent = true, noremap = true })
vim.keymap.set('n', '<leader>gh', ':Gvdiffsplit HEAD<cr>', { silent = true, noremap = true })
-- ["<leader>ff"] = {
--   ":lua vim.diagnostic.open_float()<CR>",
--   "show_line_diagnostics",
--   opts = { silent = true, noremap = true },
-- },

vim.keymap.set('n', '<leader>ff', ':lua vim.diagnostic.open_float()<CR>', { silent = true, noremap = true })

--vimwiki
vim.g.vimwiki_list = {
	{
		path = "~/vimwiki",
		syntax = "markdown",
		ext = ".md",
	},
}
vim.g.vimwiki_ext2syntax = { [".md"] = "markdown", [".markdown"] = "markdown", [".mdown"] = "markdown" }

-------------------------------------------------------------------------------
--
-- autocommands
--
-------------------------------------------------------------------------------
local find_folder_with_file = function(filename, start_dir)
	local dir = start_dir
	while dir ~= nil do
		local file_path = dir .. "/" .. filename
		local is_readable = vim.loop.fs_access(file_path, "r")
		-- local file = io.open(file_path)
		if is_readable then
			-- file:close()
			return dir
		end
		local parent_dir = dir:match("^(.*)/[^/]*$")
		if parent_dir == dir then
			break
		end
		dir = parent_dir
	end
	return nil
end


vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "BufReadPost", "InsertLeave" },
	{ -- "BufEnter", "BufWritePost", "InsertLeave" }, { --BufWritePost
		pattern = { "*.js", "*.ts", "*.tsx", "*.jsx" },
		callback = function()
			--disable annoying autoindent
			vim.cmd([[set indentexpr=""]])
			require("lint").try_lint({ "eslint_d" },
				{
					cwd = find_folder_with_file("package.json", vim.fn.expand("%:p:h")),
				})
		end,
	})

vim.api.nvim_create_autocmd({ "BufEnter" },
	{
		pattern = { "*.js", "*.ts", "*.tsx", "*.jsx" },
		callback = function()
			--disable annoying autoindent
			vim.cmd([[set indentexpr=""]])
		end,
	})

-- highlight yanked text
vim.api.nvim_create_autocmd(
	'TextYankPost',
	{
		pattern = '*',
		command = 'silent! lua vim.highlight.on_yank({ timeout = 500 })'
	}
)


-- jump to last edit position on opening file
vim.api.nvim_create_autocmd(
	'BufReadPost',
	{
		pattern = '*',
		callback = function(ev)
			if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
				-- except for in git commit messages
				-- https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
				if not vim.fn.expand('%:p'):find('.git', 1, true) then
					vim.cmd('exe "normal! g\'\\""')
				end
			end
		end
	}
)

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = { "*.java" },
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.java",
	callback = function()
		local filepath = vim.api.nvim_buf_get_name(0)
		-- vim.system() works on next line too.
		-- os.execute("$HOME/ws/tools/fg-format-backend.sh '" .. filepath .. "' &")
		os.execute("$HOME/ws/tools/fg-format-backend.sh '" .. filepath .. "'")
		vim.cmd.edit()
	end
})

-- prevent accidental writes to buffers that shouldn't be edited
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.orig', command = 'set readonly' })
vim.api.nvim_create_autocmd('BufRead', { pattern = '*.pacnew', command = 'set readonly' })
-- leave paste mode when leaving insert mode (if it was on)
vim.api.nvim_create_autocmd('InsertLeave', { pattern = '*', command = 'set nopaste' })
-- help filetype detection (add as needed)
--vim.api.nvim_create_autocmd('BufRead', { pattern = '*.ext', command = 'set filetype=someft' })
-- correctly classify mutt buffers
local email = vim.api.nvim_create_augroup('email', { clear = true })
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
	pattern = '/tmp/mutt*',
	group = email,
	command = 'setfiletype mail',
})
-- also, produce "flowed text" wrapping
-- https://brianbuccola.com/line-breaks-in-mutt-and-vim/
vim.api.nvim_create_autocmd('Filetype', {
	pattern = 'mail',
	group = email,
	command = 'setlocal formatoptions+=w',
})
-- shorter columns in text because it reads better that way
local text = vim.api.nvim_create_augroup('text', { clear = true })
for _, pat in ipairs({ 'text', 'markdown', 'mail', 'gitcommit' }) do
	vim.api.nvim_create_autocmd('Filetype', {
		pattern = pat,
		group = text,
		command = 'setlocal spell tw=72 colorcolumn=73',
	})
end
--- tex has so much syntax that a little wider is ok
vim.api.nvim_create_autocmd('Filetype', {
	pattern = 'tex',
	group = text,
	command = 'setlocal spell tw=80 colorcolumn=81',
})
-- TODO: no autocomplete in text

-------------------------------------------------------------------------------
--
-- plugin configuration
--
-------------------------------------------------------------------------------
-- first, grab the manager
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- then, setup!
require("lazy").setup({
	-- main color scheme
	{
		"wincent/base16-nvim",
		lazy = false, -- load at start
		priority = 1000, -- load first
		config = function()
			vim.cmd([[colorscheme gruvbox-dark-hard]])
			vim.cmd([[set termguicolors]])

			-- make all ui parts transparent
			-- local groups = { -- table: default groups
			-- 	'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
			-- 	'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
			-- 	'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
			-- 	'SignColumn', 'CursorLine', 'CursorLineNr', -- 'StatusLine', 'StatusLineNC',
			-- 	'EndOfBuffer',
			-- }
			-- for _, area in ipairs(groups) do
			-- 	vim.cmd("hi! " .. area .. " ctermbg=NONE guibg=NONE")
			-- end a >= 1 != 2


			-- XXX: hi Normal ctermbg=NONE
			-- Make comments more prominent -- they are important.
			local bools = vim.api.nvim_get_hl(0, { name = 'Boolean' })
			vim.api.nvim_set_hl(0, 'Comment', bools)
			-- Make it clearly visible which argument we're at.
			local marked = vim.api.nvim_get_hl(0, { name = 'PMenu' })
			vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter',
				{ fg = marked.fg, bg = marked.bg, ctermfg = marked.ctermfg, ctermbg = marked.ctermbg, bold = true })
			-- XXX
			-- Would be nice to customize the highlighting of warnings and the like to make
			-- them less glaring. But alas
			-- https://github.com/nvim-lua/lsp_extensions.nvim/issues/21
			-- call Base16hi("CocHintSign", g:base16_gui03, "", g:base16_cterm03, "", "", "")
		end
	},

	-- nice bar at the bottom
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
	},
	-- {
	-- 	'itchyny/lightline.vim',
	-- 	lazy = false, -- also load at start since it's UI
	-- 	config = function()
	-- 		-- no need to also show mode in cmd line when we have bar
	-- 		vim.o.showmode = false
	-- 		vim.g.lightline = {
	-- 			-- pallete = {
	-- 			-- 	normal = {
	-- 			-- 		middle = {{ 'NONE', 'NONE', 'NONE', 'NONE' }}
	-- 			-- 	}
	-- 			-- },
	-- 			active = {
	-- 				left = {
	-- 					{ 'mode',     'paste' },
	-- 					{ 'readonly', 'filename', 'modified' }
	-- 				},
	-- 				right = {
	-- 					{ 'lineinfo' },
	-- 					{ 'percent' },
	-- 					{ 'fileencoding', 'filetype' }
	-- 				},
	-- 			},
	-- 			-- palette = {
	-- 			-- 	normal = {middle= { 'NONE', 'NONE', 'NONE', 'NONE' }}
	-- 			-- },
	-- 			component_function = {
	-- 				filename = 'LightlineFilename'
	-- 			},
	-- 		}
	-- 		function LightlineFilenameInLua(opts)
	-- 			if vim.fn.expand('%:t') == '' then
	-- 				return '[No Name]'
	-- 			else
	-- 				return vim.fn.getreg('%')
	-- 			end
	-- 		end
	--
	-- 		-- local palette = vim.g.lightline#colorscheme#{g:lightline.colorscheme}#palette
	--
	--
	-- 		-- https://github.com/itchyny/lightline.vim/issues/657
	-- 		vim.api.nvim_exec(
	-- 			[[
	-- 			function! g:LightlineFilename()
	-- 				return v:lua.LightlineFilenameInLua()
	-- 			endfunction
	-- 			]],
	-- 			true
	-- 		)
	-- 	end
	-- },
	-- quick navigation
	-- {
	-- 	'ggandor/leap.nvim',
	-- 	config = function()
	-- 		require('leap').create_default_mappings()
	-- 	end
	-- },
	-- better %
	{
		'andymass/vim-matchup',
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end
	},
	-- auto-cd to root of git project
	-- 'airblade/vim-rooter'
	'notjedi/nvim-rooter.lua',
	-- fzf support for ^p
	{
		'junegunn/fzf.vim',
		dependencies = {
			{ 'junegunn/fzf', dir = '~/.fzf', build = './install --all' },
		},
		config = function()
			-- stop putting a giant window over my editor
			-- vim.g.fzf_layout = { down = '~20%' }
			-- when using :Files, pass the file list through
			--
			--   https://github.com/jonhoo/proximity-sort
			--
			-- to prefer files closer to the current file.
			function list_cmd()
				local base = vim.fn.fnamemodify(vim.fn.expand('%'), ':h:.:S')
				if base == '.' then
					-- if there is no current file,
					-- proximity-sort can't do its thing
					return 'fd -HI -E=node_modules -E=dist -E=target -E=.git --type file --follow'
				else
					return vim.fn.printf(
						'fd -HI -E=node_modules -E=dist -E=target -E=.git --type file --follow | proximity-sort %s',
						vim.fn.shellescape(vim.fn.expand('%')))
				end
			end

			vim.api.nvim_create_user_command('Files', function(arg)
				vim.fn['fzf#vim#files'](arg.qargs, { source = list_cmd(), options = '--tiebreak=index' },
					arg.bang)
			end, { bang = true, nargs = '?', complete = "dir" })


			-- vim.api.nvim_create_user_command('FilesGrep', function(arg)
			-- 	vim.fn['fzf#vim#grep'](arg.qargs, { source = list_cmd(), options = '--tiebreak=index' },
			-- 		arg.bang)
			-- end, { bang = true, nargs = '?', complete = "dir" })


			-- vim.api.nvim_create_user_command(
			-- 	'FilesGrep',
			-- 	function(opts)
			-- 		local args = opts.args
			-- 		local bang = opts.bang and '!' or ''
			-- 		local fzf_args =
			-- 		"rg --column --line-number --no-heading --color=always --smart-case " ..
			-- 		vim.fn.shellescape(args)
			-- 		local fzf_options = "--delimiter : --nth 4.."
			-- 		vim.fn["fzf#vim#grep"](fzf_args, 1, { options = fzf_options }, bang)
			-- 	end,
			-- 	{ bang = true, nargs = '*' }
			-- )

			-- vim.api.nvim_create_user_command(
			-- 	'FilesGrep',
			-- 	function(opts)
			-- 		local args = opts.args
			-- 		local bang = opts.bang and 1 or 0
			-- 		local fzf_args =
			-- 		    "rg --column --line-number --no-heading --color=always --smart-case " ..
			-- 		    vim.fn.shellescape(args)
			-- 		local fzf_options = { options = "--delimiter : --nth 4.." }
			-- 		vim.fn["fzf#vim#grep"](fzf_args, bang, fzf_options, bang)
			-- 	end,
			-- 	{ bang = true, nargs = '*' }
			-- )

			-- command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
			-- vim.api.nvim_create_user_command('FilesCombo', function(arg)
			-- 	vim.fn['fzf#vim#ag'](arg.qargs, {  } , arg.bang)
			-- end, { bang = true, nargs = '?', complete = "dir" })

			-- fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
			-- command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
		end
	},
	-- LSP
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',
		},
		config = function()
			-- Setup Mason first
			require("mason").setup()

			-- Ensure packages are installed
			local mason_registry = require("mason-registry")

			-- 1. Refresh the registry to ensure we have the latest package list
			mason_registry.refresh(function()
				-- 2. Define your packages (Note: changed lombok-nightly to lombok)
			        -- removing for ctags
				local packages = {} -- "jdtls", "lombok-nightly" }

				for _, package_name in ipairs(packages) do
					-- 3. Use has_package to avoid crashing if a name is wrong
					if mason_registry.has_package(package_name) then
						local package = mason_registry.get_package(package_name)
						if not package:is_installed() then
							package:install()
						end
					else
						print("Mason: Package " .. package_name .. " not found in registry")
					end
				end
			end)

			-- local packages = { "jdtls", "lombok-nightly" }
			-- for _, package_name in ipairs(packages) do
			-- 	local package = mason_registry.get_package(package_name)
			-- 	if not package:is_installed() then
			-- 		package:install()
			-- 	end
			-- end

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = true,
			})

			-- Setup language servers.
			local lspconfig = require('lspconfig')


			local lspconfig = require 'lspconfig'


			local configs = require 'lspconfig.configs'

			-- if not configs.lsp_ai then
			-- 	configs.lsp_ai = {
			-- 		default_config = {
			-- 			cmd = { 'lsp-ai' },
			-- 			root_dir = lspconfig.util.root_pattern('.git'),
			-- 			filetypes = { 'ts', 'tsx', 'js', 'jsx', 'java', 'lua', 'python', 'sh' },
			-- 			init_options = {
			-- 				memory = {
			-- 					file_store = {}
			-- 				},
			-- 				models = {
			-- 					model1 = {
			-- 						type = "ollama",
			-- 						model = "deepseek-coder"
			-- 					}
			-- 				},
			-- 				completion = {
			-- 					model = "model1",
			-- 					parameters = {}
			-- 				},
			-- 				chat = {
			-- 					{
			-- 						trigger = "!C",
			-- 						action_display_name = "Chat",
			-- 						model = "model1",
			-- 						parameters = {
			-- 							max_context = 4096,
			-- 							max_tokens = 1024,
			-- 							system =
			-- 							"You are a code assistant chatbot. The user will ask you for assistance coding and you will do you best to answer succinctly and accurately"
			-- 						}
			-- 					},
			-- 					{
			-- 						trigger = "!CC",
			-- 						action_display_name = "Chat with context",
			-- 						model = "model1",
			-- 						parameters = {
			-- 							max_context = 4096,
			-- 							max_tokens = 1024,
			-- 							system =
			-- 							"You are a code assistant chatbot. The user will ask you for assistance coding and you will do you best to answer succinctly and accurately given the code context:\n\n{CONTEXT}"
			-- 						}
			-- 					}
			-- 				}
			-- 			}
			-- 		},
			-- 	}
			-- end
			--
			-- lspconfig.lsp_ai.setup {}





			-- Rust
			lspconfig.rust_analyzer.setup {
				-- Server-specific settings. See `:help lspconfig-setup`
				settings = {
					["rust-analyzer"] = {
						cargo = {
							allFeatures = true,
						},
						imports = {
							group = {
								enable = false,
							},
						},
						completion = {
							postfix = {
								enable = false,
							},
						},
					},
				},
			}


			-- TypeScript
			lspconfig.ts_ls.setup({})


			-- -- TypeScript Go - working part
			-- vim.lsp.config("ts_go_ls", {
			-- 	cmd = { vim.loop.os_homedir() .. "/ws/public/typescript-go/built/local/tsgo", "--lsp", "--stdio" }, --, "lsp", "-stdio" },
			-- 	filetypes = {
			-- 		"javascript",
			-- 		"javascriptreact",
			-- 		"javascript.jsx",
			-- 		"typescript",
			-- 		"typescriptreact",
			-- 		"typescript.tsx",
			-- 	},
			-- 	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
			-- })
			-- vim.lsp.enable("ts_go_ls")


			lspconfig.lua_ls.setup {
			}
			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			-- vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
			vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {







				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
					vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set('n', '<leader>wl', function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					--vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
					vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
					vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
					vim.keymap.set('n', '<leader>f', function()
						-- vim.lsp.buf.format { async = true }
						require("conform").format({ async = true, lsp_format = "fallback" })
					end, opts)

					local client = vim.lsp.get_client_by_id(ev.data.client_id)

					-- When https://neovim.io/doc/user/lsp.html#lsp-inlay_hint stabilizes
					-- *and* there's some way to make it only apply to the current line.
					-- if client.server_capabilities.inlayHintProvider then
					--     vim.lsp.inlay_hint(ev.buf, true)
					-- end

					-- None of this semantics tokens business.
					-- https://www.reddit.com/r/neovim/comments/143efmd/is_it_possible_to_disable_treesitter_completely/
					client.server_capabilities.semanticTokensProvider = nil
				end,
			})
		end
	},

	-- -- working but slow (maybe need a good GPU)
	-- {'tzachar/cmp-ai', dependencies = 'nvim-lua/plenary.nvim',
	-- lazy = false,
	-- config = function ()
	-- local cmp_ai = require('cmp_ai.config')
	--
	-- cmp_ai:setup({
	--   -- max_lines = 100,
	--   max_lines = 130,
	--   provider = 'Ollama',
	--   provider_options = {
	--     model = 'codellama:7b-code',
	--     -- model = 'deepseek-coder:1.3b-base-q5_0',
	--     -- model = 'deepseek-coder:6.7b-base-q5_0',
	--     -- model = k
	--     --
	--     -- model = 'deepseek-coder:33b-base-q5_0',
	--     -- model =
	--     -- model = 'codellama:13b-code',
	--     -- n_gpu_layers = 50,
	--     -- n_batch = 512,
	--     -- main_gpu = 1,
	--     -- model = 'mistral:7b-code',
	--     --
	--     -- model = d
	--   },
	--   notify = true,
	--   notify_callback = function(msg)
	--     vim.notify(msg)
	--   end,
	--   run_on_every_keystroke = true,
	--   ignored_file_types = {
	--     -- default is not to ignore
	--     -- uncomment to ignore in lua:
	--     -- lua = true
	--   },
	-- })
	--
	-- end,
	--
	--
	-- },
	--
	--
	-- {
	-- 	"huggingface/llm.nvim",
	-- 	backend = "ollama",
	-- 	config = function()
	-- 		local llm = require 'llm'
	-- 		llm.setup({
	-- 			enable_suggestions_on_files = {
	-- 				"*.*",
	-- 			},
	-- 			backend = "ollama",
	-- 			-- model = "starcoder",
	-- 			-- model = "codellama:7b",
	-- 			model = "codellama:13b",
	-- 			url = "http://127.0.0.1:11434/api/generate",
	-- 			lsp = {
	-- 				bin_path = vim.api.nvim_call_function("stdpath", { "data" }) ..
	-- 				"/mason/bin/llm-ls",
	-- 			},
	-- 			tokenizer = {
	-- 				repository = "bigcode/starcoder",
	-- 			},
	--
	-- 		})
	-- 	end
	-- },
	-- LSP-based code-completion
	{
		"hrsh7th/nvim-cmp",
		-- load cmp on InsertEnter
		event = "InsertEnter",
		-- these dependencies will only be loaded when cmp loads
		-- dependencies are always lazy-loaded unless specified otherwise
		dependencies = {
			"tzachar/cmp-ai",
			'neovim/nvim-lspconfig',
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require 'cmp'
			cmp.setup({
				completion = {
					keyword_length = 1,
					max_item_count = 5,
				},

				snippet = {
					-- REQUIRED by nvim-cmp. get rid of it once we can
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					-- Accept currently selected item.
					-- Set `select` to `false` to only confirm explicitly selected items.
					['<CR>'] = cmp.mapping.confirm({ select = true }),
					-- 	    ['<C-x>'] = cmp.mapping(
					--   cmp.mapping.complete({
					--     config = {
					--       sources = cmp.config.sources({
					--         { name = 'cmp_ai' },
					--       }),
					--     },
					--   }),
					--   { 'i' }
					-- ),
				}),

				sources = {
					{ name = 'nvim_lsp', keyword_length = 1, max_item_count = 5, },
					{ name = 'luasnip',  keyword_length = 1, max_item_count = 5, },
					{ name = 'buffer',   keyword_length = 1, max_item_count = 5, },
				},
				-- sources = cmp.config.sources({
				-- 	{ name = 'nvim_lsp' },
				-- },
				-- {
				-- 	{ name = 'path' },
				-- }),
				experimental = {
					ghost_text = true,
				},
			})

			-- Enable completing paths in :
			cmp.setup.cmdline(':', {
				sources = cmp.config.sources({
					{ name = 'path' }
				})
			})
		end
	},
	-- inline function signatures
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			-- Get signatures (and _only_ signatures) when in argument lists.
			require "lsp_signature".setup({
				doc_lines = 0,
				handler_opts = {
					border = "none"
				},
			})
		end
	},
	-- language support
	-- terraform
	{
		'hashivim/vim-terraform',
		ft = { "terraform" },
	},
	-- svelte
	{
		'evanleck/vim-svelte',
		ft = { "svelte" },
	},
	-- toml
	'cespare/vim-toml',
	-- yaml
	{
		"cuducos/yaml.nvim",
		ft = { "yaml" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},
	-- {
	--
	-- 	"nvim-treesitter/nvim-treesitter",
	-- 	opts = {
	-- 		ensure_installed = { "java" },
	-- 	}
	-- },
	-- rust
	{
		'rust-lang/rust.vim',
		ft = { "rust" },
		config = function()
			vim.g.rustfmt_autosave = 1
			vim.g.rustfmt_emit_files = 1
			vim.g.rustfmt_fail_silently = 0
			vim.g.rust_clip_command = 'wl-copy'
		end
	},
	-- -- typescript - experimental
	-- {
	-- 	"pmizio/typescript-tools.nvim",
	-- 	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	-- 	opts = {},
	-- },
	{
		"HerringtonDarkholme/yats.vim",
		config = function()
			-- vim.g.yats_filetypes = {
			--   "typescript",
			--   "typescriptreact",
			-- }
		end,
		opts = {},
	},
	-- java
	-- Removed in favor of ctags
	-- {
	-- 	'mfussenegger/nvim-jdtls',
	-- 	init = function()
	-- 		-- require('jdtls').setup()
	-- 		-- require('lspconfig').jdtls.setup({})
	-- 		-- end,
	-- 		-- config = function()
	-- 		local home = os.getenv 'HOME'
	-- 		local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
	-- 		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
	-- 		local workspace_dir = workspace_path .. project_name
	--
	-- 		local status, jdtls = pcall(require, 'jdtls')
	-- 		if not status then
	-- 			return
	-- 		end
	-- 		local extendedClientCapabilities = jdtls.extendedClientCapabilities
	--
	-- 		local config = {
	-- 			cmd = {
	-- 				'java',
	-- 				-- home .. '/.local/share/nvim/mason/bin/jdtls',
	-- 				'-Declipse.application=org.eclipse.jdt.ls.core.id1',
	-- 				'-Dosgi.bundles.defaultStartLevel=4',
	-- 				'-Declipse.product=org.eclipse.jdt.ls.core.product',
	-- 				'-Dlog.protocol=true',
	-- 				'-Dlog.level=ALL',
	-- 				'-Xms4g',
	-- 				'-Xmx20g',
	-- 				'--add-modules=ALL-SYSTEM',
	-- 				'--add-opens',
	-- 				'java.base/java.util=ALL-UNNAMED',
	-- 				'--add-opens',
	-- 				'java.base/java.lang=ALL-UNNAMED',
	-- 				'-javaagent:' ..
	-- 					home .. '/.local/share/nvim/mason/packages/lombok-nightly/lombok.jar',
	-- 				'-jar',
	-- 				vim.fn.glob(home ..
	-- 					'/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),
	-- 				'-configuration',
	-- 				home .. '/.local/share/nvim/mason/packages/jdtls/config_linux',
	-- 				'-data',
	-- 				workspace_dir,
	-- 			},
	-- 			-- root_dir = require('jdtls.setup').find_root { '.mvn', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },
	-- 			root_dir = function()
	-- 				return require('jdtls.setup').find_root { '.mvn' }
	-- 			end,
	-- 			require('jdtls.setup').find_root { '.mvn', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },
	--
	-- 			settings = {
	-- 				java = {
	-- 					signatureHelp = { enabled = true },
	-- 					extendedClientCapabilities = extendedClientCapabilities,
	-- 					maven = {
	-- 						downloadSources = true,
	-- 					},
	-- 					referencesCodeLens = {
	-- 						enabled = true,
	-- 					},
	-- 					references = {
	-- 						includeDecompiledSources = true,
	-- 					},
	-- 					inlayHints = {
	-- 						parameterNames = {
	-- 							enabled = 'all', -- literals, all, none
	-- 						},
	-- 					},
	-- 					format = {
	-- 						enabled = false,
	-- 					},
	-- 				},
	-- 			},
	--
	-- 			init_options = {
	-- 				bundles = {},
	-- 			},
	-- 			autostart = true,
	-- 		}
	-- 		-- require('jdtls').start_or_attach(config)
	-- 		require('lspconfig').jdtls.setup(config)
	-- 	end,
	-- },
	-- ctags for Java (needs `ctags` on PATH, e.g. `sudo pacman -S ctags` on Arch)
	{
		"ludovicchabant/vim-gutentags",
		event = { "BufReadPost", "BufWritePost" },
		init = function()
			-- Omit leaf pom.xml / build.gradle: each submodule would become its own root and
			-- tags would miss the rest of the tree (FundGuard backend uses backend/.mvn).
			vim.g.gutentags_project_root = {
				".git",
				".mvn",
				"settings.gradle",
				"settings.gradle.kts",
				"build.gradle",
				"build.gradle.kts",
				".project",
			}
			vim.g.gutentags_cache_dir = vim.fn.stdpath("cache") .. "/ctags"
			vim.g.gutentags_ctags_extra_args = {
				"--languages=Java",
				"--exclude=target",
				"--exclude=.gradle",
				"--exclude=build",
				"--exclude=out",
			}
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope-live-grep-args.nvim",
				"nvim-telescope/telescope-smart-history.nvim",
				"kkharji/sqlite.lua"
			},
		},
		opts = function(_, opts)
			opts.defaults = {
				vimgrep_arguments = {
					"nice", "-n", "10",
					"rg",
					"--threads", "2",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
				},
				history = {
					path = vim.fn.stdpath("data") .. "/telescope_history.sqlite3",
					limit = 100,
				},
				mappings = {
					i = {
						["<C-p>"] = require("telescope.actions").cycle_history_prev,
						["<C-n>"] = require("telescope.actions").cycle_history_next,
						["<C-k>"] = require("telescope.actions").cycle_history_prev,
						["<C-j>"] = require("telescope.actions").cycle_history_next,
					},
				},
			}
			local lga_actions = require("telescope-live-grep-args.actions")
			opts.extensions = {
				live_grep_args = {
					file_ignore_patterns = {
						"%.git/",
						"node_modules/",
						"%.lock",
						"build/",
						"dist/",
						"%.class$", -- compiled Java class files
						"target/", -- Maven or other build output
						"%.jar$", -- Java archives
						"%.war$", -- Web archives
						"%.ear$", -- Enterprise archives
						"%.iml$", -- IntelliJ project files
						"%.project$", -- Eclipse project files
						"%.settings/", -- Eclipse settings
					},
					default_text = "--glob='**' ",
					auto_quoting = true, -- enable/disable auto-quoting
					-- define mappings, e.g.
					-- mappings = { -- extend mappings
					-- 	i = {
					-- 		["<C-k>"] = lga_actions.quote_prompt(),
					-- 		["<C-i>"] = lga_actions.quote_prompt({
					-- 			postfix =
					-- 			" --iglob "
					-- 		}),
					-- 	},
					-- },
					-- ... also accepts theme settings, for example:
					-- theme = "dropdown", -- use dropdown theme
					-- theme = { }, -- use own theme spec
					-- layout_config = { mirror=true }, -- mirror preview pane
				},
			}
		end,
		keys = {
			{
				"<leader>/",
				"<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
				desc = "Grep (root dir)",
			},
			{
				"<leader>fw",
				"<cmd>lua require('zoekt-enhanced').smart_search()<CR>",
				desc = "Smart Grep (Zoekt or Telescope)",
			},
			{
				"<leader>jt",
				"<cmd>lua require('telescope.builtin').tags()<CR>",
				desc = "Tags (ctags / gutentags)",
			},

		},
		config = function(_, opts)
			local tele = require("telescope")
			tele.setup(opts)
			tele.load_extension("live_grep_args")
			tele.load_extension("smart_history")
		end,
	},
	-- {
	-- 	'nvim-java/nvim-java',
	-- 	init = function()
	-- 		require('java').setup()
	-- 		require('lspconfig').jdtls.setup({})
	-- 	end,
	-- 	dependencies = {
	-- 		'nvim-java/lua-async-await',
	-- 		'nvim-java/nvim-java-refactor',
	-- 		'nvim-java/nvim-java-core',
	-- 		'nvim-java/nvim-java-test',
	-- 		'nvim-java/nvim-java-dap',
	-- 		'MunifTanjim/nui.nvim',
	-- 		'neovim/nvim-lspconfig',
	-- 		'mfussenegger/nvim-dap',
	-- 		{
	-- 			'williamboman/mason.nvim',
	-- 			opts = {
	-- 				registries = {
	-- 					'github:nvim-java/mason-registry',
	-- 					'github:mason-org/mason-registry',
	-- 				},
	-- 			},
	-- 		}
	-- 	},
	-- },
	-- git integration
	{
		"tpope/vim-fugitive",
		cmd = "Git",
		lazy = false,
	},
	-- git stuff
	{
		"lewis6991/gitsigns.nvim",
		ft = { "gitcommit", "diff" },
		init = function()
			-- load gitsigns only when a git file is opened
			vim.api.nvim_create_autocmd({ "BufRead" }, {
				group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
				callback = function()
					vim.fn.jobstart({ "git", "-C", vim.loop.cwd(), "rev-parse" },
						{
							on_exit = function(_, return_code)
								if return_code == 0 then
									vim.api.nvim_del_augroup_by_name "GitSignsLazyLoad"
									vim.schedule(function()
										require("lazy").load { plugins = { "gitsigns.nvim" } }
									end)
								end
							end
						}
					)
				end,
			})
		end,
		-- opts = function()
		-- 	return require("plugins.configs.others").gitsigns
		-- end,
		config = function(_, opts)
			-- dofile(vim.g.base46_cache .. "git")
			require("gitsigns").setup(opts)
		end,
	},

	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					typescript = { "eslint_d" },
					typescriptreact = { 'eslint_d', },
					javascript = { 'eslint_d', },
					javascriptreact = { 'eslint_d', },
				},
				-- format_on_save = function(bufnr)
				-- 	return {
				-- 	cwd = function()
				-- 		return find_folder_with_file("package.json",
				-- 			vim.fn.expand("%:p:h"))
				-- 	end,
				-- 	-- These options will be passed to conform.format()
				-- 	timeout_ms = 60000,
				-- 	async = true,
				-- 	-- lsp_fallback = true,
				-- 	lsp_format = "fallback",
				-- }
				-- end,
			})
			vim.lsp.buf.format({
				filter = function(client)
					return client.name ~= "tsserver"
					-- if client.name == "tsserver" then
					-- 	client.server_capabilities.documentFormattingProvider = false
					-- 	client.server_capabilities.documentRangeFormattingProvider = false
					-- 	return false
					-- end
					-- return true
				end
			})
		end
	},

	{
		"mfussenegger/nvim-lint",
		lazy = false,
		opts = {
			-- other config
			linters = {
				eslint_d = {
					args = {
						'--no-warn-ignored', -- <-- this is the key argument
						'--format',
						'json',
						'--stdin',
						'--stdin-filename',
						function()
							return vim.api.nvim_buf_get_name(0)
						end,
					},
				},
			},
		},
		config = function()
			require('lint').linters_by_ft = {
				typescript = { 'eslint_d', },
				typescriptreact = { 'eslint_d', },
				javascript = { 'eslint_d', },
				javascriptreact = { 'eslint_d', },
			}

			vim.opt.formatoptions:remove("g")
			vim.opt.formatoptions:remove("q")
			vim.opt.formatoptions:remove("r")
			vim.opt.formatoptions:remove("o")

			-- autowrap
			vim.opt.formatoptions:remove("t")
		end
	},

	-- fish
	'khaveesh/vim-fish-syntax',
	-- markdown
	{
		'plasticboy/vim-markdown',
		ft = { "markdown" },
		dependencies = {
			'godlygeek/tabular',
		},
		config = function()
			-- never ever fold!
			vim.g.vim_markdown_folding_disabled = 1
			-- support front-matter in .md files
			vim.g.vim_markdown_frontmatter = 1
			-- 'o' on a list item should insert at same level
			vim.g.vim_markdown_new_list_item_indent = 0
			-- don't add bullets when wrapping:
			-- https://github.com/preservim/vim-markdown/issues/232
			vim.g.vim_markdown_auto_insert_bullets = 0
		end
	},
	-- {
	-- 	"github/copilot.vim",
	-- 	lazy = false,
	-- 	-- ft = { "0" },
	-- },
	-- {
	-- 	"Exafunction/codeium.vim",
	-- 	lazy = false,
	-- },
	-- {
	--     "dleemiller/nopilot.nvim",
	--     lazy = false,
	--     opts = {
	--         backend = {
	--             display_name = "Ollama etc.",
	--             name = "ollama",
	--             config = {
	--                 host = "localhost",
	--                 port = "11434",
	--                 model = "mistral",
	--                 -- Other configurations...
	--             }
	--         },
	--          -- Other options...
	--     }
	-- },
	--
	--
	-- {
	-- 	"nomnivore/ollama.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- 	-- All the user commands added by the plugin
	-- 	cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
	-- 	keys = {
	-- 		-- Sample keybind for prompt menu.
	-- 		-- Note that the <c-u> is important for selections
	-- 		-- to work properly.
	-- 		{
	-- 			"<leader>oo",
	-- 			":<c-u>lua require('ollama').prompt()<cr>",
	-- 			desc = "ollama prompt",
	-- 			mode = { "n", "v" },
	-- 		},
	-- 		-- Sample keybind for direct prompting.
	-- 		-- Note that the <c-u> is important for selections
	-- 		-- to work properly.
	-- 		{
	-- 			"<leader>oG",
	-- 			":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
	-- 			desc = "ollama Generate Code",
	-- 			mode = { "n", "v" },
	-- 		},
	-- 	},
	--
	--
	-- 	---@type Ollama.Config
	-- 	opts = {
	-- 		model = "codellama:7b",
	-- 		url = "http://127.0.0.1:11434",
	-- 	},
	-- },





	{
		"vimwiki/vimwiki",
		lazy = false,
		config = function()
			--
			-- require("vimwiki").setup() {}
			-- vim.g.vimwiki_list = {
			--   {
			--     path = '/home/urig/vimwiki',
			--     syntax = 'markdown',
			--     ext = '.md',
			--   }
			-- }
			-- }
		end,
		-- cmd = "Wiki"
	},
	-- easy commenting
	{
		"numToStr/Comment.nvim",
		config = function(_, opts)
			require("Comment").setup(opts)
		end,
	},
	{
		"lambdalisue/suda.vim",
		lazy = false,
	},
	{
		"tpope/vim-surround",
		lazy = false,
	},
	{
		"phaazon/hop.nvim",
		lazy = false,
		config = function()
			require("hop").setup()
		end,
	},

	{
		'williamboman/mason.nvim',
		opts = {
			registries = {
				'github:nvim-java/mason-registry',
				'github:mason-org/mason-registry',
			},
		},
	},
	{
		'williamboman/mason-lspconfig.nvim',
		dependencies = {
			'williamboman/mason.nvim',
		},
		opts = {
			ensure_installed = {
				"ts_ls", -- TypeScript language server
				"lua_ls", -- Lua language server
				"rust_analyzer", -- Rust analyzer
			},
			automatic_installation = true,
		},
	},
	{
		'mikelue/vim-maven-plugin'
	},
	{
		"chentoast/marks.nvim",
		event = "VeryLazy",
		opts = {},
	},
	-- {
	-- 	"yetone/avante.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"MunifTanjim/nui.nvim",
	-- 	},
	-- 	opts = {
	-- 		-- Set your default provider to 'gemini'
	-- 		provider = "ollama",
	--
	--
	-- 		auto_suggestions_provider = "ollama_autocomplete",
	-- 		providers = {
	-- 			ollama = {
	-- 				-- This name can be anything
	-- 				__inherited_from = "openai",
	-- 				-- The endpoint for the local Ollama server
	-- 				endpoint = "http://localhost:11434/v1/",
	-- 				-- IMPORTANT: The model name must match what you pulled with Ollama
	-- 				-- model = "mixtral",
	-- 				-- model = "llama3:8b",
	-- 				-- model = "command-r",
	-- 				model = "qwq:32b",
	-- 				disable_tools = true, -- disable tools!
	-- 				-- model = "deepseek-coder:33b",
	-- 				-- Or use the bigger model you pulled:
	-- 				-- model = "mixtral",
	-- 			},
	--
	--
	--
	--
	-- 			ollama_autocomplete = {
	-- 				-- This name can be anything
	-- 				__inherited_from = "ollama",
	-- 				-- The endpoint for the local Ollama server
	-- 				endpoint = "http://localhost:11434/v1/",
	-- 				-- IMPORTANT: The model name must match what you pulled with Ollama
	-- 				-- model = "mixtral",
	-- 				-- model = "llama3:8b",
	-- 				model = "deepseek-coder:6.7b",
	-- 				disable_tools = true, -- disable tools!
	-- 				-- model = "deepseek-coder:33b",
	-- 				-- Or use the bigger model you pulled:
	-- 				-- model = "mixtral",
	-- 			},
	-- 			gemini = {
	-- 				-- Inherit the settings from the built-in 'openai' provider
	-- 				__inherited_from = "openai",
	-- 				-- Specify the name of the environment variable for the API key
	-- 				api_key_name = "GEMINI_API_KEY",
	-- 				-- Set the Gemini API endpoint
	-- 				endpoint = "https://generativelanguage.googleapis.com/v1beta/openai/",
	-- 				-- Choose the Gemini model you wish to use
	-- 				-- model = "gemini-1.5-flash",
	-- 				model = "gemini-1.5-flash",
	-- 				-- Optional: Set a timeout in milliseconds
	-- 				timeout = 15000,
	-- 			},
	-- 		},
	-- 		-- behaviour = {
	-- 		-- 	auto_focus_sidebar = true,
	-- 		-- 	auto_suggestions = false, -- Experimental stage
	-- 		-- 	auto_suggestions_respect_ignore = false,
	-- 		-- 	auto_set_highlight_group = true,
	-- 		-- 	auto_set_keymaps = true,
	-- 		-- 	auto_apply_diff_after_generation = false,
	-- 		-- 	jump_result_buffer_on_finish = true,
	-- 		-- 	support_paste_from_clipboard = false,
	-- 		-- 	minimize_diff = true,
	-- 		-- 	enable_token_counting = false,
	-- 		-- 	enable_cursor_planning_mode = false,
	-- 		-- 	enable_claude_text_editor_tool_mode = false,
	-- 		-- 	use_cwd_as_project_root = false,
	-- 		-- },
	-- 		-- tools = {
	-- 		-- 	web_search_engine = {
	-- 		-- 		-- name = "tavily",
	-- 		-- 		name = "duckduckgo",
	-- 		-- 		-- GOOGLE_SEARCH_API_KEY = "AIzaSyC-lJ2Z2sBGC4SWl54Rn1CBpY6_ho7fO3w",
	-- 		-- 		-- GOOGLE_SEARCH_ENGINE_ID = "761011f79dfd9499c"
	-- 		-- 	},
	-- 		-- },
	-- 		rag_service = {       -- RAG Service configuration
	-- 			enabled = true, -- Enables the RAG service
	-- 			host_mount = "/home/uri/ws/fundguard/fgrepo",-- os.getenv("HOME"), -- Host mount path for the rag service (Docker will mount this path)
	-- 			runner = "docker", -- Runner for the RAG service (can use docker or nix)
	-- 			llm = {       -- Language Model (LLM) configuration for RAG service
	-- 				provider = "ollama", -- LLM provider
	-- 				endpoint = "http://localhost:11434/v1/", -- LLM API endpoint
	-- 				-- api_key = "OPENAI_API_KEY", -- Environment variable name for the LLM API key
	-- 				model = "qwq:32b",
	-- 				-- model = "gpt-4o-mini", -- LLM model name
	-- 				extra = nil, -- Additional configuration options for LLM
	-- 			},
	-- 			embed = {     -- Embedding model configuration for RAG service
	-- 				provider = "ollama", -- Embedding provider
	-- 				endpoint = "http://localhost:11434/v1/", -- Embedding API endpoint
	-- 				-- api_key = "OPENAI_API_KEY", -- Environment variable name for the embedding API key
	-- 				-- model = "text-embedding-3-large", -- Embedding model name
	-- 				model = "qwq:32b",
	-- 				extra = nil, -- Additional configuration options for the embedding model
	-- 			},
	-- 			docker_extra_args = "", -- Extra arguments to pass to the docker command
	-- 		},
	-- 	},
	-- },
	-- Custom configuration (defaults shown)
	-- {
	-- 	'jacob411/Ollama-Copilot',
	-- 	opts = {
	-- 		model_name = "deepseek-coder:base",
	-- 		ollama_url = "http://localhost:11434", -- URL for Ollama server, Leave blank to use default local instance.
	-- 		stream_suggestion = false,
	-- 		python_command = "python3",
	-- 		filetypes = { 'python', 'lua', 'vim', "markdown" },
	-- 		ollama_model_opts = {
	-- 			num_predict = 40,
	-- 			temperature = 0.1,
	-- 		},
	-- 		keymaps = {
	-- 			suggestion = '<leader>os',
	-- 			reject = '<leader>or',
	-- 			insert_accept = '<Tab>',
	-- 		},
	--
	-- 	}
	-- },
	{
		"frankroeder/parrot.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("parrot").setup({
				providers = {
					-- Use 'groq' as the key directly
					groq = {
						name = "groq",
						api_key = os.getenv("GROQ_API_KEY"),
						endpoint = "https://api.groq.com/openai/v1/chat/completions",
						topic_model = "llama-3.3-70b-versatile",
						models = { "llama-3.3-70b-versatile" },
					},
				},
				-- 				hooks = {
				--   FixAndExplain = function(parrot, params)
				--     local template = [[
				--       You are a professional editor. Please process the text below.
				--
				--       ### INSTRUCTIONS:
				--       1. Fix all grammar, spelling, and punctuation errors.
				--       2. Immediately after the fix, add a line that says "---".
				--       3. Below that line, write a short "Change Log" as a code comment.
				--
				--       ### FORMAT TO FOLLOW:
				--       [Fixed version of the text]
				--       ---
				--       # EXPLANATION:
				--       # - Fixed [specific error]
				--       # - Improved [specific word]
				--
				--       ### TEXT TO PROCESS:
				--       {{selection}}
				--     ]]
				--     local model_obj = parrot.get_model("groq")
				--     parrot.Rewrite(params, model_obj, template)
				--   end,
				-- }
			})
		end,
	},

})

-- Enhanced zoekt commands
vim.api.nvim_create_user_command("ZoektSearch", function()
	require("zoekt-enhanced").zoekt_search()
end, {})

vim.api.nvim_create_user_command("ZoektIndex", function()
	require("zoekt-enhanced").force_index()
end, {})

vim.api.nvim_create_user_command("ZoektStatus", function()
	require("zoekt-enhanced").status()
end, {})

vim.api.nvim_create_user_command("ZoektStartServer", function()
	require("zoekt-enhanced").start_server()
end, {})

vim.api.nvim_create_user_command("AzureSearch", function()
	require("tele-azure").search_devops()
end, {})

-- Initialize enhanced zoekt on startup
require("zoekt-enhanced").init_zoekt()

-- command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
--[[

leftover things from init.vim that i may still end up wanting

" Completion
" Better completion
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Settings needed for .lvimrc
set exrc
set secure

" Wrapping options
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines

" <leader>s for Rg search
noremap <leader>s :Rg
let g:fzf_layout = { 'down': '~20%' }
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
\   <bang>0 ? fzf#vim#with_preview('up:60%')
\           : fzf#vim#with_preview('right:50%:hidden', '?'),
\   <bang>0)
" <leader>q shows stats
nnoremap <leader>q g<c-g>

--]]
--
--
--
--
--
--
--
--
