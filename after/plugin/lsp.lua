local lsp = require('lsp-zero').preset("recommended")

lsp.on_attach(function(_, bufnr)
  lsp.default_keymaps({buffer = bufnr})
  vim.keymap.set('n', '<C-l>', function()
      vim.lsp.buf.format { async = true }
  end, { buffer = bufnr })
end)

lsp.setup()


local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'buffer', keyword_length = 3},
    {name = 'luasnip', keyword_length = 2},
  },
  mapping = {
      ['<CR>'] = cmp.mapping.confirm({select = false}),
      ['<leader>a'] = cmp.mapping(cmp.mapping.complete(), {"i", "s", "c", "n"}),
      ['<Tab>'] = cmp_action.tab_complete(),
      ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
      ['<C-f>'] = cmp_action.luasnip_jump_forward(),
      ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  },
  preselect = 'item',
  completion = {
      completeopt = 'menu,menuone,noinsert'
  }
})
