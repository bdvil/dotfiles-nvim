return {
    "folke/zen-mode.nvim",
    opts = {
        window = {
            width = 120,

            options = {
                wrap = true,
                linebreak = true,
                colorcolumn = "",
            },
        },
    },
    config = function(plugin, opts)
        local zen_mode = require("zen-mode")
        zen_mode.setup(opts)

        vim.keymap.set("n", "<leader>zm", function()
            zen_mode.toggle()
        end)
    end,
}
