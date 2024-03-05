require("luasnip.session.snippet_collection").clear_snippets("python")

local ls = require("luasnip")
local fmta = require("luasnip.extras.fmt").fmta
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local function same_text(args, _, _)
	return args[1][1]
end

local function get_param_name_and_type(node)
	local node_name = "?"
	local node_type = "Any"
	if node:type() == "identifier" then
		node_name = vim.treesitter.get_node_text(node, 0)
	else
		for child in node:iter_children() do
			if child:type() == "identifier" then
				node_name = vim.treesitter.get_node_text(child, 0)
			elseif child:type() == "type" then
				node_type = vim.treesitter.get_node_text(child, 0)
			end
		end
	end
	return { name = node_name, type = node_type }
end

local param_handlers = {
	typed_parameter = function(node)
		return get_param_name_and_type(node)
	end,
	identifier = function(node)
		local param = get_param_name_and_type(node)
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
		return { return_type = vim.treesitter.get_node_text(node, 0) }
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
			table.insert(sn_nodes, t({ "", "    " .. arg.name .. " (`" }))
			table.insert(sn_nodes, i(idx, arg.type))
			table.insert(sn_nodes, t("`): "))
			table.insert(sn_nodes, i(idx + 1))
			idx = idx + 2
		end
	end
	if nodes["return_type"] then
		table.insert(sn_nodes, t({ "", "Returns:", "    `" }))
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
			table.insert(sn_nodes, i(idx, arg.name))
			table.insert(sn_nodes, t(" = "))
			table.insert(sn_nodes, t(arg.name))
			idx = idx + 1
		end
	end
	return { nodes = sn_nodes, next_idx = idx }
end

local function python_docstring(_)
	local nodes = parse_python_funcdef()
	local sn_nodes = make_docstring_args_snippets(1, nodes)
	if sn_nodes then
		return sn(nil, sn_nodes.nodes)
	else
		return sn(nil, { i(1) })
	end
end

local function python_self_props(_)
	local nodes = parse_python_funcdef()
	local sn_nodes = make_define_self_props_snippets(1, nodes)
	if sn_nodes then
		return sn(nil, sn_nodes.nodes)
	else
		return sn(nil, { i(1) })
	end
end

ls.add_snippets("python", {
	s("prop", {
		t("self."),
		f(same_text, { 1 }, {}),
		t(" = "),
		i(1),
	}),
	s("props", {
		d(1, python_self_props),
		i(0),
	}),

	s(
		"docstring",
		fmta(
			[[
"""<start>
    <params>
"""<finish>
        ]],
			{
				start = i(1),
				params = d(2, python_docstring),
				finish = i(0),
			}
		)
	),
})
