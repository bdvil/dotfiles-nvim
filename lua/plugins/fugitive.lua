return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>k", vim.cmd.Git)
        vim.keymap.set("n", "<leader>gf", ":Git pull <CR>")
        vim.keymap.set("n", "<leader>gp", ":Git push <CR>")
    end,
}
