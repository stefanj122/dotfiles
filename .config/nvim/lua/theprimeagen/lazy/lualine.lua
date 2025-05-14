return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "SmiteshP/nvim-navic" },
	-- event = "VimEnter",
	config = function()
		local gps = require("nvim-navic")

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {},
				always_divide_middle = true,
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {
					{ "filename", path = 1 },
					{
						gps.get_location,
						cond = gps.is_available,
						color = { fg = "#f3ca28" },
					},
				},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = {
					"location",
					{
						function()
							local num = 0
							for _, buf in ipairs(vim.api.nvim_list_bufs()) do
								if vim.api.nvim_get_option_value("modified", { buf }) then
									num = num + 1
								end
							end
							if num > 0 then
								return num
							end
							return ""
						end,
					},
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = {},
		})
	end,
}
