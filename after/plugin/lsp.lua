require("neodev").setup()


local lsp = require('lsp-zero').preset("recommended")
local mason_lspconfig = require('mason-lspconfig')

lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({ buffer = bufnr })

    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help)
end)

mason_lspconfig.setup({
    ensure_installed = {
        'pyright',
        'pylsp',
        'lua_ls',
    },
})


local lspconfig = require 'lspconfig'
lspconfig.pyright.setup {
    settings = {
        pyright = {
            analysis = {
                stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs/python-type-stubs"
            }
        }
    }
}
lspconfig.pylsp.setup {
    settings = {
        pylsp = {
            plugins = {
                -- defaults
                flake8 = { enabled = true },
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
                autoflake = { enabled = true },
                isort = {
                    enabled = true,
                    profile = "black"
                },
                black = {
                    enabled = true,
                    line_length = 79
                },
            },
            rope = {
                ropeFolder = vim.fn.getcwd() .. ".ropeproject",
            },
        }
    },
}
lspconfig.lua_ls.setup {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { 'vim' },
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
}

local format_option = {
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    servers = {
        ['lua_ls'] = { 'lua' },
        ['pylsp'] = { 'python' },
    }
}

lsp.format_on_save(format_option)
lsp.format_mapping('<C-l>', format_option)

lsp.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
})

lsp.setup()


local cmp = require('cmp')
local compare = require('cmp.config.compare')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local lspkind = require('lspkind')

lspkind.init({
    symbol_map = {
        Copilot = "",
    },
})

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)

local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

cmp.setup({
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'buffer',  keyword_length = 3 },
        { name = 'luasnip', keyword_length = 2 },
        -- { name = 'copilot' },
    },
    mapping = {
        ['<CR>'] = cmp.mapping.confirm(),
        ['<C-A>'] = cmp.mapping.complete(),
        ['<Tab>'] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
                fallback()
            end
        end),
        ['<S-Tab>'] = cmp_action.select_prev_or_fallback(),
        ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
        ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
        ['<C-j>'] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                else
                    vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
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
        ['<C-k>'] = cmp.mapping({
            c = function()
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                else
                    vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
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
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    },
    preselect = 'item',
    completion = {
        completeopt = 'menu,menuone,noinsert',
        side_padding = 5,
    },
    formatting = {
        format = function(entry, vim_item)
            if vim.tbl_contains({ 'path' }, entry.source.name) then
                local icon, hl_group = require('nvim-web-devicons').get_icon(entry:get_completion_item().label)
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
            compare.locality,
            compare.recently_used,
            compare.score,
            compare.offset,
            compare.order,
            -- compare.scopes,
            -- compare.sort_text,
            -- compare.exact,
            -- compare.kind,
            -- compare.length,
        }
    }
})


vim.diagnostic.config({
    virtual_text = {
        source = true,
    },
    float = {
        source = true,
    },
})
