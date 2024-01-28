return {
    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "ThePrimeagen/refactoring.nvim",
            "mfussenegger/nvim-dap",
            "folke/trouble.nvim",
        },
        config = function()
            local trouble = require("trouble.providers.telescope")
            local telescope = require("telescope")

            telescope.setup {
                defaults = {
                    mappings = {
                        i = { ["<C-x>"] = trouble.open_with_trouble },
                        n = { ["<C-x>"] = trouble.open_with_trouble },
                    },
                }
            }

            telescope.load_extension("dap")
            telescope.load_extension("refactoring")
            local builtin = require('telescope.builtin')

            vim.keymap.set('n', '<C-p>', builtin.git_files, {})
            vim.keymap.set('n', '<C-e>', builtin.oldfiles, {})
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>sh', builtin.search_history, {})
            vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, {})
            vim.keymap.set('n', '<leader>d', builtin.diagnostics, {})
            vim.keymap.set('n', '<leader>ls', builtin.lsp_document_symbols, {})
            vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
            vim.keymap.set('n', '<leader>qf', builtin.quickfix, {})
            vim.keymap.set('n', '<leader>ft', builtin.help_tags, {})

            vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
            vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
            vim.keymap.set('n', '<leader>gs', builtin.git_stash, {})
        end
    }
}
