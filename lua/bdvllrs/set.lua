vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.breakindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false -- remove highlight search results
vim.opt.incsearch = true -- incremental searching

vim.opt.cursorline = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8 -- number of lines to keep around the cursor
vim.opt.signcolumn = "yes"

vim.opt.isfname:append("@-@")

vim.opt.updatetime = 250
vim.opt.timeoutlen = 500

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.colorcolumn = "88"

vim.opt.eol = true

vim.g.python3_host_prog = os.getenv("NVIM_PYTHON_HOST")
vim.g.node_host_prog = os.getenv("NVIM_NODE_HOST")

vim.opt.autoread = true


vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking text',
    group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
