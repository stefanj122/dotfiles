-- local temp = vim.api.nvim_exec2([[echo getreg(']] .. "0" .. [[')]], { output = true }).output:gsub("[\n\r]", "^J"):gsub(" ", "")
-- print(vim.inspect(temp))
vim.cmd([[set showtabline=0]])
