vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false -- remove highlight search results
vim.opt.incsearch = true -- incremental searching

vim.opt.termguicolors = true

vim.opt.scrolloff = 8 -- number of lines to keep around the cursor
vim.opt.signcolumn = "yes"

vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "79"

-- vim.opt.ff = "unix"
-- vim.opt.fixeol = true

vim.g.mapleader = " "

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufWritePost" }, {
    pattern = "*",
    command = "setl ff=unix fixeol"
})
