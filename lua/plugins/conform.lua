return {
    {
        "stevearc/conform.nvim",
        lazy = false,
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "[F]ormat buffer",
            },
        },
        config = function()
            local conform = require("conform")

            local stylua = require("conform.formatters.stylua")
            local stylua_args = { unpack(stylua.args) }
            table.insert(stylua_args, "--indent-type")
            table.insert(stylua_args, "Spaces")

            conform.setup({
                notify_on_error = false,
                format_on_save = function(bufnr)
                    local disable_filetypes = { c = true, cpp = true }
                    return {
                        timeout_ms = 500,
                        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                    }
                end,
                formatters_by_ft = {
                    lua = { "stylua" },
                },
                formatters = {
                    stylua = {
                        args = stylua_args,
                    },
                },
            })
        end,
    },
}
