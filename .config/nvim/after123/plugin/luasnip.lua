local ls = require("luasnip")
-- some shorthands...
local s = ls.snippet
local n = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node
local extras = require("luasnip.extras")

local function fn(
	args, -- text from i(2) in this example i.e. { { "456" } }
	parent, -- parent snippet or parent node
	user_args -- user_args from opts.user_args
)
    return vim.api.nvim_exec([[echo getreg(']].. '0' ..[[')]], true):gsub("[\n\r]", "^J"):gsub(" ","")
end
ls.add_snippets(nil, {
	javascript = {
		s("cly", {
            t("console.log('"),
            i(1),
            f(
                fn, -- callback (args, parent, user_args) -> string
                { 1 }, -- node indice(s) whose text is passed to fn, i.e. i(2)
                { user_args = { "user_args_value" } } -- opts
            ),
            t(":', "),
            f(
                fn, -- callback (args, parent, user_args) -> string
                { 1 }, -- node indice(s) whose text is passed to fn, i.e. i(2)
                { user_args = { "user_args_value" } } -- opts
            ),
			-- extras.rep(1),
            t(");"),
		}),
		s({
			trig = "clg",
			namr = "console_log",
			dscr = "Console log variable",
		}, {
			t("console.log('"),
			i(1, "variable"),
			t(":', "),
			extras.rep(1),
			t(");"),
		}),
	},
})
ls.filetype_extend("typescript", {"javascript"})
