-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
--
--
-- vim.cmd[[hi NvimTreeNormal guibg=NONE ctermbg=NONE]]

-- vim.cmd("autocmd Colorscheme * highlight NvimTreeNormal guibg=none")
--
--
-- local function make_on_timer()
--   vim.cmd('make')
-- end
--
-- -- Start a timer that calls make_on_timer after 5000 milliseconds (5 seconds)
-- vim.loop.new_timer(50000, function()
--   make_on_timer()
-- end)
--
--
local uv = vim.loop

local make_default_error_cb = function(path, runnable)
	return function(error, _)
		error("fwatch.watch(" .. path .. ", " .. runnable .. ")" .. "encountered an error: " .. error)
	end
end

local function watch_with_function(path, on_event, on_error, opts)
	-- TODO: Check for 'fail'? What is 'fail' in the context of handle creation?
	--       Probably everything else is on fire anyway (or no inotify/etc?).
	local handle = uv.new_fs_event()

	-- these are just the default values
	local flags = {
		watch_entry = false, -- true = when dir, watch dir inode, not dir content
		stat = false, -- true = don't use inotify/kqueue but periodic check, not implemented
		recursive = false, -- true = watch dirs inside dirs
	}

	local unwatch_cb = function()
		uv.fs_event_stop(handle)
	end

	local event_cb = function(err, filename, events)
		if err then
			on_error(error, unwatch_cb)
		else
			on_event(filename, events, unwatch_cb)
		end
		if opts.is_oneshot then
			unwatch_cb()
		end
	end

	uv.fs_event_start(handle, path, flags, event_cb)

	return handle
end

local function watch_with_string(path, string, opts)
	local on_event = function(_, _)
		vim.schedule(function()
			vim.cmd(string)
		end)
	end
	local on_error = make_default_error_cb(path, string)
	return watch_with_function(path, on_event, on_error, opts)
end

local function do_watch(path, runnable, opts)
	if type(runnable) == "string" then
		return watch_with_string(path, runnable, opts)
	elseif type(runnable) == "table" then
		assert(runnable.on_event, "must provide on_event to watch")
		assert(type(runnable.on_event) == "function", "on_event must be a function")

		-- no on_error provided, make default
		if runnable.on_error == nil then
			table.on_error = make_default_error_cb(path, "on_event_cb")
		end

		return watch_with_function(path, runnable.on_event, runnable.on_error, opts)
	else
		error(
			"Unknown runnable type given to watch," .. " must be string or {on_event = function, on_error = function}."
		)
	end
end

local watch = function(path, vim_command_or_callback_table)
	return do_watch(path, vim_command_or_callback_table, {
		is_oneshot = false,
	})
end

local function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

if file_exists("./.nvimrc") then
	vim.cmd("source ./.nvimrc")
end
-- print("watching...")
watch("/home/urig/ws/fundguard/fgrepo/client/tsc.out", "silent make!")

vim.cmd("set rnu")
-- {
--   on_event = function()
--     print('a_file changed')
--   end
-- })
--
vim.cmd("au BufNewFile ~/vimwiki/diary/*.md :silent 0r !~/ws/scripts/diary-template.rs '%'")

vim.cmd("set spell")

vim.cmd("set wildignore+=**/node_modules/**,.git/**,**/dist/**,**/target/**")

vim.cmd("command! -nargs=1 Browse silent execute '!open' shellescape(<q-args>,1)")

-- let s:baleia = luaeval("require('baleia').setup { }")
-- command! BaleiaColorize call s:baleia.once(bufnr('%'));
-- " Autofix entire buffer with eslint_d:
-- nnoremap <leader>f mF:%!eslint_d --stdin --fix-to-stdout<CR>`F
-- " Autofix visual selection with eslint_d:
-- vnoremap <leader>f :!eslint_d --stdin --fix-to-stdout<CR>gv
--
vim.api.nvim_create_autocmd("FileType", {
	pattern = "sh",
	callback = function()
		vim.lsp.start({
			name = "bash-language-server",
			cmd = { "bash-language-server", "start" },
		})
	end,
})
