local overrides = require("custom.configs.overrides")

---@type NvPluginSpec[]
local plugins = {

	-- Override plugin definition options
	--
	-- preparation for v3 nvchad
	-- { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"jose-elias-alvarez/null-ls.nvim",
				config = function()
					require("custom.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.lspconfig")
			require("custom.configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	-- override plugin configs
	{
		"williamboman/mason.nvim",
		opts = overrides.mason,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	-- Install a plugin
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

	{
		"kevinhwang91/nvim-bqf",
		lazy = false,
		-- config = function()
		--   require("bqf").setup() {
		--     -- ft = "qf",
		--     auto_enable = true,
		--   }
		-- end,
	},

	{
		"tpope/vim-fugitive",
		lazy = false,
		-- cmd = "Git"
		-- config = function()
		--   require("vim-fugitive").setup(){
		--     keys = {}
		--   }
		-- end,
	},
	{
		"tpope/vim-surround",
		lazy = false,
		-- cmd = "Git"
		-- config = function()
		--   require("vim-fugitive").setup(){
		--     keys = {}
		--   }
		-- end,
	},
	{
		"tpope/vim-rhubarb",
		lazy = false,
		-- cmd = "Git"
		-- config = function()
		--   require("vim-fugitive").setup(){
		--     keys = {}
		--   }
		-- end,
	},
	{
		"cedarbaum/fugitive-azure-devops.vim",
		lazy = false,
		-- cmd = "Git"
		-- config = function()
		--   require("vim-fugitive").setup(){
		--     keys = {}
		--   }
		-- end,
	},
	{
		"mfussenegger/nvim-jdtls",
		lazy = false,
		-- cmd = "Git"
		-- config = function()
		--   require("vim-fugitive").setup(){
		--     keys = {}
		--   }
		-- end,
	},

	{
		"vimwiki/vimwiki",
		lazy = false,
		-- config = function()
		--   require("vimwiki").setup() {}
		--   -- vim.g.vimwiki_list = {
		--   --   {
		--   --     path = '/home/urig/vimwiki',
		--   --     syntax = 'markdown',
		--   --     ext = '.md',
		--   --   }
		--   -- }
		--   -- }
		-- end,
		-- -- cmd = "Wiki"
	},
	{
		"phaazon/hop.nvim",
		lazy = false,
		config = function()
			require("hop").setup()
		end,
	},
	{
		"rmagatti/auto-session",
		lazy = false,
		config = function()
			require("auto-session").setup({
				log_level = "error",
				auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
			})
		end,
	},
	{
		"lambdalisue/suda.vim",
		lazy = false,
	},

	{
		"windwp/nvim-autopairs",
		enabled = false,
	},
	{
		"mfussenegger/nvim-dap",
		lazy = false,
		config = function()
			local dap = require("dap")
			dap.configurations.typescript = {
				{
					type = "node",
					name = "node attach",
					request = "attach",
					-- program = "${file}",
					cwd = vim.fn.getcwd(),
					sourceMaps = true,
					protocol = "inspector",
				},
			}
			dap.adapters.node = {
				-- type = "server",
				-- command = "js-debug-adapter",
				-- port = "9229",
				type = "executable",
				command = "node-debug2-adapter",
				args = {},
			}
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,

		lazy = false,
	},

	{
		"rust-lang/rust.vim",
		ft = "rust",
		init = function()
			vim.g.rustfmt_autosave = 1
		end,
	},

	{
		"saecki/crates.nvim",
		ft = { "rust", "toml" },
		config = function(_, opts)
			local crates = require("crates")
			crates.setup(opts)
			crates.show()
		end,
	},
	{
		"m00qek/baleia.nvim",
		command = "bal",
		lazy = false,
		config = function()
			vim.cmd("let baleia = luaeval(\"require('baleia').setup { }\")")
			vim.cmd("command! BaleiaColorize call baleia.once(bufnr('%'))")
		end,
		-- ft = { "0" },
	},

	--
	-- 'kevinhwang91/nvim-bqf'
	-- {
	--   "folke/trouble.nvim",
	--   requires = "nvim-tree/nvim-web-devicons",
	--   config = function()
	--     require("trouble").setup {
	--       -- your configuration comes here
	--       -- or leave it empty to use the default settings
	--       -- refer to the configuration section below
	--       -- auto_preview = false,
	--       -- mode = "quickfix",
	--       -- auto_jump = {}
	--     }
	--   end
	-- },

	-- {
	--    "dmmulroy/tsc.nvim",
	-- config = function()
	--   require("tsc").setup {
	--     auto_open_qflist = true,
	--     enable_progress_notifications = true,
	--     flags = "-b",
	--     hide_progress_notifications_from_history = true,
	--     spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
	--   }
	-- end
	-- },

	-- 'dmmulroy/tsc.nvim'
	--   {
	--     "MunifTanjim/eslint.nvim",
	--     config = function()
	-- require("eslint").setup({
	--   bin = 'eslint_d', -- or `eslint_d`
	--   code_actions = {
	--     enable = true,
	--     apply_on_save = {
	--       enable = true,
	--       types = { "directive", "problem", "suggestion", "layout" },
	--     },
	--     disable_rule_comment = {
	--       enable = true,
	--       location = "separate_line", -- or `same_line`
	--     },
	--   },
	--   diagnostics = {
	--     enable = true,
	--     report_unused_disable_directives = false,
	--     run_on = "type", -- or `save`
	--   },
	-- })
	--     end,
	--   },

	-- To make a plugin not be loaded
	-- {
	--   "NvChad/nvim-colorizer.lua",
	--   enabled = false
	-- },

	-- To use a extras plugin
	-- { import = "custom.configs.extras.symbols-outline", },
}
vim.g.vimwiki_list = {
	{
		path = "~/vimwiki",
		syntax = "markdown",
		ext = ".md",
	},
}
vim.g.vimwiki_ext2syntax = { [".md"] = "markdown", [".markdown"] = "markdown", [".mdown"] = "markdown" }
return plugins
