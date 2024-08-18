return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "bash",
                    "python",
                    "yaml",
                    "latex",
                    "markdown",
                    "sql",
                    "go",
                },

                sync_install = false,
                auto_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                    max_file_lines = nil,
                },
                indent = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-s>",
                        node_incremental = "<C-s>",
                        scope_incremental = false,
                        node_decremental = "<C-q>",
                    },
                },
            })
        end,
    },
}
