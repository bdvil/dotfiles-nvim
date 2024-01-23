return {
    -- "stevearc/dressing.nvim",
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("onedark")
        end
    },

    "nvim-treesitter/playground",

    {
        'folke/trouble.nvim',
        config = function()
            require("trouble").setup({
                icons = false,
            })
        end
    },

    "mbbill/undotree",
    "tpope/vim-fugitive",
    "tpope/vim-repeat",
    "tpope/vim-surround",
    "tpope/vim-unimpaired",
    "folke/flash.nvim",

    "mrjones2014/nvim-ts-rainbow",

    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            { 'neovim/nvim-lspconfig' },
            {
                'williamboman/mason.nvim',
                build = ':MasonUpdate',
            },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    },
    "microsoft/python-type-stubs",

    "onsails/lspkind.nvim",

    "folke/neodev.nvim",

    {
        "windwp/nvim-autopairs",
        config = function()
            require('nvim-autopairs').setup({})
        end
    },

    "mfussenegger/nvim-dap",
    { 'mfussenegger/nvim-dap-python', dependencies = "mfussenegger/nvim-dap" },
    { "rcarriga/nvim-dap-ui",         dependencies = "mfussenegger/nvim-dap" },
    "nvim-telescope/telescope-dap.nvim",
    "theHamsta/nvim-dap-virtual-text",

    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true }
    },


    -- "github/copilot.vim",
    -- {
    --     "zbirenbaum/copilot-cmp",
    --     config = function()
    --         require("copilot_cmp").setup()
    --     end,
    --     dependencies = {
    --         "zbirenbaum/copilot.lua",
    --         cmd = "Copilot",
    --         event = "InsertEnter",
    --         config = function()
    --             require("copilot").setup({
    --                 suggestion = { enabled = false },
    --                 panel = { enabled = false },
    --             })
    --         end,
    --     }
    -- },

    "terrortylor/nvim-comment",

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
