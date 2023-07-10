local dap = require("dap")

local dapui = require('dapui')
local dap_python = require('dap-python')
dapui.setup()
dap_python.setup(os.getenv("DAP_ENV"))
dap_python.test_runner = "pytest"

require('dap.ext.vscode').load_launchjs()

require("nvim-dap-virtual-text").setup({})


dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open({ reset = true })
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

dapui.setup({
    layouts = {
        {
            elements = {
                { id = "breakpoints", size = 0.33 },
                { id = "stacks",      size = 0.33 },
                { id = "watches",     size = 0.33 },
            },
            size = 40,
            position = "left",
        },
        {
            elements = {
                { id = "repl",   size = 0.5 },
                { id = "scopes", size = 0.5 },
            },
            size = 15,
            position = "bottom",
        },
    },
})

vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#BB3939' })
vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef' })
vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379' })

vim.api.nvim_set_hl(0, 'DapBreakpointLine', { bg = "#34383f" })
vim.api.nvim_set_hl(0, 'DapLogPointLine', { underline = true })
vim.api.nvim_set_hl(0, 'DapStoppedLine', { reverse = true })

vim.fn.sign_define('DapBreakpoint', {
    text = '',
    texthl = 'DapBreakpoint',
    linehl = 'DapBreakpointLine',
    numhl = 'DapBreakpoint',
})
vim.fn.sign_define('DapBreakpointCondition', {
    text = '',
    texthl = 'DapBreakpoint',
    linehl = 'DapBreakpointLine',
    numhl = 'DapBreakpoint',
})
vim.fn.sign_define('DapBreakpointRejected', {
    text = '',
    texthl = 'DapBreakpoint',
    linehl = 'DapBreakpointLine',
    numhl = 'DapBreakpoint',
})
vim.fn.sign_define('DapLogPoint', {
    text = '',
    texthl = 'DapLogPoint',
    linehl = 'DapLogPointLine',
    numhl = 'DapLogPoint',
})
vim.fn.sign_define('DapStopped', {
    text = '',
    texthl = 'DapStopped',
    linehl = 'DapStoppedLine',
    numhl = 'DapStopped',
})
