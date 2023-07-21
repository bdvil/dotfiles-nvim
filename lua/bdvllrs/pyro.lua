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

local move_symbol = function()
    local project_root = vim.fn.getcwd()
    if project_root:sub(-1) ~= "/" then
        project_root = project_root .. "/"
    end
    local bufname = vim.api.nvim_buf_get_name(0)
    local current_module = bufname:gsub(project_root, "")
    current_module = path_to_module(current_module)

    local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))

    local cmd = string.format(
        "pyro move %s %s %d %d",
        project_root,
        current_module,
        cursor_row,
        cursor_col + 1
    )

    find_and_return_file(
        function(target_module)
            target_module = target_module:gsub(project_root, "")
            target_module = path_to_module(target_module)
            local command = string.format("%s %s", cmd, target_module)
            vim.cmd(string.format("silent w !%s", command))
        end
    )
end

return move_symbol
