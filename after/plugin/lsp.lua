require("neodev").setup()


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
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp'},
    {name = 'buffer', keyword_length = 3},
    {name = 'luasnip', keyword_length = 2},
  },
  mapping = {
      ['<CR>'] = cmp.mapping.confirm({select = false}),
      ['<C-A>'] = cmp.mapping.complete(),
      ['<Tab>'] = cmp_action.tab_complete(),
      ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
      ['<C-f>'] = cmp_action.luasnip_jump_forward(),
      ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  },
  preselect = 'item',
  completion = {
      completeopt = 'menu,menuone,noinsert',
      side_padding = 5,
  },
  formatting = {
      format = function(entry, vim_item)
          if vim.tbl_contains({ 'path' }, entry.source.name) then
              local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
              if icon then
                  vim_item.kind = icon
                  vim_item.kind_hl_group = hl_group
                  return vim_item
              end
          end
          return require('lspkind').cmp_format({ 
              mode = "symbol_text",
              with_text = false,
              max_width = 50

          })(entry, vim_item)
      end
  }
})

