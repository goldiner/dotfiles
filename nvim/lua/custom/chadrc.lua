---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require("custom.highlights")

M.ui = {
	theme = "chadracula",
	theme_toggle = { "chadracula", "one_light" },

	hl_override = highlights.override,
	hl_add = highlights.add,
	transparency = true,
	statusline = {
		overriden_modules = function()
			-- local st_modules = require "nvchad_ui.statusline.default"
			-- this is just default table of statusline modules

			return {
				git = function()
					return "%{FugitiveStatusline()}"
				end,
			}
		end,
	},
	tabufline = {
		overriden_modules = function(modules)
			modules[4] = (function()
				return ""
			end)()

			-- or table.remove(modules, 4)
		end,
	},
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require("custom.mappings")

return M
