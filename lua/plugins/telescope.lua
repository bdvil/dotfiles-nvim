return {
    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.5',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            local trouble = require("trouble.providers.telescope")
            local telescope = require('telescope')

            telescope.setup {
                defaults = {
                    mappings = {
                        i = { ["<C-t>"] = trouble.open_with_trouble },
                        n = { ["<C-t>"] = trouble.open_with_trouble },
                    },
                }
            }
            telescope.load_extension('dap')
        end
    }
}