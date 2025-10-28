-- lua/custom/azure_search.lua

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local Job = require("plenary.job")

-- Helper function to fetch file content and jump to the location
local function fetch_and_open_file(entry)
  local token = 'OkRLcEhGRnBZRVhJMFdoOVEwSktTTnFJdUVma203QURjeVFKS3hxd1JDd0g1VmkwaUVmOGhKUVFKOTlCR0FDQUFBQUFCN05vRkFBQVNBWkRPMUE5Uw=='
  if not token or token == "" then
    print("Error: ADO_PAT environment variable not set.")
    return
  end

  local blob_url = string.format(
    "https://dev.azure.com/FundGuard/FundGuard/_apis/git/repositories/fgrepo/items?path=%s&api-version=7.1",
    entry.path
  )

  Job:new({
    command = "curl",
    args = { "-s", "-H", "Authorization: Basic " .. token, blob_url },
    on_exit = function(job, return_val)
      if return_val ~= 0 then
        print("Error fetching file content.")
        return
      end

      local content = table.concat(job:result(), "\n")
      local line_nr = 1
      local last_newline_pos = 0

      for i = 1, entry.offset do
        if content:sub(i, i) == "\n" then
          line_nr = line_nr + 1
          last_newline_pos = i
        end
      end

      -- ✅ Calculate column number
      local col_nr = entry.offset - last_newline_pos + 1

      vim.schedule(function()
        local corrected_path = entry.path
        if corrected_path:sub(1, 1) == "/" then
          corrected_path = corrected_path:sub(2)
        end
        -- Open the file, jump to the line, and then to the column
        vim.cmd(string.format("edit +%d %s", line_nr, corrected_path))
        vim.cmd(string.format("call cursor(%d, %d)", line_nr, col_nr))
      end)
    end,
  }):start()
end

local function search_devops(opts)
  opts = opts or {}

  pickers.new(opts, {
    prompt_title = "Azure DevOps Search",
    finder = finders.new_dynamic({
      entry_maker = function(entry_str)
        local entry = vim.fn.json_decode(entry_str)
        -- ✅ Correctly create the display text here
        local display_text = entry.path
        if entry.snippet and entry.snippet ~= "" then
          display_text = string.format("%s  |  %s", display_text, vim.fn.trim(entry.snippet))
        end
        return {
          value = entry,
          display = display_text, -- Use the full display text
          ordinal = entry.path,
          path = entry.path,
          offset = entry.offset,
          snippet = entry.snippet,
        }
      end,
      fn = function(prompt)
        if not prompt or prompt == "" or #prompt < 3 then
          return
        end
	local token = 'OkRLcEhGRnBZRVhJMFdoOVEwSktTTnFJdUVma203QURjeVFKS3hxd1JDd0g1VmkwaUVmOGhKUVFKOTlCR0FDQUFBQUFCN05vRkFBQVNBWkRPMUE5Uw=='
        if not token or token == "" then
          print("Error: ADO_PAT environment variable not set.")
          return
        end
        local search_text = prompt
        local cmd = string.format(
          [[curl -s -X POST -H "Authorization: Basic %s" -H "Content-Type: application/json" "https://almsearch.dev.azure.com/FundGuard/FundGuard/_apis/search/codesearchresults?api-version=7.1" -d '{"searchText": "%s", "$top": 100, "includeSnippet": true, "filters": {"Project": ["FundGuard"],"Repository": ["fgrepo"],"Branch": ["develop"]}}' | jq -c '.results[] | . as $parent | .matches.content[] | {path: $parent.path, offset: .charOffset, snippet: .codeSnippet}']],
          token,
          search_text
        )
        return vim.fn.systemlist(cmd)
      end,
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        fetch_and_open_file(selection.value) -- Pass the underlying value table
      end)
      return true
    end,
  }):find()
end

return {
  search_devops = search_devops,
}

