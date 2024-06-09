return {
	{
		"nvim-telescope/telescope.nvim",

		tag = "0.1.6",

		dependencies = {
			"nvim-lua/plenary.nvim",
		},

		config = function()
			require("telescope").setup({})

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
			vim.keymap.set("n", "gr", builtin.lsp_references, {})
			vim.keymap.set("n", "<leader>ph", builtin.spell_suggest, {})
			vim.keymap.set("n", "<leader>pc", builtin.git_bcommits, {})
			vim.keymap.set("n", "<leader>pt", builtin.treesitter, {})
			vim.keymap.set("n", "<C-p>", builtin.git_files, {})
			vim.keymap.set("n", "<leader>pws", function()
				local word = vim.fn.expand("<cword>")
				builtin.grep_string({ search = word })
			end)
			vim.keymap.set("n", "<leader>pWs", function()
				local word = vim.fn.expand("<cWORD>")
				builtin.grep_string({ search = word })
			end)
			vim.keymap.set("n", "<leader>ps", function()
				builtin.grep_string({ search = vim.fn.input("Grep > ") })
			end)
			vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
		end,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			vim.keymap.set("n", "<leader>pv", function()
				require("telescope").extensions.file_browser.file_browser({ path="%:p:h", select_buffer=true, hidden = true })
			end)
		end,
	},
	{
		"benfowler/telescope-luasnip.nvim",
		config = function()
			local lst = require("telescope").extensions.luasnip
			local luasnip = require("luasnip")

			require("telescope").setup({
				extensions = {
					-- ...
					luasnip = {
						search = function(entry)
							return lst.filter_null(entry.context.trigger)
								.. " "
								.. lst.filter_null(entry.context.name)
								.. " "
								.. entry.ft
								.. " "
								.. lst.filter_description(entry.context.name, entry.context.description)
								.. lst.get_docstring(luasnip, entry.ft, entry.context)[1]
						end,
					},
					-- ...
				},
			})
		end,
	},
}
