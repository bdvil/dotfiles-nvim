return {
    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap",
            "folke/trouble.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            local trouble = require("trouble.providers.telescope")
            local telescope = require("telescope")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = { ["<C-x>"] = trouble.open_with_trouble },
                        n = { ["<C-x>"] = trouble.open_with_trouble },
                    },
                },
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
            })

            telescope.load_extension("dap")
            telescope.load_extension("ui-select")

            local builtin = require('telescope.builtin')

            vim.keymap.set('n', '<C-p>', builtin.git_files, {})
            vim.keymap.set('n', '<C-e>', builtin.oldfiles, {})
            vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
            vim.keymap.set('n', '<leader>sg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>sd', builtin.diagnostics, {})
            vim.keymap.set('n', '<leader>sk', builtin.keymaps, {})
            vim.keymap.set('n', '<leader>sq', builtin.quickfix, {})
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, {})
            vim.keymap.set('n', '<leader><leader>', builtin.buffers, {})
        end
    }
}
