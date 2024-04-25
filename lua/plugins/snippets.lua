return {
    {
        "L3MON4D3/LuaSnip",
        lazy = false,
        dependencies = { "saadparwaiz1/cmp_luasnip" },
        config = function()
            local lua_snip = require("luasnip")

            vim.keymap.set({ "i", "s" }, "<C-E>", function()
                lua_snip.expand()
            end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-F>", function()
                lua_snip.jump(1)
            end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-D>", function()
                lua_snip.jump(-1)
            end, { silent = true })
            vim.keymap.set({ "i", "s" }, "<C-O>", function()
                if lua_snip.choice_active() then
                    lua_snip.change_choice(1)
                end
            end, { silent = true })
        end,
    },
}
