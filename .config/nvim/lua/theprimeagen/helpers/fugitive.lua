local function clear_buffer_keybindings(bufnr)
	-- Get all normal mode mappings for the buffer
	local mappings = vim.api.nvim_buf_get_keymap(bufnr, "n")
	for _, map in ipairs(mappings) do
		-- Delete each mapping
		pcall(vim.api.nvim_buf_del_keymap, bufnr, "n", map.lhs)
	end
end
function GitStash()
	local output = vim.fn.systemlist("git stash list --pretty=format:'%h %<(10)%gd %as  %s'")
	if vim.v.shell_error ~= 0 then
		print("Error running git stash list")
		return
	end

	local qf_entries = {}
	for _, line in ipairs(output) do
		local sha, rest = line:match("^(%S+)%s+(.*)$")
		local fugitivePath = vim.fn.FugitiveFind(sha)
		local num = vim.fn.bufnr(fugitivePath, true)
		if sha and rest then
			table.insert(qf_entries, {
				bufnr = num,
				module = sha, -- store SHA in filename
				valid = 1,
				text = rest,
			})
		end
	end

	vim.fn.setqflist({}, " ", { title = "Git Stashes", items = qf_entries })
	vim.cmd("copen")
	local bufnr = vim.api.nvim_get_current_buf()
	clear_buffer_keybindings(bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "<leader>a", function()
		local stash = vim.api.nvim_get_current_line():match("stash@{.}")
		vim.cmd("G stash apply " .. stash)
	end, opts)
	vim.keymap.set("n", "<leader>p", function()
		local stash = vim.api.nvim_get_current_line():match("stash@{.}")
		vim.cmd("G stash pop " .. stash)
		GitStash()
	end, opts)
	vim.keymap.set("n", "<leader>d", function()
		local stash = vim.api.nvim_get_current_line():match("stash@{.}")
		vim.cmd("G stash drop " .. stash)
		GitStash()
	end, opts)
end

function GitBranch()
	local output = vim.fn.systemlist(
		"git for-each-ref --sort=-committerdate refs/heads/ --format='%(refname:short) %(authorname)[%(committerdate:relative)] \"%(subject)\"'"
	)
	if vim.v.shell_error ~= 0 then
		print("Error running git stash list")
		return
	end

	local qf_entries = {}
	for _, line in ipairs(output) do
		local sha, rest = line:match("^(%S+)%s+(.*)$")
		local fugitivePath = vim.fn.FugitiveFind(sha)
		local num = vim.fn.bufnr(fugitivePath, true)
		if sha and rest then
			table.insert(qf_entries, {
				bufnr = num,
				module = sha, -- store SHA in filename
				valid = 1,
				text = rest,
			})
		end
	end

	vim.fn.setqflist({}, " ", { title = "Git Branches", items = qf_entries })
	vim.cmd("copen")
	local bufnr = vim.api.nvim_get_current_buf()
	clear_buffer_keybindings(bufnr)
	local opts = { buffer = bufnr, remap = false, silent = true }

	vim.keymap.set("n", "<leader>c", function()
		local branch = vim.api.nvim_get_current_line():match("^[^|]+")
		vim.cmd("G checkout " .. branch)
	end, opts)
	vim.keymap.set("n", "<leader>d", function()
		local branch = vim.api.nvim_get_current_line():match("^[^|]+")
		vim.ui.input({ prompt = "Delete " .. branch .. ". [y/n]" }, function(confirm)
			if confirm ~= "y" then
				return
			end
			vim.cmd("G branch -d " .. branch)
			GitBranch()
		end)
	end, opts)
end
