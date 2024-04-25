require("luasnip.session.snippet_collection").clear_snippets("python")

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local c = ls.choice_node

local function same_text(args, _, _)
    return args[1][1]
end

local function get_type_text(node)
    local node_type = vim.treesitter.get_node_text(node, 0)
    node_type = string.gsub(node_type, "\n", "")
    node_type = string.gsub(node_type, "%s+", " ")
    node_type = string.gsub(node_type, "\t", "")
    return node_type
end

local function get_param_name_and_type(node, default_type)
    local node_name = "?"
    local node_type = default_type
    if node:type() == "identifier" then
        node_name = vim.treesitter.get_node_text(node, 0)
    else
        for child in node:iter_children() do
            if child:type() == "dictionary_splat_pattern" or child:type() == "list_splat_pattern" then
                node_name = get_param_name_and_type(child, default_type).name
            elseif child:type() == "identifier" then
                node_name = vim.treesitter.get_node_text(child, 0)
            elseif child:type() == "type" then
                node_type = get_type_text(child)
            end
        end
    end
    return { name = node_name, type = node_type }
end

local param_handlers = {
    typed_parameter = function(node)
        return get_param_name_and_type(node, "Any")
    end,
    typed_default_parameter = function(node)
        return get_param_name_and_type(node, "Any")
    end,
    list_splat_pattern = function(node)
        return get_param_name_and_type(node, nil)
    end,
    dictionary_splat_pattern = function(node)
        return get_param_name_and_type(node, nil)
    end,
    identifier = function(node)
        local param = get_param_name_and_type(node, "Any")
        if param.name == "self" then
            return nil
        end

        return param
    end,
}

local handlers = {
    parameters = function(node)
        local sn_nodes = {}
        local count = node:child_count()
        for idx = 0, count - 1 do
            local child = node:child(idx)
            if param_handlers[child:type()] then
                local param_node = param_handlers[child:type()](child)
                if param_node then
                    table.insert(sn_nodes, param_node)
                end
            end
        end
        return { args = sn_nodes }
    end,
    type = function(node)
        local node_type = get_type_text(node)
        return { return_type = node_type }
    end,
}

local function parse_python_funcdef()
    local node = vim.treesitter.get_node()
    while node ~= nil do
        if node:type() == "function_definition" then
            break
        end

        node = node:parent()
    end

    if not node then
        vim.notify("Not inside of a function")
        return nil
    end

    local query = assert(vim.treesitter.query.get("python", "func-docstring-snippet"), "Not query")

    local sn_nodes = {}

    for _, capture in query:iter_captures(node, 0) do
        if handlers[capture:type()] then
            local nodes = handlers[capture:type()](capture)
            sn_nodes = vim.tbl_extend("force", sn_nodes, nodes)
        end
    end

    return sn_nodes
end

-- vim.keymap.set("n", "<leader>tq", function()
-- 	print(vim.inspect(parse_python_funcdef()))
-- end)

local function make_docstring_args_snippets(idx, nodes)
    local sn_nodes = {}
    if next(nodes.args) ~= nil then
        table.insert(sn_nodes, t({ "", "Args:" }))
    end

    if nodes["args"] then
        for _, arg in ipairs(nodes.args) do
            table.insert(sn_nodes, t({ "", "    " .. arg.name }))
            if arg.type then
                table.insert(sn_nodes, t({ " (`" }))
                table.insert(sn_nodes, i(idx, arg.type))
                table.insert(sn_nodes, t("`)"))
                idx = idx + 1
            end
            table.insert(sn_nodes, t(": "))
            table.insert(sn_nodes, i(idx))
            idx = idx + 1
        end
    end
    if nodes["return_type"] then
        table.insert(sn_nodes, t({ "", "", "Returns:", "    `" }))
        table.insert(sn_nodes, i(idx, nodes.return_type))
        table.insert(sn_nodes, t("`: "))
        table.insert(sn_nodes, i(idx + 1))
    end
    return { nodes = sn_nodes, next_idx = idx + 2 }
end

local function make_define_self_props_snippets(idx, nodes)
    local sn_nodes = {}

    if nodes["args"] then
        for k, arg in ipairs(nodes.args) do
            if k == 1 then
                table.insert(sn_nodes, t("self."))
            else
                table.insert(sn_nodes, t({ "", "self." }))
            end
            table.insert(sn_nodes, f(same_text, { idx }))
            table.insert(sn_nodes, t(" = "))
            table.insert(sn_nodes, i(idx, arg.name))
            idx = idx + 1
        end
    end
    return { nodes = sn_nodes, next_idx = idx }
end

local function python_parse_prop()
    local sn_nodes = {}
    local nodes = parse_python_funcdef()

    if nodes["args"] then
        for _, arg in ipairs(nodes.args) do
            local prop_group = {}
            table.insert(prop_group, t("self."))
            table.insert(prop_group, f(same_text, { 1 }))
            table.insert(prop_group, t(" = "))
            table.insert(prop_group, i(1, arg.name))
            table.insert(sn_nodes, sn(nil, prop_group))
        end
    end
    return sn(nil, { c(1, sn_nodes) })
end

local function python_argdoc()
    local nodes = parse_python_funcdef()

    local sn_nodes = {}
    if nodes["args"] then
        for _, arg in ipairs(nodes.args) do
            local arg_group = {}
            local idx = 1
            table.insert(arg_group, t({ arg.name }))
            if arg.type then
                table.insert(arg_group, t({ " (`" }))
                table.insert(arg_group, i(idx, arg.type))
                table.insert(arg_group, t("`)"))
                idx = idx + 1
            end
            table.insert(arg_group, t(": "))
            table.insert(arg_group, i(idx))
            table.insert(sn_nodes, sn(nil, arg_group))
        end
    end
    return sn(nil, { c(1, sn_nodes) })
end

local function python_returndoc()
    local nodes = parse_python_funcdef()

    local sn_nodes = {}
    if nodes["return_type"] then
        table.insert(sn_nodes, t({ "Returns:", "    `" }))
        table.insert(sn_nodes, i(1, nodes.return_type))
        table.insert(sn_nodes, t("`: "))
        table.insert(sn_nodes, i(2))
    end
    return sn(nil, sn_nodes)
end

local function python_parse_snippets(build_snippets_fn)
    return function()
        local nodes = parse_python_funcdef()
        local sn_nodes = build_snippets_fn(1, nodes)
        local out_node
        if sn_nodes then
            out_node = sn(nil, sn_nodes.nodes)
        else
            out_node = sn(nil, { i(1) })
        end
        return out_node
    end
end

ls.add_snippets("python", {
    s("propcustom", {
        t("self."),
        f(same_text, { 1 }, {}),
        t(" = "),
        i(1),
    }),
    s("prop", {
        d(1, python_parse_prop),
        i(0),
    }),
    s("props", {
        d(1, python_parse_snippets(make_define_self_props_snippets)),
        i(0),
    }),
    s("argdoc", {
        d(1, python_argdoc),
        i(0),
    }),
    s("returndoc", {
        d(1, python_returndoc),
        i(0),
    }),
    s("docstring", {
        t({ '"""', "" }),
        i(1),
        t({ "", "" }),
        d(2, python_parse_snippets(make_docstring_args_snippets)),
        t({ "", "" }),
        t('"""'),
        i(0),
    }),
})
