local function code_action_request(client, selected_action)
    local params = vim.lsp.util.make_range_params(nil, client.offset_encoding)
    params.context = { only = { selected_action }, diagnostics = {} }

    local timeout = 1000
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, client.offset_encoding)
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "microsoft/python-type-stubs",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "j-hui/fidget.nvim", opt = {} },
            {
                "creativenull/efmls-configs-nvim",
                version = "v1.x.x", -- version is optional, but recommended
            },
        },
        config = function()
            local auformatgroup = vim.api.nvim_create_augroup("LspFormatting", {})
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local builtin = require("telescope.builtin")

                    local map = function(mode, keys, func, desc)
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    map("n", "gd", builtin.lsp_definitions, "[G]oto [D]efinitions")
                    map("n", "gr", builtin.lsp_references, "[G]oto [R]eferences")
                    map("n", "gI", builtin.lsp_implementations, "[G]oto [I]mplementations")
                    map("n", "<leader>D", builtin.lsp_type_definitions, "Type [D]efinitions")
                    map("n", "<leader>ds", builtin.lsp_document_symbols, "[D]ocument [S]ymbols")
                    map("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
                    map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                    map("n", "<leader>fm", vim.lsp.buf.format, "[F]or[m]at")
                    map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
                    map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    map("n", "<C-h>", vim.lsp.buf.signature_help, "Signature [H]elp")

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = auformatgroup, buffer = event.buf })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = auformatgroup,
                            buffer = event.buf,
                            callback = function()
                                vim.lsp.buf.format()
                                code_action_request(client, "source.organizeImports")
                            end,
                        })
                    end
                end,
            })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            local servers = {
                pyright = {
                    settings = {
                        pyright = {
                            disableOrganizeImports = true,
                        },
                        python = {
                            analysis = {
                                stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs/python-type-stubs",
                            },
                        },
                    },
                },
                ruff_lsp = {
                    on_attach = function(client, bufnr)
                        if client.name == "ruff_lsp" then
                            -- Disable hover in favor of Pyright
                            client.server_capabilities.hoverProvider = false
                        end
                    end,
                },
                texlab = {
                    settings = {
                        texlab = {
                            rootDirectory = nil,
                            build = {
                                executable = "latexmk",
                                onSave = true,
                            },
                            chktex = {
                                onOpenAndSave = true,
                            },
                            bibtexFormatter = "latexindent",
                            latexFormatter = "latexindent",
                            latexindent = {
                                modifyLineBreaks = true,
                            },
                        },
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = { version = "LuaJIT" },
                            diagnostics = {
                                globals = { "vim" },
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    "${3rd}/luv/library",
                                    unpack(vim.api.nvim_get_runtime_file("", true)),
                                },
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                            telemetry = {
                                enable = false,
                            },
                        },
                    },
                },
                sqlls = {},
            }

            require("mason").setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "stylua",
                "mypy",
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })

            vim.diagnostic.config({
                virtual_text = {
                    source = true,
                },
                float = {
                    source = true,
                },
            })

            local sign = function(hl, text)
                vim.fn.sign_define(hl, {
                    texthl = hl,
                    text = text,
                    numhl = "",
                })
            end

            sign("DiagnosticSignError", "✘")
            sign("DiagnosticSignWarn", "▲")
            sign("DiagnosticSignHint", "⚑")
            sign("DiagnosticSignInfo", "»")
        end,
    },
}
