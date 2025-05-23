return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

		local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

		local autocmd = vim.api.nvim_create_autocmd
		autocmd("BufWinEnter", {
			group = ThePrimeagen_Fugitive,
			pattern = "*",
			callback = function()
				if vim.bo.ft ~= "fugitive" then
					return
				end

				local bufnr = vim.api.nvim_get_current_buf()
				local opts = { buffer = bufnr, remap = false }
				vim.keymap.set("n", "<leader>P", function()
					vim.cmd.Git("push")
				end, opts)

				-- rebase always
				vim.keymap.set("n", "<leader>p", function()
					vim.cmd.Git({ "pull" })
				end, opts)
				vim.keymap.set("n", "<leader>S", ":Git stash push -m ", opts)
                --
				-- NOTE: It allows me to easily set the branch i am pushing and any tracking
				-- needed if i did not set the branch up correctly
				vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
				vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
				vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")

				vim.keymap.set("n", "<leader>s", function()
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
				end, { noremap = true, silent = true })

			end,
		})
	end,
}
