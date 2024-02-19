vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.py" },
    command = "silent! !autoflake --in-place <afile>"
})
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    pattern = { "*.py" },
    command = "redraw!"
})
