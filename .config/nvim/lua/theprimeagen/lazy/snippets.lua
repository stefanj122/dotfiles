return {
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",

		dependencies = { "rafamadriz/friendly-snippets" },

		config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
			local ls = require("luasnip")
			local s = ls.snippet
			local n = ls.snippet_node
			local t = ls.text_node
			local i = ls.insert_node
			local f = ls.function_node
			local choice = ls.choice_node
			local dynamicn = ls.dynamic_node
			local extras = require("luasnip.extras")

			ls.filetype_extend("javascript", { "jsdoc" })
			local function fn(
				args, -- text from i(2) in this example i.e. { { "456" } }
				parent, -- parent snippet or parent node
				user_args -- user_args from opts.user_args
			)
				return vim.api.nvim_exec([[echo getreg(']] .. "0" .. [[')]], true):gsub("[\n\r]", "^J"):gsub(" ", "")
			end

			--- TODO: What is expand?
			vim.keymap.set({ "i" }, "<C-s>e", function()
				ls.expand()
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<C-s>;", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-s>,", function()
				ls.jump(-1)
			end, { silent = true })

			vim.keymap.set({ "i", "s" }, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { silent = true })

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
			ls.filetype_extend("typescriptreact", { "javascript" })
			ls.filetype_extend("javascriptreact", { "javascript" })
			ls.filetype_extend("typescript", { "javascript" })
		end,
	},
}
