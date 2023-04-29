local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local find_folder_with_file = function(filename, start_dir)
  local dir = start_dir
  while dir ~= nil do
    local file_path = dir .. "/" .. filename
    local file = io.open(file_path)
    if file then
      file:close()
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

local getPath=function(str,sep)
    sep=sep or'/'
    return str:match("(.*"..sep..")")
end

local file_exists =function(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

local sources = {

  -- webdev stuff
  -- b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  b.formatting.eslint_d.with({
        timeout = 60000,
        cwd = function(params)
          -- return "/home/uri/ws/fundguard/fgrepo/client/packages/libs/domain"
          -- return vim.fn.getcwd()
          local fn = find_folder_with_file("tsconfig.json", getPath(vim.api.nvim_buf_get_name(0)))
          return fn or vim.fn.getcwd()
        end,
    }),
  b.diagnostics.eslint_d.with({
        timeout = 60000,
        cwd = function(params)
          local fn = find_folder_with_file("tsconfig.json", getPath(vim.api.nvim_buf_get_name(0)))
          return fn or vim.fn.getcwd()
          -- local fn = getPath(vim.api.nvim_buf_get_name(0))
          -- while not file_exists(fn . "tsconfig.json") do
          --   fn = getPath(fn)
          -- end
          -- return fn
          -- return getPath(vim.api.nvim_buf_get_name(0))
            -- return vim.fn.getcwd()
        end,
    }),
  -- b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,
}

null_ls.setup {
  debug = true,
  sources = sources,
  autostart = true,
}



