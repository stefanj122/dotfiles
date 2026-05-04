vim.pack.add({
    { src = "https://github.com/rest-nvim/rest.nvim" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },
})

local ok, rest = pcall(require, "rest-nvim")
if not ok then
    return
end
require("telescope").load_extension("rest")

rest.setup({})
