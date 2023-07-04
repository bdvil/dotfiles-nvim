require("neodev").setup()


local lsp = require('lsp-zero').preset("recommended")

lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
end)

lsp.ensure_installed({
    'pyright',
})

local lspconfig = require 'lspconfig'
lspconfig.pyright.setup {
    settings = {
        pyright = {
            stubPath = vim.fn.stdpath("data") .. "site/pack/packer/start/python-type-stubs"
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
        ['null-ls'] = { 'python' },
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
        { name = 'copilot' },
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
    }
})


local null_ls = require('null-ls')
-- local null_ls_helpers = require('null-ls.helpers')

local builtin = require("telescope.builtin")
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"


local find_and_return_file = function(callback)
    builtin.find_files({
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selected = action_state.get_selected_entry()
                callback(selected[1])
            end)
            return true
        end
        ,
    })
end

local path_to_module = function(path)
    path = path:gsub(".py", ""):gsub("/", ".")
    return path
end

local pyro_source = {
    name = "pyro",
    filetypes = { "python" },
    method = null_ls.methods.CODE_ACTION,
    generator = {
        fn = function(params)
            local project_root = vim.fn.getcwd()
            if project_root:sub(-1) ~= "/" then
                project_root = project_root .. "/"
            end
            local current_module = params.bufname:gsub(project_root, "")
            current_module = path_to_module(current_module)

            local cmd = string.format(
                "pyro move %s %s %d %d",
                project_root,
                current_module,
                params.row,
                params.col + 1
            )
            return {
                {
                    title = "Move Symbol",
                    action = function()
                        find_and_return_file(
                            function(target_module)
                                target_module = target_module:gsub(project_root, "")
                                target_module = path_to_module(target_module)
                                print(string.format("%s %s", cmd, target_module))
                            end
                        )
                    end,
                }
            }
        end,
    },
}

null_ls.setup({
    debug = true,
    sources = {
        null_ls.builtins.diagnostics.flake8,
        null_ls.builtins.formatting.autoflake.with({
            extra_args = { "--remove-all-unused-imports" }
        }),
        null_ls.builtins.formatting.isort.with({
            extra_args = { "--profile=black" }
        }),
        null_ls.builtins.formatting.black.with({
            extra_args = { "--line-length=79" }
        }),
        -- pyro_source,
    }
})
-- null_ls.register(pyro_source)

require("mason-null-ls").setup({
    ensure_installed = { "autoflake", "isort", "flake8", "black" },
    automatic_installation = true,
})
