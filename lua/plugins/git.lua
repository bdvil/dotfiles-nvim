return {
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "nvim-telescope/telescope.nvim",
        },
        keys = {
            { "<leader>k",   ":Neogit<CR>" },
            { "<leader>gpl", ":Neogit pull<CR>" },
            { "<leader>gph", ":Neogit push<CR>" },
            { "<leader>grb", ":Neogit rebase<CR>" },
            { "<leader>gl",  ":Neogit log -g<CR>" },
            { "<leader>gd",  ":Neogit diff<CR>" },
        },
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
