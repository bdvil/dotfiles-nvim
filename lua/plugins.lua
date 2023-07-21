return {
    "stevearc/dressing.nvim",

    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.1',
        dependencies = 'nvim-lua/plenary.nvim'
    },

    {
        "olimorris/onedarkpro.nvim",
        priority = 1000,
        config = function()
            vim.cmd("colorscheme onedark")
        end
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },

    "nvim-treesitter/playground",

    "lewis6991/impatient.nvim",
    {
        'folke/trouble.nvim',
        config = function()
            require("trouble").setup({
                icons = false,
            })
        end
    },

    "ThePrimeagen/harpoon",
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
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {
                'williamboman/mason.nvim',
                build = ':MasonUpdate',
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },     -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' },     -- Required
        }
    },
    "microsoft/python-type-stubs",

    "onsails/lspkind.nvim",

    "folke/neodev.nvim",

    "windwp/nvim-autopairs",

    "jose-elias-alvarez/null-ls.nvim",
    "jay-babu/mason-null-ls.nvim",

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
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end,
        dependencies = {
            "zbirenbaum/copilot.lua",
            cmd = "Copilot",
            event = "InsertEnter",
            config = function()
                require("copilot").setup({
                    suggestion = { enabled = false },
                    panel = { enabled = false },
                })
            end,
        }
    },

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

    "mg979/vim-visual-multi",

    {
        'akinsho/flutter-tools.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim',
        },
    },

    "dart-lang/dart-vim-plugin",
}
