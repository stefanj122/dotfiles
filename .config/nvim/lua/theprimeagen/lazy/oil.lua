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
				["<leader>ff"] = {
					function()
						require("telescope.builtin").find_files({
							cwd = require("oil").get_current_dir(),
						})
					end,
					mode = "n",
					nowait = true,
					desc = "Find files in the current directory",
				},
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

		function YankOilEntry()
			local workspace_folders = vim.lsp.buf.list_workspace_folders()
			local lsp_cwd = workspace_folders[1] -- Assuming a single workspace
			local path = ""

			if not lsp_cwd then
				local oil = require("oil")
				local entry = oil.get_cursor_entry()
				if not entry then
					return
				end

				local cwd = vim.inspect(oil.get_current_dir(0))
				path = cwd.gsub(cwd, '"', "") .. entry.name
			else
				local file_path = vim.api.nvim_buf_get_name(0)
				path = vim.fn.fnamemodify(file_path, ":." .. lsp_cwd)
			end

			vim.fn.setreg("+", path) -- Yank to the default register
		end

		vim.api.nvim_set_keymap("n", "<leader>yp", ":lua YankOilEntry()<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
