require("mason-null-ls").setup({
    ensure_installed = { "autoflake", "isort", "flake8", "black" }
})

local null_ls = require('null-ls')
null_ls.setup({
    debug = false,
    sources = {
        null_ls.builtins.formatting.autoflake.with({
            extra_args = { "--remove-all-unused-imports" }
        }),
        null_ls.builtins.formatting.isort.with({
            extra_args = { "--profile=black" }
        }),
        null_ls.builtins.formatting.black.with({
            extra_args = { "--line-length=79" }
        }),
        null_ls.builtins.diagnostics.flake8,
    }
})
