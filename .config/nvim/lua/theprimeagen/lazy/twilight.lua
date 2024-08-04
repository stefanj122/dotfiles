return {
	"folke/twilight.nvim",
	config = function()
		require("twilight").setup({
			dimming = {
				alpha = 0.75, -- amount of dimming
				color = { "Normal", "#ffffff" },
				term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
				inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
			},
			context = 50,
			expand = {
			},
		})
	end,
}
