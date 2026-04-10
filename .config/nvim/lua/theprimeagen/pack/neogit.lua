local neogit = require("neogit")
neogit.setup({
    -- integrations = {
    --     telescope = true,
    --     diffview = false,
    -- },
})
vim.keymap.set("n", "<leader>gg", function()
    neogit.open({ kind = "replace" })
end)
