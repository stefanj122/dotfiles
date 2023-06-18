local fb_actions = require("telescope._extensions.file_browser.actions")
local builtin = require("telescope.builtin")
local extensions = require("telescope").extensions

require("telescope").setup({
	extensions = {
		file_browser = {
			grouped = true,
			select_buffer = true,
			hidden = { file_browser = true, folder_browser = false },
			respect_gitignore = false,
			hide_parent_dir = true,
			hijack_netrw = false,
			use_fd = true,
			git_status = true,
		},
	},
})

require("telescope").load_extension("dap")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("projects")

vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<leader>pp", extensions.projects.projects, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
