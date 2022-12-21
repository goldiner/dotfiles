local lsp = require('lsp-zero')

lsp.preset('recommended')

lsp.ensure_installed({
  'tsserver',
  'eslint',
  'sumneko_lua',
  'rust_analyzer',
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
--local cmp_mappings = lsp.defaults.cmp_mappings({
--  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select)
--  ['<C-Space>'] = cmp.mapping.complete(),
--})

--lsp.set_preferences({
--  sign_icons = { }
--})
--


lsp.on_attach(function(clent, bufnr)
  local opts = {buffer = bufnr, remap = false}

  
  vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
  vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
  vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workstace_symbol() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
  virtual_text = true
})

--print("hi from test");
