local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require("lspconfig")

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "clangd", "rust_analyzer", "jdtls" } --, "java_language_server" } --, "eslint_d"} "tsserver",

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

--
-- lspconfig.pyright.setup { blabla}
--
lspconfig.tsserver.setup({
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = false
		on_attach(client)
	end,
	capabilities = capabilities,
	--   {
	--   document_formatting = false
	-- },
	root_dir = function()
		return vim.loop.cwd()
	end,
})

lspconfig.tsserver.setup({
	on_attach = function(client)
		client.server_capabilities.documentFormattingProvider = false
		on_attach(client)
	end,
	capabilities = capabilities,
	--   {
	--   document_formatting = false
	-- },
	root_dir = function()
		return vim.loop.cwd()
	end,
})

-- lspconfig.java_language_server.setup({
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- 	cmd = { "java" },
-- })
