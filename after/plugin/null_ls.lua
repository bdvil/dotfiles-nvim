require("mason-null-ls").setup({
    ensure_installed = { "black" }
})

local null_ls = require('null-ls')
null_ls.setup({
  debug = false,
  sources = {
      null_ls.builtins.formatting.black.with({
          extra_args = { "--line-length=120", "--fast" }
      }),
      null_ls.builtins.diagnostics.flake8,
  }
})
