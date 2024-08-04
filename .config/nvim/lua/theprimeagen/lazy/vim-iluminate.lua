return {
	"RRethy/vim-illuminate",
	config = function()
		require("illuminate").configure({
			providers = {
				"lsp",
				"treesitter",
				"regex",
			},
			filetypes_denylist = { "dirbuf", "dirvish", "fugitive", "oil" },
		})
	end,
}
