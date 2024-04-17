return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "nvim-telescope/telescope-dap.nvim",
        "theHamsta/nvim-dap-virtual-text",
        "mfussenegger/nvim-dap-python",
        {
            "rcarriga/nvim-dap-ui",
            dependencies = {
                "nvim-neotest/nvim-nio",
            },
        },
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        local dap_python = require("dap-python")

        dapui.setup({
            console = "integratedTerminal",
        })
        dap_python.setup(os.getenv("DEBUGPY_ENV"))
        dap_python.test_runner = "pytest"

        require("dap.ext.vscode").load_launchjs()
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

        vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#BB3939" })
        vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef" })
        vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379" })

        vim.api.nvim_set_hl(0, "DapBreakpointLine", { bg = "#34383f" })
        vim.api.nvim_set_hl(0, "DapLogPointLine", { underline = true })
        vim.api.nvim_set_hl(0, "DapStoppedLine", { reverse = true })

        vim.fn.sign_define("DapBreakpoint", {
            text = "",
            texthl = "DapBreakpoint",
            linehl = "DapBreakpointLine",
            numhl = "DapBreakpoint",
        })
        vim.fn.sign_define("DapBreakpointCondition", {
            text = "",
            texthl = "DapBreakpoint",
            linehl = "DapBreakpointLine",
            numhl = "DapBreakpoint",
        })
        vim.fn.sign_define("DapBreakpointRejected", {
            text = "",
            texthl = "DapBreakpoint",
            linehl = "DapBreakpointLine",
            numhl = "DapBreakpoint",
        })
        vim.fn.sign_define("DapLogPoint", {
            text = "",
            texthl = "DapLogPoint",
            linehl = "DapLogPointLine",
            numhl = "DapLogPoint",
        })
        vim.fn.sign_define("DapStopped", {
            text = "",
            texthl = "DapStopped",
            linehl = "DapStoppedLine",
            numhl = "DapStopped",
        })

        local dap_widget = require("dap.ui.widgets")

        vim.keymap.set("n", "<leader>b", function()
            dap.toggle_breakpoint()
        end)
        vim.keymap.set("n", "<leader>cb", function()
            dap.clear_breakpoints()
        end)
        vim.keymap.set("n", "<leader>B", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end)
        vim.keymap.set("n", "<leader>lp", function()
            dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end)
        vim.keymap.set("n", "<leader>cc", function()
            dap.continue()
        end)
        vim.keymap.set("n", "<leader>dq", function()
            dap.terminate()
        end)
        vim.keymap.set("n", "<leader>so", function()
            dap.step_over()
        end)
        vim.keymap.set("n", "<leader>si", function()
            dap.step_into()
        end)
        vim.keymap.set("n", "<leader>o", function()
            dap.step_out()
        end)
        vim.keymap.set("n", "<leader>dl", function()
            dap.run_last()
        end)
        vim.keymap.set("n", "<leader>dt", function()
            dap_python.test_method()
        end)
        vim.keymap.set({ "n", "v" }, "<leader>dh", function()
            dap_widget.hover()
        end)
        vim.keymap.set({ "n", "v" }, "<leader>dp", function()
            dap_widget.preview()
        end)
        vim.keymap.set("n", "<leader>das", function()
            dapui.float_element("scopes", {
                position = "center",
                enter = true,
            })
        end)
        vim.keymap.set("n", "<leader>dc", function()
            dapui.float_element("console", {
                position = "center",
                enter = true,
            })
        end)

        vim.keymap.set("n", "<leader>du", function()
            dapui.toggle({ reset = true })
        end)
        vim.keymap.set("n", "<leader>de", function()
            dapui.eval(vim.fn.input("Expression: "))
        end)
    end,
}
