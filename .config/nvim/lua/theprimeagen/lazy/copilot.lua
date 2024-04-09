return {
	"github/copilot.vim",
	config = function()
		vim.keymap.set("i", "<M-Right>", 'copilot#AcceptWord("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
		})
		vim.keymap.set("i", "<C-]>", 'copilot#AcceptLine("\\<CR>")', {
			expr = true,
			replace_keycodes = false,
		})
	end,
}
