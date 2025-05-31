return {
    -- "stevearc/dressing.nvim",
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {},
    },
    "tpope/vim-repeat",
    "tpope/vim-surround",
    "tpope/vim-unimpaired",
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "<leader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
            { "<leader>S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { "r",         mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
            { "R",         mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { "<c-s>",     mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
    },

    "windwp/nvim-autopairs",
    {
        "numToStr/Comment.nvim",
        lazy = false,
        config = function()
            require("Comment").setup()
        end,
    },

    "lukas-reineke/indent-blankline.nvim",

    "norcalli/nvim-colorizer.lua",

    {
        "akinsho/flutter-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "stevearc/dressing.nvim",
        },
    },

    "dart-lang/dart-vim-plugin",

    {
        "AckslD/nvim-FeMaco.lua",
        config = function()
            require("femaco").setup({
                float_opts = function(_)
                    return {
                        relative = "win",
                        width = vim.api.nvim_win_get_width(0),
                        height = vim.api.nvim_win_get_height(0),
                        anchor = "NW",
                        zindex = 1,
                        row = 0,
                        col = 0,
                    }
                end,
                ensure_newline = function(_)
                    return true
                end,
            })

            local femaco_edit = require("femaco.edit")
            vim.keymap.set("n", "<leader>e", femaco_edit.edit_code_block)
        end,
    },

    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false },
    },

    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
    },
}
