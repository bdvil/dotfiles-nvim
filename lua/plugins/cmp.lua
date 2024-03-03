return {

    {
        "hrsh7th/nvim-cmp",
        event = 'InsertEnter',
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                lazy = false,
                dependencies = { "saadparwaiz1/cmp_luasnip" },
            },
            "hrsh7th/cmp-nvim-lsp",
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-path',
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp = require("cmp")
            local compare = require("cmp.config.compare")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local lspkind = require("lspkind")

            lspkind.init({})

            vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

            cmp.event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done()
            )

            local luasnip = require('luasnip')
            luasnip.config.setup({})

            cmp.setup({
                sources = {
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "path" },
                    { name = "buffer", keyword_length = 3 },
                },
                mapping = {
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-y>'] = cmp.mapping.confirm { select = true },
                    ["<C-A>"] = cmp.mapping.complete(),
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                    ['<C-l>'] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { 'i', 's' }),
                    ['<C-h>'] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { 'i', 's' }),
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
        end,
    },
}
