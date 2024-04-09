require("nvim-tree").setup({
	root_dirs = {},
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
	update_focused_file = {
		enable = true,
		update_root = true,
		ignore_list = {},
	},
})
