return {
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        lazy = true,
		-- install jsregexp (optional!).
		build = "make install_jsregexp",

		dependencies = { "rafamadriz/friendly-snippets" },

		config = function() require("luasnip.loaders.from_vscode").lazy_load()
			local ls = require("luasnip")
            ls.filetype_extend("javascript", { "jsdoc" })
            require("theprimeagen.snippets.js-snippets")

			--- TODO: What is expand?
			vim.keymap.set({ "i" }, "<C-s>e", function()
				ls.expand()
			end, { silent = true, desc="Expand snippet" })

			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				ls.jump(1)
			end, { silent = true, desc="Jump to next field"})
			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				ls.jump(-1)
			end, { silent = true, desc="Jump to previous field"})

			vim.keymap.set({ "i", "s" }, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { silent = true, desc="Change choice"})

		end,
	},
}
