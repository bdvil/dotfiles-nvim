local builtin = require("telescope.builtin")
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"


local find_and_return_file = function(callback)
    builtin.find_files({
        attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selected = action_state.get_selected_entry()
                callback(selected[1])
            end)
            return true
        end
        ,
    })
end

local path_to_module = function(path)
    path = path:gsub(".py", ""):gsub("/", ".")
    return path
end

local function execute_command(command)
    local output = vim.fn.system(command)
    return vim.json.decode(output or "{}", {})
end

local function set_quickfix(modified_files)
    local quickfix_list = {}
    for _, file_info in ipairs(modified_files) do
        local filename = file_info.filename
        table.insert(quickfix_list, { filename = filename, lnum = 1 })
    end
    vim.fn.setqflist({}, 'r', { title = 'Modified Files', items = quickfix_list })
end

local function update_files(edited_files)
    local current_win = vim.fn.win_getid()
    for _, file_info in ipairs(edited_files) do
        local bufnr = vim.fn.bufnr(file_info.filename)
        if bufnr ~= nil and bufnr > 0 then
            local win = vim.fn.bufwinid(bufnr)
            vim.fn.win_gotoid(win)
            vim.cmd('edit ' .. file_info.filename)
        end
    end
    vim.fn.win_gotoid(current_win)
end

local move_symbol = function(opt)
    local default_opts = {
        pyro_bin = "pyro",
    }

    opt = opt or default_opts

    local project_root = vim.fn.getcwd() or "./"
    if project_root:sub(-1) ~= "/" then
        project_root = project_root .. "/"
    end
    local bufname = vim.api.nvim_buf_get_name(0)
    local current_module = bufname:gsub(project_root, "")
    current_module = path_to_module(current_module)

    local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))

    local cmd = string.format(
        "%s move %s %s %d %d",
        opt.pyro_bin,
        project_root,
        current_module,
        cursor_row,
        cursor_col
    )

    find_and_return_file(
        function(target_module)
            target_module = target_module:gsub(project_root, "")
            target_module = path_to_module(target_module)
            local command = string.format("%s %s", cmd, target_module)
            vim.cmd("write")
            local output = execute_command(command)
            if output ~= nil and output["success"] ~= nil and output["success"] then
                set_quickfix(output["editedFiles"] or {})
                update_files(output["editedFiles"] or {})
            end
            if output ~= nil and output["success"] ~= nil and not output["success"] then
                print(output["errorMsg"])
            end
        end
    )
end

return move_symbol
