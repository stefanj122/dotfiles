return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration

		-- Only one of these is needed.
		"nvim-telescope/telescope.nvim", -- optional
		"ibhagwan/fzf-lua", -- optional
		"echasnovski/mini.pick", -- optional
	},
	config = function()
		local neogit = require("neogit")
		neogit.setup({
			integrations = {
				telescope = true,
				diffview = true,
			},
		})
		vim.keymap.set("n", "<leader>gs", function()
			neogit.open()
		end)
	end,
}
