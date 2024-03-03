return {
    "microsoft/python-type-stubs",
    "onsails/lspkind.nvim",
    "folke/neodev.nvim",

    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "neovim/nvim-lspconfig",
            {
                "williamboman/mason.nvim",
                build = ":MasonUpdate",
            },
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            {
                "L3MON4D3/LuaSnip",
                lazy = false,
                dependencies = { "saadparwaiz1/cmp_luasnip" },
            },
            "j-hui/fidget.nvim",
        },
        config = function()
            require("fidget").setup({})

            local lsp_zero = require("lsp-zero")

            lsp_zero.on_attach(function(_, bufnr)
                lsp_zero.default_keymaps({ buffer = bufnr })

                vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help)
            end)

            local format_option = {
                format_opts = {
                    async = false,
                    timeout_ms = 10000,
                },
                servers = {
                    ["lua_ls"] = { "lua" },
                    ["pylsp"] = { "python" },
                    ["texlab"] = { "tex" },
                }
            }

            lsp_zero.format_on_save(format_option)
            lsp_zero.format_mapping("<C-l>", format_option)

            lsp_zero.set_sign_icons({
                error = "✘",
                warn = "▲",
                hint = "⚑",
                info = "»"
            })

            require("mason").setup()
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")

            mason_lspconfig.setup({
                ensure_installed = {
                    "pyright",
                    "pylsp",
                    "lua_ls",
                    "texlab",
                    "sqlls",
                },
                handlers = {
                    lsp_zero.default_setup(),
                    pyright = function()
                        lspconfig.pyright.setup({
                            settings = {
                                pyright = {
                                    analysis = {
                                        stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs/python-type-stubs"
                                    }
                                }
                            }
                        })
                    end,
                    pylsp = function()
                        lspconfig.pylsp.setup({
                            settings = {
                                pylsp = {
                                    plugins = {
                                        -- defaults
                                        flake8 = {
                                            enabled = true,
                                        },
                                        autopep8 = { enabled = false },
                                        yapf = { enabled = false },
                                        pyflakes = { enabled = false },
                                        jedi_completion = { enabled = false },
                                        jedi_definition = { enabled = false },
                                        jedi_hover = { enabled = false },
                                        jedi_references = { enabled = false },
                                        jedi_symbols = { enabled = false },
                                        mccade = { enabled = false },
                                        preload = { enabled = false },
                                        pycodestyle = { enabled = false },
                                        rope_autoimport = { enabled = false },
                                        -- added with :PylspInstall
                                        autoflake = { enabled = false },
                                        isort = {
                                            enabled = false,
                                            profile = "black"
                                        },
                                        black = {
                                            enabled = false,
                                            line_length = 88
                                        },
                                    },
                                    rope = {
                                        enabled = false,
                                        ropeFolder = vim.fn.getcwd() .. ".ropeproject",
                                    },
                                }
                            },
                        })
                    end,
                    lua_ls = function()
                        lspconfig.lua_ls.setup({
                            settings = {
                                Lua = {
                                    runtime = {
                                        version = "LuaJIT",
                                    },
                                    diagnostics = {
                                        globals = { "vim" },
                                    },
                                    workspace = {
                                        library = vim.api.nvim_get_runtime_file("", true),
                                        checkThirdParty = false,
                                    },
                                    telemetry = {
                                        enable = false,
                                    },
                                }
                            }
                        })
                    end,
                    texlab = function()
                        lspconfig.texlab.setup({
                            settings = {
                                texlab = {
                                    rootDirectory = nil,
                                    build = {
                                        executable = "latexmk",
                                        onSave = true
                                    },
                                    chktex = {
                                        onOpenAndSave = true
                                    },
                                    bibtexFormatter = "latexindent",
                                    latexFormatter = "latexindent",
                                    latexindent = {
                                        modifyLineBreaks = true,
                                    },
                                }
                            }
                        })
                    end,
                    sqlls = function()
                        lspconfig.sqlls.setup({})
                    end,
                }
            })

            local lua_snip = require("luasnip")

            vim.keymap.set({ "i", "s" }, "<C-k>", function() lua_snip.expand() end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-l>", function() lua_snip.jump(1) end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-h>", function() lua_snip.jump(-1) end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-j>", function()
                if lua_snip.choice_active() then
                    lua_snip.change_choice(1)
                end
            end, { silent = true })

            local cmp = require("cmp")
            local compare = require("cmp.config.compare")
            local cmp_action = require("lsp-zero").cmp_action()
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local lspkind = require("lspkind")

            lspkind.init({
                symbol_map = {
                    Copilot = "",
                },
            })

            vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

            cmp.event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done()
            )

            local has_words_before = function()
                if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
            end

            cmp.setup({
                sources = {
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "path" },
                    { name = "buffer",                 keyword_length = 3 },
                    -- { name = "copilot" },
                },
                mapping = {
                    ["<CR>"] = cmp.mapping.confirm(),
                    ["<C-A>"] = cmp.mapping.complete(),
                    ["<Tab>"] = vim.schedule_wrap(function(fallback)
                        if cmp.visible() and has_words_before() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end),
                    ["<S-Tab>"] = cmp_action.select_prev_or_fallback(),
                    ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                        { "i" }),
                    ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                        { "i" }),
                    ["<C-j>"] = cmp.mapping({
                        c = function()
                            if cmp.visible() then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                vim.api.nvim_feedkeys(t("<Down>"), "n", true)
                            end
                        end,
                        i = function(fallback)
                            if cmp.visible() then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                fallback()
                            end
                        end
                    }),
                    ["<C-k>"] = cmp.mapping({
                        c = function()
                            if cmp.visible() then
                                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                vim.api.nvim_feedkeys(t("<Up>"), "n", true)
                            end
                        end,
                        i = function(fallback)
                            if cmp.visible() then
                                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                fallback()
                            end
                        end
                    }),
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                },
                preselect = "item",
                completion = {
                    completeopt = "menu,menuone,noinsert",
                    side_padding = 5,
                },
                formatting = {
                    format = function(entry, vim_item)
                        if vim.tbl_contains({ "path" }, entry.source.name) then
                            local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item()
                                .label)
                            if icon then
                                vim_item.kind = icon
                                vim_item.kind_hl_group = hl_group
                                return vim_item
                            end
                        end
                        return lspkind.cmp_format({
                            mode = "symbol_text",
                            with_text = false,
                            max_width = 50,
                        })(entry, vim_item)
                    end
                },
                sorting = {
                    priority_weight = 1.0,
                    comparators = {
                        compare.offset,
                        compare.exact,
                        compare.score,
                        compare.scopes,
                        compare.locality,
                        compare.recently_used,
                        compare.order,
                        -- compare.sort_text,
                        compare.kind,
                        -- compare.length,
                    }
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end
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
        end

    },
}
