LaunchPyrefactorLSP = function()
    local client_id = vim.lsp.start({
        name = "pyrefactorlsp",
        cmd = vim.lsp.rpc.connect("127.0.0.1", 8989),
        root_dir = vim.fs.dirname(vim.fs.find({ "pyproject.toml", "setup.py" }, { upward = true })[1]),
    })
    vim.lsp.buf_attach_client(0, client_id)
end

vim.cmd([[
  command! -range LaunchPyrefactorLSP  execute 'lua LaunchPyrefactorLSP()'
]])
