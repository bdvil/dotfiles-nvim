vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set({ "n", "x", "v" }, "(", "[", { remap = true })
vim.keymap.set({ "n", "x", "v" }, ")", "]", { remap = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("x", "<leader>p", '"_dP')

vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

vim.keymap.set("n", "<C-w>o", ":mksession! ~/.session.nvim<CR>:wincmd o<CR>")
vim.keymap.set("n", "<C-w>u", ":source ~/.session.nvim<CR>")

vim.keymap.set("n", "<C-Left>", "<C-w>h")
vim.keymap.set("n", "<C-Right>", "<C-w>l")
vim.keymap.set("n", "<C-Up>", "<C-w>k")
vim.keymap.set("n", "<C-Down>", "<C-w>j")

-- Terminal
vim.keymap.set("t", "<ESC>", "<C-\\><C-N>")
vim.keymap.set("t", "<A-h>", "<C-\\><C-N><C-w>h")
