return {
    "folke/trouble.nvim",
    config = function()
        local trouble = require("trouble")
        trouble.setup({
            icons = false,
        })

        vim.keymap.set("n", "<leader>xx", function()
            trouble.toggle()
        end)
        vim.keymap.set("n", "<leader>xn", function()
            trouble.next({
                skip_group = true,
                jump = true,
            })
        end)
        vim.keymap.set("n", "<leader>xp", function()
            trouble.previous({
                skip_group = true,
                jump = true,
            })
        end)
    end,
}
