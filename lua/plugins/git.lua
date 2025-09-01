return {
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            vim.keymap.set("n", "<leader>k", ":Neogit<CR>")
            vim.keymap.set("n", "<leader>gpl", ":Neogit pull<CR>")
            vim.keymap.set("n", "<leader>gph", ":Neogit push<CR>")
            vim.keymap.set("n", "<leader>grb", ":Neogit rebase<CR>")
            vim.keymap.set("n", "<leader>gl", ":Neogit log -g<CR>")
            vim.keymap.set("n", "<leader>gd", ":Neogit diff<CR>")
        end
    },
    -- {
    --     "tpope/vim-fugitive",
    --     config = function()
    --         vim.keymap.set("n", "<leader>k", vim.cmd.Git)
    --         vim.keymap.set("n", "<leader>gf", ":Git pull <CR>")
    --         vim.keymap.set("n", "<leader>gp", ":Git push <CR>")
    --     end,
    -- }
}
