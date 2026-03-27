local curl = require("plenary.curl")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local previewers = require "telescope.previewers"

-- local function url_encode(str)
-- 	-- if (str) then
-- 	-- 	str = str:gsub("\n", "\r\n")
-- 	-- 	str = str:gsub("([^%w%-._~])", function(c)
-- 	-- 		return string.format("content:%%%02X", string.byte(c))
-- 	-- 	end)
-- 	-- end
-- 	-- return str
-- 	return str:gsub("%s", "%%20")
-- end


local function url_encode(str)
	if str == nil then return "" end
	str = tostring(str)
	return str:gsub("([^%w%-_%.~])", function(c)
		return string.format("%%%02X", string.byte(c))
	end)
end

local M = {}


-- function M.zoekt_search()
-- 	pickers.new({}, {
-- 		prompt_title = "Zoekt Search",
-- 		finder = finders.new_table({
-- 			results = { "test", "another line", "something else" },
-- 		}),
-- 		sorter = conf.generic_sorter({}),
-- 	}):find()
-- end

-- function M.zoekt_search()
-- 	pickers.new({}, {
-- 		prompt_title = "Zoekt Search",
-- 		finder = finders.new_dynamic {
-- 			fn = function(prompt)
-- 				if not prompt or #prompt < 3 then
-- 					return { "less then 3" .. prompt }
-- 				end
--
-- 				local encoded = url_encode(prompt)
-- 				local url = string.format("http://localhost:6070/search?q=%s&num=50&ctx=0&format=json",
-- 					encoded)
-- 				local res = curl.get(url)
--
-- 				-- local results = { 'test' }
-- 				local results = { 'test' }
-- 				local parsed = vim.fn.json_decode(res.body)
--
-- 				local files = parsed.result and parsed.result.FileMatches or {}
-- 				for _, file in ipairs(files) do
-- 					for _, match in ipairs(file.Matches or {}) do
-- 						for _, frag in ipairs(match.Fragments or {}) do
-- 							table.insert(results, string.format(
-- 								"%s:%d:1 %s%s%s", -- %s%s
-- 								file.FileName,
-- 								tonumber(match.LineNum) or 1,
-- 								frag.Pre,
-- 								frag.Match,
-- 								frag.Post
-- 							))
-- 						end
-- 					end
-- 				end
--
-- 				return results
-- 			end,
-- 		},
-- 		sorter = conf.generic_sorter({}),
-- 	}):find()
-- end
--
--

local function clean_str(s)
	return tostring(s or "")
	    :gsub("[%c%z]", "") -- remove control and null characters
	    :gsub("[\t\r\n]", " ") -- replace tabs/newlines with space
end


local last_prompt = nil

local function run_zoekt_search(prompt)
	-- if not prompt or #prompt < 3 then
	-- 	return {}
	-- end

	if not prompt or #prompt < 3 then
		return {}
	end


	last_prompt = prompt

	prompt = prompt:gsub(" ", "\\ ")

	prompt = prompt:gsub("\\ content:", " content:", 1)

	if prompt:find(" content:.", 1, true) then
		return {}
	end

	local content_query = prompt:match("content:([%w%s%p]*)")
	if content_query then
		-- Trim whitespace
		local trimmed = vim.trim(content_query)
		
		-- Prevent too generic searches
		if #trimmed < 3 then
			return {}
		end
		
		-- Block searches that are only punctuation/symbols (like "...", "***", "===")
		if trimmed:match("^[%p%s]*$") then
			return {}
		end
		
		-- Block searches that are only repeated characters (like "aaa", "111")
		if trimmed:match("^(.)\1+$") and #trimmed <= 4 then
			return {}
		end
		
		-- Ensure at least 3 non-regex characters (prevent generic regex like ".*", ".+", ".*?")
		local non_regex_chars = trimmed:gsub("[%.%*%+%?%^%$%(%)%[%]%{%}%|%\\]", "")
		if #non_regex_chars < 3 then
			return {}
		end
	end






	-- file:.*\.ts content:TAX_LOT
	local encoded = url_encode(prompt)
	--num - is the number of files (the number of matches can be higher)
	
	-- Get the dynamic port from zoekt-enhanced module
	local port = require("zoekt-enhanced").get_port()
	local url = string.format(
		"http://localhost:%d/search?q=%s&num=50&ctx=0&format=json",
		port, encoded)
	-- Safe curl request with error handling
	local res
	local ok, curl_result = pcall(curl.get, url, { timeout = 10000 })
	if not ok then
		-- Connection failed at curl level
		local zoekt_enhanced = require("zoekt-enhanced")
		if zoekt_enhanced.reset_server_status then
			zoekt_enhanced.reset_server_status()
		end
		print("Search failed: Cannot connect to server (try again)")
		return {}
	end
	res = curl_result
	
	-- Better error handling for failed requests
	if not res or not res.body or res.body == "" then
		-- Server failed, reset the server status in zoekt-enhanced
		local zoekt_enhanced = require("zoekt-enhanced")
		if zoekt_enhanced.reset_server_status then
			zoekt_enhanced.reset_server_status()
		end
		print("Search failed: No response from server (try again)")
		return {}
	end
	
	-- Safe JSON decode with error handling
	local parsed
	local ok, decode_result = pcall(vim.json.decode, res.body)
	if not ok then
		print("Search failed: Invalid JSON response")
		return {}
	end
	parsed = decode_result
	local MAX_RESULTS = 100
	local count = 0

	local results = {}
	local files = parsed.result and parsed.result.FileMatches or {}
	if type(files) ~= "table" then
		print("Failed to decode response: ", res)
		return {}
	end
	-- table.insert(results, {
	-- 	display = string.format("%s:%d: %s%s%s",
	-- 		file.FileName,
	-- 		lnum, frag.Pre, frag.Match, frag.Post),
	-- 	value = frag.Match,
	-- 	filename = abs_path,
	-- 	lnum = 1,
	-- 	col = 1,
	-- })

	-- local count = 0
	for _, file in ipairs(files or {}) do
		for _, match in ipairs(file.Matches or {}) do
			for _, frag in ipairs(match.Fragments or {}) do
				local abs_path = vim.fn.getcwd() .. "/" .. file.FileName
				local lnum = tonumber(match.LineNum) or 1
				-- table.insert(results, string.format(
				-- 	"%s:%d:1 %s%s%s", -- %s%s
				-- 	file.FileName,
				-- 	tonumber(match.LineNum) or 1,
				-- 	frag.Pre,
				-- 	frag.Match,
				-- 	frag.Post
				--
				-- ))
				-- count = count + 1
				-- print(count)
				local display = string.format("%s:%d: %s%s%s",
					file.FileName, lnum, frag.Pre, frag.Match, frag.Post)
				-- print(display)
				if file.FileName and lnum then
					table.insert(results, {
						display = clean_str(display),
						value = frag.Match,
						filename = abs_path,
						lnum = lnum,
						col = 1,
					})
				end
				count = count + 1
				if count >= MAX_RESULTS then
					return results
				end
			end
		end
	end

	return results
end


function M.zoekt_search()
	pickers.new({}, {
		prompt_title = "Indexed Search",
		default_text = last_prompt or "file:.*\\.* content:",
		finder = finders.new_dynamic {
			fn = function(prompt)
				-- if not prompt or #prompt < 3 then
				-- 	return {}
				-- end
				return run_zoekt_search(prompt)
			end,
			entry_maker = function(entry)
				if not entry or not entry.display or entry.display == "" then
					return nil
				end

				return {
					value = entry.value or "",
					display = entry.display,
					ordinal = entry.ordinal or entry.display,
					filename = entry.filename,
					lnum = entry.lnum,
					col = entry.col or 1,
				}
			end,
			-- entry_maker = function(entry)
			-- 	return {
			-- 		value = entry.value,
			-- 		display = entry.display,
			-- 		ordinal = entry.display,
			-- 		filename = entry.filename,
			-- 		lnum = entry.lnum,
			-- 		col = entry.col,
			-- 	}
			-- end,
		},
		-- sorter = conf.generic_sorter({}),
		-- previewer = previewers.new_buffer_previewer {
		-- 	title = "My preview",
		-- 	define_preview = function(self, entry, status)
		-- 		vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, { "line 1", "line 2" })
		-- 	end
		-- },
		attach_mappings = function(_, map)
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")
			map("i", "<CR>", function(prompt_bufnr)
				print("URIG CR")
				local entry = action_state.get_selected_entry()
				actions.close(prompt_bufnr)

				if entry and entry.filename then
					vim.cmd(string.format("edit %s", vim.fn.fnameescape(entry.filename)))
					local max_line = vim.api.nvim_buf_line_count(0)
					local safe_line = math.max(1, math.min(entry.lnum or 1, max_line))
					pcall(vim.api.nvim_win_set_cursor, 0, { safe_line, entry.col or 0 })
				end
			end)
			return true
		end,
	}):find()
end

return M




-- table.insert(results, string.format("%s", file.FileName))
-- table.insert(results, {
-- 	text = string.format("%s:%d: %s%s%s", file.FileName,
-- 		match.LineNum, frag.Pre, frag.Match, frag.Post),
-- 	-- display = string.format("%s:%d: %s%s%s", file.FileName,
-- 	-- 	match.LineNum, frag.Pre, frag.Match, frag.Post),
-- 	-- filename = vim.fn.getcwd() .. "/" .. file.FileName,
-- 	lnum = match.LineNum,
-- 	col = 1,
-- 	-- value = frag.Match
-- })
