local dap = require("dap")

local dapui = require('dapui')
local dap_python = require('dap-python')
dapui.setup()
dap_python.setup(os.getenv("HOME") .. '/miniconda3/envs/dap/bin/python')
dap_python.test_runner = "pytest"

require('dap.ext.vscode').load_launchjs()

require("nvim-dap-virtual-text").setup({})


-- dap.listeners.after.event_initialized["dapui_config"] = function()
--     dapui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
--     dapui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
--     dapui.close()
-- end

dapui.setup({
    layouts = {
        {
            elements = {
                { id = "terminal",    size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks",      size = 0.25 },
                { id = "watches",     size = 0.25 },
            },
            size = 40,
            position = "left",
        },
        {
            elements = {
                { id = "repl",   size = 0.33 },
                { id = "scopes", size = 0.66 },
            },
            size = 15,
            position = "bottom",
        },
    },
})

vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#BB3939' })
vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef' })
vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379' })

vim.fn.sign_define('DapBreakpoint', {
    text = '',
    texthl = 'DapBreakpoint',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint',
})
vim.fn.sign_define('DapBreakpointCondition', {
    text = 'ﳁ',
    texthl = 'DapBreakpoint',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint',
})
vim.fn.sign_define('DapBreakpointRejected', {
    text = '',
    texthl = 'DapBreakpoint',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint',
})
vim.fn.sign_define('DapLogPoint', {
    text = '',
    texthl = 'DapLogPoint',
    linehl = 'DapLogPoint',
    numhl = 'DapLogPoint',
})
vim.fn.sign_define('DapStopped', {
    text = '',
    texthl = 'DapStopped',
    linehl = 'DapStopped',
    numhl = 'DapStopped',
})
