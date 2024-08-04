local ls = require("luasnip")
local s = ls.snippet
local n = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local choice = ls.choice_node
local dynamic = ls.dynamic_node
local extras = require("luasnip.extras")

local function getLastRegister(
	args, -- text from i(2) in this example i.e. { { "456" } }
	parent, -- parent snippet or parent node
	user_args -- user_args from opts.user_args
)
	return vim.api
		.nvim_exec2([[echo getreg(']] .. "0" .. [[')]], { output = true }).output
		:gsub("[\n\r]", "^J")
		:gsub(" ", "")
end

ls.add_snippets(nil, {
	javascript = {
		s("clg", {
			t("console.log('"),
			i(1),
			f(
				getLastRegister, -- callback (args, parent, user_args) -> string
				{ 1 }, -- node indice(s) whose text is passed to fn, i.e. i(2)
				{ user_args = { "user_args_value" } } -- opts
			),
			t(":', "),
			f(
				getLastRegister, -- callback (args, parent, user_args) -> string
				{ 1 }, -- node indice(s) whose text is passed to fn, i.e. i(2)
				{ user_args = { "user_args_value" } } -- opts
			),
			-- extras.rep(1),
			t(");"),
		}),
		s({
			trig = "clo",
			namr = "console_log",
			dscr = "Console log variable",
            priority = 200000,
		}, {
			t("console.log('"),
			extras.rep(1),
			t(":', "),
			i(1, "variable"),
			t(");"),
		}),
        s({
            trig = "cl",
            name = "console.log",
            dscr = "Console log",
            priority = 200000,
        }, {
            t("console.log('"),
            i(1, "Test1"),
            t("');"),
        }),
	},
})
ls.filetype_extend("typescriptreact", { "javascript" })
ls.filetype_extend("javascriptreact", { "javascript" })
ls.filetype_extend("typescript", { "javascript" })

ls.add_snippets("javascript", {
	s("tdf", {
		t({ "/**", " * @typedef {Object} " }),
		i(1, "TypeName"),
		t({ "", " * @property {" }),
		i(2, "type"),
		t("} "),
		i(3, "propertyName"),
		t({ "", " * @property {" }),
		i(4, "type"),
		t("} "),
		i(5, "propertyName"),
		t({ "", " */", "" }),
	}),
})
