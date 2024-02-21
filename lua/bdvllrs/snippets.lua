local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node


local function same_text(args, _, _)
    return args[1][1]
end

ls.add_snippets("python", {
    s("ap", {
        t("self."), f(same_text, { 1 }, {}), t(" = "), i(1)
    })
})
