local client_id = nil


StartPyrefactorLSP = function()
    client_id = vim.lsp.start({
        name = "pyrefactorlsp",
        cmd = vim.lsp.rpc.connect("127.0.0.1", 8989),
        root_dir = vim.fs.dirname(vim.fs.find({ "pyproject.toml", "setup.py" }, { upward = true })[1]),
    })
    vim.lsp.buf_attach_client(0, client_id)
end

StopPyrefactorLSP = function()
    if client_id then
        vim.lsp.buf_detach_client(0, client_id)
        vim.lsp.stop_client(client_id)
        client_id = nil
    end
end

vim.cmd([[
  command! -range StartPyrefactorLSP  execute 'lua StartPyrefactorLSP()'
]])
vim.cmd([[
  command! -range StopPyrefactorLSP  execute 'lua StopPyrefactorLSP()'
]])
