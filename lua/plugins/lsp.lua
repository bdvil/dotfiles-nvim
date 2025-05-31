local function code_action_resolve_request(client, selected_action)
    local params = {
        data = vim.uri_from_bufnr(0),
        kind = selected_action,
        title = selected_action,
    }

    local timeout = 1000
    local result = vim.lsp.buf_request_sync(0, "codeAction/resolve", params, timeout)
    for _, res in pairs(result or {}) do
        if res.result and res.result.edit then
            vim.lsp.util.apply_workspace_edit(res.result.edit, client.offset_encoding)
        end
    end
end

return {
    {
        "neovim/nvim-lspconfig",
        version = "v2.x.x",
        dependencies = {
            "microsoft/python-type-stubs",
            "williamboman/mason.nvim",
            {
                "williamboman/mason-lspconfig.nvim",
                version = "v2.x.x",
            },
            {
                "j-hui/fidget.nvim",
                opts = {
                    notification = {
                        window = {
                            winblend = 0,
                        },
                    },
                },
            },
            {
                "creativenull/efmls-configs-nvim",
                version = "v1.x.x", -- version is optional, but recommended
            },
            "folke/neodev.nvim",
        },
        config = function()
            require("neodev").setup()

            local auformatgroup = vim.api.nvim_create_augroup("LspFormatting", {})
            local organizeimportgroup = vim.api.nvim_create_augroup("LspOrganizeImport", {})
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
                    map("n", "<leader>sb", builtin.lsp_document_symbols, "Document [S]ym[b]ols")
                    map("n", "<leader>ws", builtin.lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
                    map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
                    map("n", "<leader>fm", vim.lsp.buf.format, "[F]or[m]at")
                    map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
                    map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    map({ "n", "i" }, "<C-s>", vim.lsp.buf.signature_help, "[S]ignature Help")

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
                    if client and client:supports_method('textDocument/completion') then
                        vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
                    end

                    if client and client:supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = auformatgroup, buffer = event.buf })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = auformatgroup,
                            buffer = event.buf,
                            callback = function()
                                vim.lsp.buf.format()
                            end,
                        })
                    end

                    if client and client.name == "ruff" then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = organizeimportgroup,
                            buffer = event.buf,
                            callback = function()
                                code_action_resolve_request(client, "source.organizeImports.ruff")
                            end,
                        })
                    end
                end,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
                callback = function(event)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client:supports_method('textDocument/formatting') then
                        vim.api.nvim_clear_autocmds({
                            group = auformatgroup,
                        })
                    end
                    if client and client.name == "ruff" then
                        vim.api.nvim_clear_autocmds({
                            group = organizeimportgroup,
                        })
                    end
                end,
            })

            vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { standout = true })

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

            vim.lsp.config("pyright", {
                settings = {
                    pyright = {
                        disableOrganizeImports = true,
                    },
                    python = {
                        analysis = {
                            stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
                        },
                    },
                },
            })
            vim.lsp.config("ruff", {
                on_attach = function(client, bufnr)
                    if client.name == "ruff" then
                        -- Disable hover in favor of Pyright
                        client.server_capabilities.hoverProvider = false
                    end
                end,
            })
            vim.lsp.config('lua_ls', {
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if
                            path ~= vim.fn.stdpath('config')
                            and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                        then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = {
                            version = 'LuaJIT',
                            path = {
                                'lua/?.lua',
                                'lua/?/init.lua',
                            },
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME
                                -- Depending on the usage, you might want to add additional paths
                                -- here.
                                -- '${3rd}/luv/library'
                                -- '${3rd}/busted/library'
                            }
                        }
                    })
                end,
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                    },
                }
            })
            vim.lsp.config("texlab", {
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
            })
            vim.lsp.config("sqlls", {})
            vim.lsp.config("html", {
                capabilities = {
                    textDocument = { completion = { completionItem = { snippetSupport = true } } },
                },
            })
            vim.lsp.config("gopls", {})
            vim.lsp.config("elixirls", {
                cmd = { vim.fn.stdpath("data") .. "/mason/packages/elixir-ls/language_server.sh" },
            })

            require("mason").setup()

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "pyright",
                    "ruff",
                    "lua_ls",
                },
                automatic_enable = true,
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
