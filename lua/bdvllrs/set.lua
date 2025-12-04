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

vim.opt.colorcolumn = "88"

vim.opt.eol = true

vim.g.python3_host_prog = os.getenv("NVIM_PYTHON_HOST")
vim.g.node_host_prog = os.getenv("NVIM_NODE_HOST")

vim.opt.autoread = true

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
vim.cmd.colorscheme("catppuccin")
-- add setting to show non-breaking space character
vim.opt.list = true
vim.opt.listchars = { nbsp = "␣", tab = ">-", trail = "·", extends = "↩" }

vim.filetype.add({
    extension = {
        jinja = "jinja",
        jinja2 = "jinja",
        j2 = "jinja",
    },
})

vim.treesitter.language.register("html", "jinja")

vim.api.nvim_create_user_command("OpenInMousepad", function(opts)
    local start_line = opts.line1
    local end_line = opts.line2
    vim.cmd(string.format("%d,%dw! /tmp/nvim_clip.txt", start_line, end_line))
    vim.fn.jobstart({ "mousepad", "/tmp/nvim_clip.txt" }, { detach = true })
end, { range = true })

vim.keymap.set("v", "<leader>y", ":OpenInMousepad<CR>", { desc = "Open in Mousepad editor for copy" })
