local M = {}

-- Global variable to store the zoekt server port for this nvim session
local zoekt_server_port = nil

-- Helper function to find a free port
local function find_free_port()
	-- Try ports starting from 6070, but find one that's actually free
	for port = 6070, 6200 do
		local handle = io.popen(string.format("netstat -ln 2>/dev/null | grep ':%d '", port))
		local result = handle:read("*a")
		handle:close()
		
		if result == "" then  -- Port is free
			return port
		end
	end
	
	-- Fallback to default if we can't find anything
	return 6070
end

-- Helper function to get the zoekt server port (find once, reuse for session)
local function get_zoekt_port()
	if not zoekt_server_port then
		zoekt_server_port = find_free_port()
		-- vim.notify(string.format("Using zoekt port %d for this session", zoekt_server_port), vim.log.levels.INFO)
	end
	return zoekt_server_port
end

-- Function to get the current zoekt port (for use by other modules)
function M.get_port()
	return get_zoekt_port()
end

-- Function to reset server status when connection fails
function M.reset_server_status()
	server_started = false
end

-- Helper function to check if we're in a git repository
local function is_git_repo()
	local git_dir = vim.fn.system("git rev-parse --git-dir 2>/dev/null"):gsub("%s+", "")
	return vim.v.shell_error == 0 and git_dir ~= ""
end

-- Helper function to get git root directory
local function get_git_root()
	if not is_git_repo() then
		return nil
	end
	local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("%s+", "")
	if vim.v.shell_error == 0 then
		return git_root
	end
	return nil
end

-- Helper function to get parent directory of git root
local function get_parent_dir()
	local git_root = get_git_root()
	if not git_root then
		return nil
	end
	return vim.fn.fnamemodify(git_root, ":h")
end

-- Helper function to check if .zoektrc exists in parent directory
local function find_zoektrc()
	local parent_dir = get_parent_dir()
	if not parent_dir then
		return nil
	end
	
	local zoektrc_path = parent_dir .. "/.zoektrc"
	if vim.fn.filereadable(zoektrc_path) == 1 then
		return zoektrc_path, parent_dir
	end
	return nil
end

-- Helper function to get current git hash
local function get_current_git_hash()
	if not is_git_repo() then
		return nil
	end
	local hash = vim.fn.system("git rev-parse HEAD 2>/dev/null")
	if vim.v.shell_error == 0 then
		return vim.trim(hash)
	end
	return nil
end

-- Helper function to read zoekt status file
local function read_zoekt_status(parent_dir)
	local status_file = parent_dir .. "/.zoektstatus"
	if vim.fn.filereadable(status_file) == 1 then
		local content = vim.fn.readfile(status_file)
		if #content > 0 then
			-- Trim all whitespace including newlines
			return vim.trim(content[1])
		end
	end
	return nil
end

-- Helper function to write zoekt status file
local function write_zoekt_status(parent_dir, hash)
	local status_file = parent_dir .. "/.zoektstatus"
	-- Write without extra newlines
	vim.fn.writefile({vim.trim(hash)}, status_file, "b")
end

-- Helper function to restart zoekt webserver
local function restart_zoekt_server(index_dir)
	local port = get_zoekt_port()
	vim.notify(string.format("Restarting zoekt-webserver on port %d...", port), vim.log.levels.INFO)
	
	-- First, try to kill existing zoekt-webserver processes for this port
	local kill_cmd = string.format("pkill -f 'zoekt-webserver.*:%d'", port)
	vim.fn.jobstart(kill_cmd, {
		on_exit = function(_, _)
			-- Start new zoekt-webserver on the dynamic port
			local server_cmd = string.format("zoekt-webserver -listen :%d -index %s", port, vim.fn.shellescape(index_dir))
			vim.fn.jobstart(server_cmd, {
				detach = true,  -- Run in background
				on_exit = function(_, server_exit_code)
					if server_exit_code == 0 then
						vim.notify("Zoekt webserver started successfully", vim.log.levels.INFO)
					else
						vim.notify("Zoekt webserver exited with code: " .. server_exit_code, vim.log.levels.WARN)
					end
				end,
				on_stderr = function(_, data)
					-- Suppress INFO logs, only show actual errors
					if data and #data > 0 then
						for _, line in ipairs(data) do
							if line and line ~= "" and not line:match("%[INFO%]") then
								vim.notify("Zoekt server error: " .. line, vim.log.levels.ERROR)
							end
						end
					end
				end
			})
		end
	})
end

-- Helper function to run zoekt indexing
local function run_zoekt_index(parent_dir)
	local git_root = get_git_root()
	if not git_root then
		vim.notify("Not in a git repository", vim.log.levels.ERROR)
		return false
	end
	
	local index_dir = parent_dir .. "/.zoektindex"
	
	-- Create index directory if it doesn't exist
	vim.fn.mkdir(index_dir, "p")
	
	-- vim.notify("Starting zoekt indexing...", vim.log.levels.INFO)
	
	-- Run zoekt-index in the background
	local cmd = string.format("zoekt-index -index %s -ignore_dirs='.git,.hg,.svn,node_modules,dist,out,build,target,.gradle,.idea,.next,coverage,generated' -disable_ctags -parallelism 20 %s", 
		vim.fn.shellescape(index_dir),
		vim.fn.shellescape(git_root))
	
	vim.fn.jobstart(cmd, {
		on_exit = function(_, exit_code)
			if exit_code == 0 then
				local current_hash = get_current_git_hash()
				if current_hash then
					write_zoekt_status(parent_dir, current_hash)
					vim.notify("Zoekt indexing completed successfully", vim.log.levels.INFO)
					
					-- Start/restart zoekt-webserver
					restart_zoekt_server(index_dir)
				else
					vim.notify("Zoekt indexing completed but couldn't get git hash", vim.log.levels.WARN)
				end
			else
				vim.notify("Zoekt indexing failed with exit code: " .. exit_code, vim.log.levels.ERROR)
			end
		end,
		on_stderr = function(_, data)
			if data and #data > 0 then
				for _, line in ipairs(data) do
					if line and line ~= "" then
						-- vim.notify("Zoekt index error: " .. line, vim.log.levels.ERROR)
						-- print("Zoekt index error: " .. line)
					end
				end
			end
		end
	})
	
	return true
end

-- Synchronous version of zoekt indexing with callback
local function run_zoekt_index_sync(parent_dir, callback)
	local git_root = get_git_root()
	if not git_root then
		vim.notify("Not in a git repository", vim.log.levels.ERROR)
		return false
	end
	
	local index_dir = parent_dir .. "/.zoektindex"
	
	-- Create index directory if it doesn't exist
	vim.fn.mkdir(index_dir, "p")
	
	vim.notify("Starting zoekt indexing...", vim.log.levels.INFO)
	
	-- Run zoekt-index and wait for completion
	local cmd = string.format("zoekt-index -index %s -ignore_dirs='.git,.hg,.svn,node_modules,dist,out,build,target,.gradle,.idea,.next,coverage,generated' -disable_ctags -parallelism 20 %s", 
		vim.fn.shellescape(index_dir),
		vim.fn.shellescape(git_root))
	
	vim.fn.jobstart(cmd, {
		on_exit = function(_, exit_code)
			if exit_code == 0 then
				local current_hash = get_current_git_hash()
				if current_hash then
					write_zoekt_status(parent_dir, current_hash)
					vim.notify("Zoekt indexing completed successfully", vim.log.levels.INFO)
				else
					vim.notify("Zoekt indexing completed but couldn't get git hash", vim.log.levels.WARN)
				end
				-- Call the callback function to proceed
				if callback then
					callback()
				end
			else
				vim.notify("Zoekt indexing failed with exit code: " .. exit_code, vim.log.levels.ERROR)
			end
		end,
		on_stderr = function(_, data)
			if data and #data > 0 then
				for _, line in ipairs(data) do
					if line and line ~= "" then
						vim.notify("Zoekt: " .. line, vim.log.levels.INFO)
						-- print(line)
					end
				end
			end
		end
	})
	
	return true
end

-- Global variable to track if server is running for this session
local server_started = false

-- Function to test if server is actually responding
local function test_server_connection(port)
	-- First check if anything is listening on the port using ss or lsof
	local port_check = io.popen(string.format("ss -ln 2>/dev/null | grep ':%d ' || lsof -i :%d 2>/dev/null | grep LISTEN", port, port))
	local port_result = port_check:read("*a")
	port_check:close()
	
	if port_result == "" then
		return false
	end
	
	-- Port is listening, now test HTTP response
	local test_url = string.format("http://localhost:%d/search?q=test&num=1&format=json", port)
	local handle = io.popen(string.format("curl -s --connect-timeout 1 --max-time 2 %s >/dev/null 2>&1; echo $?", test_url))
	local exit_code = handle:read("*a"):gsub("%s+", "")
	handle:close()
	local is_responding = exit_code == "0"
	return is_responding
end

-- Function to wait for server to be ready with polling
local function wait_for_server_ready(port, callback, max_attempts)
	max_attempts = max_attempts or 15  -- Max 15 attempts (up to 7.5 seconds)
	local attempt = 0
	
	local function check_server()
		attempt = attempt + 1
		
		if test_server_connection(port) then
			-- Server is ready, call the callback
			callback()
		elseif attempt >= max_attempts then
			-- Timeout, give up and call callback anyway
			vim.notify("Server startup timeout, proceeding anyway", vim.log.levels.WARN)
			callback()
		else
			-- Try again in 500ms
			vim.defer_fn(check_server, 500)
		end
	end
	
	-- Start checking after a brief initial delay
	vim.defer_fn(check_server, 200)
end

-- Function to start server and then open search
local function start_server_and_search(index_dir)
	local port = get_zoekt_port()
	-- vim.notify(string.format("Starting zoekt server on port %d...", port), vim.log.levels.INFO)
	
	-- Kill existing server first
	local kill_cmd = string.format("pkill -f 'zoekt-webserver.*:%d'", port)
	vim.fn.jobstart(kill_cmd, {
		on_exit = function(_, _)
			-- Start new server
			local server_cmd = string.format("zoekt-webserver -listen :%d -index %s", port, vim.fn.shellescape(index_dir))
			vim.fn.jobstart(server_cmd, {
				detach = true,
				on_exit = function(_, server_exit_code)
					if server_exit_code ~= 0 then
						vim.notify("Zoekt webserver exited with code: " .. server_exit_code, vim.log.levels.WARN)
					-- else
					--	vim.notify("Zoekt webserver started successfully", vim.log.levels.INFO)
					end
				end,
				on_stderr = function(_, data)
					-- Suppress INFO logs, only show actual errors
					if data and #data > 0 then
						for _, line in ipairs(data) do
							if line and line ~= "" and not line:match("%[INFO%]") then
								vim.notify("Zoekt server error: " .. line, vim.log.levels.ERROR)
							end
						end
					end
				end
			})
			
			-- Wait for server to actually start responding
			wait_for_server_ready(port, function()
				-- vim.notify("Opening zoekt search...", vim.log.levels.INFO)
				server_started = true  -- Mark server as started after it's ready
				require("tele-zoekt").zoekt_search()
			end)
		end
	})
end

-- Function to check if server is running and start search (no server restart)
local function check_server_and_search()
	local port = get_zoekt_port()
	-- vim.notify("DEBUG: check_server_and_search called, port=" .. port .. ", server_started=" .. tostring(server_started), vim.log.levels.INFO)
	
	-- If server was started recently, trust it and don't test connection
	if server_started then
		-- vim.notify("DEBUG: Server already started, opening search directly", vim.log.levels.INFO)
		require("tele-zoekt").zoekt_search()
		return
	end
	
	-- Only test connection if we're not sure about server status
	-- vim.notify("DEBUG: Testing server connection...", vim.log.levels.INFO)
	if test_server_connection(port) then
		-- Server is responding, mark it as started and search
		-- vim.notify("DEBUG: Server responding, marking as started", vim.log.levels.INFO)
		server_started = true
		require("tele-zoekt").zoekt_search()
	else
		-- Server is not running, need to start it
		-- vim.notify("DEBUG: Server not responding, need to start it", vim.log.levels.INFO)
		local zoektrc_path, parent_dir = find_zoektrc()
		if parent_dir then
			local index_dir = parent_dir .. "/.zoektindex"
			-- vim.notify("DEBUG: Starting server with index_dir=" .. index_dir, vim.log.levels.INFO)
			start_server_and_search(index_dir)
		else
			vim.notify("Cannot start server - no .zoektrc found", vim.log.levels.ERROR)
		end
	end
end

-- Helper function to check if indexing is needed
local function needs_indexing(parent_dir)
	local current_hash = get_current_git_hash()
	local stored_hash = read_zoekt_status(parent_dir)
	
	if not current_hash then
		vim.notify("Could not get current git hash", vim.log.levels.ERROR)
		return false
	end
	
	if not stored_hash then
		vim.notify("No previous index found, indexing needed", vim.log.levels.INFO)
		return true
	end
	
	if current_hash ~= stored_hash then
		vim.notify("Git hash changed, re-indexing needed", vim.log.levels.INFO)
		return true
	end
	
	-- vim.notify("Index is up to date", vim.log.levels.INFO)
	return false
end

-- Enhanced ZoektSearch command
function M.zoekt_search()
	-- Check if we're in a git repository
	if not is_git_repo() then
		vim.notify("Not in a git repository", vim.log.levels.ERROR)
		return
	end
	
	-- Find .zoektrc file
	local zoektrc_path, parent_dir = find_zoektrc()
	if not zoektrc_path then
		vim.notify("No .zoektrc file found in parent directory", vim.log.levels.ERROR)
		return
	end
	
	-- vim.notify("Found .zoektrc at: " .. zoektrc_path, vim.log.levels.INFO)
	
	-- Check if indexing is needed
	if needs_indexing(parent_dir) then
		vim.notify("Index update needed, starting synchronous indexing...", vim.log.levels.INFO)
		
		-- Run indexing synchronously, then start server, then search
		run_zoekt_index_sync(parent_dir, function()
			-- After indexing is complete, start server and then search
			local index_dir = parent_dir .. "/.zoektindex"
			-- vim.notify("DEBUG: Indexing complete, starting server...", vim.log.levels.INFO)
			start_server_and_search(index_dir)
			-- server_started flag will be set by start_server_and_search after delay
		end)
	else
		-- Index is up to date, just check server and search
		-- vim.notify("DEBUG: Index is up to date, checking server...", vim.log.levels.INFO)
		check_server_and_search()
	end
end

-- Function to initialize zoekt on vim startup (if in git repo with .zoektrc)
function M.init_zoekt()
	-- Only run if we're in a git repository
	if not is_git_repo() then
		return
	end
	
	-- Check for .zoektrc file
	local zoektrc_path, parent_dir = find_zoektrc()
	if zoektrc_path then
		-- vim.notify("Found .zoektrc, zoekt management enabled for this repository", vim.log.levels.INFO)
		
		-- Set up cleanup on exit
		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = function()
				-- Kill the zoekt server for this session when Neovim exits
				if zoekt_server_port then
					local kill_cmd = string.format("pkill -f 'zoekt-webserver.*:%d'", zoekt_server_port)
					vim.fn.system(kill_cmd)
					vim.notify(string.format("Stopped zoekt server on port %d", zoekt_server_port), vim.log.levels.INFO)
				end
			end,
			desc = "Cleanup zoekt server on exit"
		})
		
		-- Optionally, you could start background indexing here if needed
		-- if needs_indexing(parent_dir) then
		--     vim.notify("Auto-indexing on startup (disabled by default)", vim.log.levels.INFO)
		--     run_zoekt_index(parent_dir)
		-- end
	end
end

-- Manual indexing command
function M.force_index()
	if not is_git_repo() then
		vim.notify("Not in a git repository", vim.log.levels.ERROR)
		return
	end
	
	local zoektrc_path, parent_dir = find_zoektrc()
	if not zoektrc_path then
		vim.notify("No .zoektrc file found in parent directory", vim.log.levels.ERROR)
		return
	end
	
	run_zoekt_index(parent_dir)
end

-- Manual server start command
function M.start_server()
	if not is_git_repo() then
		vim.notify("Not in a git repository", vim.log.levels.ERROR)
		return
	end
	
	local zoektrc_path, parent_dir = find_zoektrc()
	if not zoektrc_path then
		vim.notify("No .zoektrc file found in parent directory", vim.log.levels.ERROR)
		return
	end
	
	local index_dir = parent_dir .. "/.zoektindex"
	
	-- Check if index directory exists
	if vim.fn.isdirectory(index_dir) == 0 then
		vim.notify("Index directory doesn't exist. Run :ZoektIndex first.", vim.log.levels.ERROR)
		return
	end
	
	restart_zoekt_server(index_dir)
end

-- Status check command
function M.status()
	if not is_git_repo() then
		vim.notify("Not in a git repository", vim.log.levels.ERROR)
		return
	end
	
	local zoektrc_path, parent_dir = find_zoektrc()
	if not zoektrc_path then
		vim.notify("No .zoektrc file found in parent directory", vim.log.levels.ERROR)
		return
	end
	
	local current_hash = get_current_git_hash()
	local stored_hash = read_zoekt_status(parent_dir)
	
	vim.notify("=== Zoekt Status ===", vim.log.levels.INFO)
	vim.notify("Config file: " .. zoektrc_path, vim.log.levels.INFO)
	vim.notify("Current git hash: " .. (current_hash or "unknown"), vim.log.levels.INFO)
	vim.notify("Indexed git hash: " .. (stored_hash or "none"), vim.log.levels.INFO)
	
	if current_hash and stored_hash then
		if current_hash == stored_hash then
			vim.notify("✓ Index is up to date", vim.log.levels.INFO)
		else
			vim.notify("⚠ Index needs update", vim.log.levels.WARN)
		end
	else
		vim.notify("⚠ Index status unclear", vim.log.levels.WARN)
	end
end

-- Smart search function that chooses between ZoektSearch and regular telescope search
function M.smart_search()
	-- Check if we're in a git repository and have .zoektrc
	if is_git_repo() then
		local zoektrc_path, parent_dir = find_zoektrc()
		if zoektrc_path then
			-- vim.notify("Using ZoektSearch (found .zoektrc)", vim.log.levels.INFO)
			M.zoekt_search()
			return
		end
	end
	
	-- Fallback to regular telescope search
	-- vim.notify("Using regular telescope search", vim.log.levels.INFO)
	require('telescope').extensions.live_grep_args.live_grep_args()
end

return M
