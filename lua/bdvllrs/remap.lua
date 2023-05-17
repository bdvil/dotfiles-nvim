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

-- Terminal
vim.keymap.set("t", "<ESC>", "<C-\\><C-N>")
vim.keymap.set("t", "<A-h>", "<C-\\><C-N><C-w>h")

-- DAP
local dap = require('dap')
local dap_widget = require('dap.ui.widgets')
local dap_python = require('dap-python')

vim.keymap.set("n", "<leader>b", function() dap.toggle_breakpoint() end)
vim.keymap.set("n", "<leader>cb", function() dap.clear_breakpoints() end)
vim.keymap.set("n", "<Leader>B", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
vim.keymap.set("n", "<Leader>lp", function() dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end)
vim.keymap.set("n", "<leader>c", function() dap.continue() end)
vim.keymap.set("n", "<leader>dq", function()
    dap.terminate()
end)
vim.keymap.set("n", "<leader>so", function() dap.step_over() end)
vim.keymap.set("n", "<leader>si", function() dap.step_into() end)
vim.keymap.set("n", "<leader>si", function() dap.step_into() end)
vim.keymap.set("n", "<leader>o", function() dap.step_out() end)
vim.keymap.set("n", "<leader>ds", function() dap.repl.open() end)
vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end)
vim.keymap.set("n", "<leader>dl", function() dap.run_last() end)
vim.keymap.set("n", "<leader>dp", function() dap_python.test_method() end)
vim.keymap.set({ "n", "v" }, "<leader>dh", function()
    dap_widget.hover()
end)
vim.keymap.set({ "n", "v" }, "<leader>dp", function()
    dap_widget.preview()
end)
vim.keymap.set("n", "<leader>df", function()
    local widgets = dap_widget
    widgets.centered_float(widgets.frames)
end)
vim.keymap.set("n", "<leader>ds", function()
    local widgets = dap_widget
    widgets.centered_float(widgets.scopes)
end)

-- refactoring

vim.api.nvim_set_keymap(
    "v",
    "<leader>rr",
    "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
    { noremap = true }
)

-- fugitive

vim.keymap.set("n", "<leader>k", ":Git <CR>")
vim.keymap.set("n", "<leader>gf", ":Git pull <CR>")
vim.keymap.set("n", "<leader>gp", ":Git push <CR>")
