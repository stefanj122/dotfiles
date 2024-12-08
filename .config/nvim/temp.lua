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
        print(vim.inspect(cwd))
		path = cwd.gsub(cwd, "\"", "") .. entry.name
	else
		local file_path = vim.api.nvim_buf_get_name(0)

        print(vim.inspect(lsp_cwd))
		path = vim.fn.fnamemodify(file_path, ":." .. lsp_cwd)
	end

	vim.fn.setreg("+", path) -- Yank to the default register
	print(path)
end
-- Key mapping to yank filepath in Oil
vim.api.nvim_set_keymap("n", "<leader>y", ":lua YankOilEntry()<CR>", { noremap = true, silent = true })
