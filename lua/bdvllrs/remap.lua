vim.keymap.set({ "n", "x", "v" }, "(", "[", { remap = true })
vim.keymap.set({ "n", "x", "v" }, ")", "]", { remap = true })

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("n", "<C-w>o", ":mksession! ~/.session.nvim<CR>:wincmd o<CR>")
vim.keymap.set("n", "<C-w>u", ":source ~/.session.nvim<CR>")

-- Telescope
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


-- Terminal
vim.keymap.set("t", "<ESC>", "<C-\\><C-N>")
vim.keymap.set("t", "<A-h>", "<C-\\><C-N><C-w>h")

-- DAP
local dap = require('dap')
local dapui = require('dapui')
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
vim.keymap.set("n", "<leader>o", function() dap.step_out() end)
vim.keymap.set("n", "<leader>ds", function() dap.repl.open() end)
vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end)
vim.keymap.set("n", "<leader>dl", function() dap.run_last() end)
vim.keymap.set("n", "<leader>dt", function() dap_python.test_method() end)
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

vim.keymap.set("n", "<leader>du", function() dapui.toggle({ reset = true }) end)
vim.keymap.set("n", "<leader>de", function() dapui.eval(vim.fn.input('Expression: ')) end)

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

-- flash
local flash = require('flash')

vim.keymap.set({ "n", "x", "o" }, "<leader>s", function()
    flash.jump({
        search = {
            mode = function(str)
                return "\\<" .. str
            end,
        },
    })
end)
vim.keymap.set({ "n", "x", "o" }, "<leader>S", function() flash.treesitter() end)
vim.keymap.set("o", "<leader>r", function() flash.remote() end)
vim.keymap.set({ "n", "x", "o" }, "<leader>R", function() flash.treesitter_search() end)

-- Trouble
local trouble = require("trouble")

vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>",
    { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>tn", trouble.next, { silent = true, noremap = true })
vim.keymap.set("n", "<leader>tp", trouble.previous, { silent = true, noremap = true })
vim.keymap.set("n", "<leader>tf", trouble.first, { silent = true, noremap = true })
vim.keymap.set("n", "<leader>tl", trouble.last, { silent = true, noremap = true })

-- pyro
local move_symbol = require("bdvllrs.pyro")
vim.keymap.set("n", "<leader>m", function()
    move_symbol({ pyro_bin = os.getenv("PYRO_BIN") })
end, { silent = true, noremap = true })
