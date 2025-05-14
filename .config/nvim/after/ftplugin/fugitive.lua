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

vim.keymap.set("n", "<leader>f", ":G fetch<CR>", opts)
vim.keymap.set("n", "<leader>l", ":GcLog<CR>", opts)

vim.keymap.set("n", "<leader>a", function()
	vim.cmd("G checkout -b " .. vim.fn.input("Enter branch name: feat/"))
end, opts)
vim.keymap.set("n", "<leader>s", function()
	GitStash()
end, { buffer = bufnr, noremap = true, silent = true })
vim.keymap.set("n", "<leader>b", function()
	GitBranch()
end, { buffer = bufnr, noremap = true, silent = true })
