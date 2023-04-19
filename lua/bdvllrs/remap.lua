vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "J", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("t", "<ESC>", "<C-\\><C-n>")

-- DAP
local dap = require('dap')

vim.keymap.set("n", "<leader>db", function()
    dap.toggle_breakpoint()
end)

vim.keymap.set("n", "<leader>dc", function()
    dap.continue()
end)

vim.keymap.set("n", "<leader>do", function()
    dap.step_over()
end)

vim.keymap.set("n", "<leader>di", function()
    dap.step_into()
end)

vim.keymap.set("n", "<leader>ds", function()
    dap.repl.open()
end)
