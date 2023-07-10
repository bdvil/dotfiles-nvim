vim.cmd [[packadd packer.nvim]]


local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()


return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'stevearc/dressing.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = 'nvim-lua/plenary.nvim'
    }

    use {
        "olimorris/onedarkpro.nvim",
        config = function()
            vim.cmd("colorscheme onedark")
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        { run = ':TSUpdate' }
    }

    use 'nvim-treesitter/playground'

    use 'lewis6991/impatient.nvim'
    use {
        'folke/trouble.nvim',
        config = function()
            require("trouble").setup({
                icons = false,
            })
        end
    }

    use 'ThePrimeagen/harpoon'
    use 'mbbill/undotree'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-repeat'
    use 'tpope/vim-surround'
    use 'tpope/vim-unimpaired'
    use 'folke/flash.nvim'

    use 'mrjones2014/nvim-ts-rainbow'

    use {
        "williamboman/mason.nvim",
        run = ":MasonUpdate" -- :MasonUpdate updates registry contents
    }

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {
                -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' }, -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' }, -- Required
        }
    }
    use 'microsoft/python-type-stubs'

    use 'onsails/lspkind.nvim'

    use 'folke/neodev.nvim'

    use 'windwp/nvim-autopairs'

    use 'jose-elias-alvarez/null-ls.nvim'
    use 'jay-babu/mason-null-ls.nvim'

    use 'mfussenegger/nvim-dap'
    use { 'mfussenegger/nvim-dap-python', requires = "mfussenegger/nvim-dap" }
    use { "rcarriga/nvim-dap-ui", requires = "mfussenegger/nvim-dap" }
    use "nvim-telescope/telescope-dap.nvim"
    use "theHamsta/nvim-dap-virtual-text"

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }


    -- use 'github/copilot.vim'
    use {
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
    use {
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end
    }

    use 'terrortylor/nvim-comment'

    use {
        'christoomey/vim-tmux-navigator',
        lazy = false
    }

    use {
        "ThePrimeagen/refactoring.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter"
        }
    }

    use 'lukas-reineke/indent-blankline.nvim'

    use 'norcalli/nvim-colorizer.lua'

    use 'mg979/vim-visual-multi'

    use {
        'akinsho/flutter-tools.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
    }

    use 'dart-lang/dart-vim-plugin'

    if packer_bootstrap then
        require('packer').sync()
    end
end)
