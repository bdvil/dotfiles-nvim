return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                term_colors = true,
                color_overrides = {
                    mocha = {
                        base = "#13161c",
                        mantle = "#13161c",
                        crust = "#13161c",
                    },
                },
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    treesitter = true,
                    mini = {
                        enabled = true,
                        indentscope_color = "",
                    },
                    dap = true,
                    dap_ui = true,
                    native_lsp = {
                        enabled = true,
                        virtual_text = {
                            errors = { "italic" },
                            hints = { "italic" },
                            warnings = { "italic" },
                            information = { "italic" },
                        },
                        underlines = {
                            errors = { "underline" },
                            hints = { "underline" },
                            warnings = { "underline" },
                            information = { "underline" },
                        },
                        inlay_hints = {
                            background = true,
                        },
                    },
                    telescope = {
                        enabled = true,
                    },
                    mason = false,
                    harpoon = false,
                    flash = true,
                    fidget = false,
                },
            })
        end,
    },
}
