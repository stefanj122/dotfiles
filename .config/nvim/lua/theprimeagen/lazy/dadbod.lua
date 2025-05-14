return {
	"tpope/vim-dadbod",
	dependencies = {
		"kristijanhusak/vim-dadbod-ui",
		"kristijanhusak/vim-dadbod-completion",
	},
	config = function()
		vim.keymap.set("n", "<leader>q", "<CMD>tabnew +DBUIToggle<CR>", { noremap = true, silent = true })
	end,
	init = function()
        vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_show_database_icon = 1
		vim.g.db_ui_debug = 1
	end,
}
