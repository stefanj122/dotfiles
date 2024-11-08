return {
	"tpope/vim-dadbod",
	dependencies = {
		"kristijanhusak/vim-dadbod-ui",
		"kristijanhusak/vim-dadbod-completion",
	},
	config = function()
		vim.keymap.set("n", "<leader>q", "<CMD>tabnew +DBUIToggle<CR>", { noremap = true, silent = true })
	end,
}
