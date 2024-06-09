return {
	{
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({
				indent = {
					top = "│ ",
					middle = "├╴",
					last = "└╴",
					-- last          = "-╴",
					-- last       = "╰╴", -- rounded
					fold_open = " ",
					fold_closed = " ",
					ws = "  ",
				},
				folder_closed = " ",
				folder_open = " ",
				kinds = {
					Array = " ",
					Boolean = "󰨙 ",
					Class = " ",
					Constant = "󰏿 ",
					Constructor = " ",
					Enum = " ",
					EnumMember = " ",
					Event = " ",
					Field = " ",
					File = " ",
					Function = "󰊕 ",
					Interface = " ",
					Key = " ",
					Method = "󰊕 ",
					Module = " ",
					Namespace = "󰦮 ",
					Null = " ",
					Number = "󰎠 ",
					Object = " ",
					Operator = " ",
					Package = " ",
					Property = " ",
					String = " ",
					Struct = "󰆼 ",
					TypeParameter = " ",
					Variable = "󰀫 ",
				},
			})

			vim.keymap.set("n", "<leader>tt", function()
				require("trouble").toggle({ mode = "diagnostics" })
			end)

			vim.keymap.set("n", "[t", function()
				require("trouble").next({ mode = "diagnostics", skip_groups = true, jump = true })
			end)

			vim.keymap.set("n", "]t", function()
				require("trouble").prev({ mode = "diagnostics", skip_groups = true, jump = true })
			end)
		end,
	},
}
