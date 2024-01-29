return {
    -- "stevearc/dressing.nvim",
    "nvim-treesitter/playground",
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end
    },
    "tpope/vim-repeat",
    "tpope/vim-surround",
    "tpope/vim-unimpaired",
    "folke/flash.nvim",

    "mrjones2014/nvim-ts-rainbow",

    "windwp/nvim-autopairs",
    {
        "numToStr/Comment.nvim",
        lazy = false,
        config = function()
            print("ok")
            require('Comment').setup()
        end
    },

    {
        'christoomey/vim-tmux-navigator',
        lazy = false
    },

    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter"
        }
    },

    "lukas-reineke/indent-blankline.nvim",

    "norcalli/nvim-colorizer.lua",

    {
        'akinsho/flutter-tools.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim',
        },
    },

    "dart-lang/dart-vim-plugin",
}
