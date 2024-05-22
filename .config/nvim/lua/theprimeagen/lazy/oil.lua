return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			keymaps = {
				["<C-h>"] = false,
				["<C-t>"] = false,
				["<C-n>"] = false,
				["<C-s>"] = false,
				["<M-h>"] = "action.select_split",
			},
			buf_options = {
				bufhidden = "hide",
				buflisted = false,
			},
		})
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
