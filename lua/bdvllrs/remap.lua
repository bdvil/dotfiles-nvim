vim.keymap.set({ "n", "x", "v" }, "(", "[", { remap = true })
vim.keymap.set({ "n", "x", "v" }, ")", "]", { remap = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("x", "<leader>p", "\"_dP")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

vim.keymap.set("n", "<C-w>o", ":mksession! ~/.session.nvim<CR>:wincmd o<CR>")
vim.keymap.set("n", "<C-w>u", ":source ~/.session.nvim<CR>")

-- Terminal
vim.keymap.set("t", "<ESC>", "<C-\\><C-N>")
vim.keymap.set("t", "<A-h>", "<C-\\><C-N><C-w>h")


-- flash
local flash = require('flash')

vim.keymap.set({ "n", "x", "o" }, "<leader>s", function()
    flash.jump({
        search = {
            mode = function(str)
                return "\\<" .. str
            end,
        },
    })
end)
vim.keymap.set({ "n", "x", "o" }, "<leader>S", function() flash.treesitter() end)
vim.keymap.set("o", "<leader>r", function() flash.remote() end)
vim.keymap.set({ "n", "x", "o" }, "<leader>R", function() flash.treesitter_search() end)

-- pyro
local move_symbol = require("bdvllrs.pyro")
vim.keymap.set("n", "<leader>m", function()
    move_symbol({ pyro_bin = os.getenv("PYRO_BIN") })
end, { silent = true, noremap = true })
