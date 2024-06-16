return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			view_options = {
				show_hidden = true,
			},
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
			delete_to_trash = true,
            skip_confirm_for_simple_edits = true,
            lsp_file_methods = {
                timeout_ms = 1000,
                show_line_diagnostics = true,
            },
            experimental_watch_for_changes = true,
		})
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
