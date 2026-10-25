local neogit = require("neogit")
neogit.setup({
    -- Workaround for stale OID lookup after hard reset.
    -- "ascii" graph runs a separate git log --graph call that can race history rewrites.
    graph_style = "unicode",
    -- integrations = {
    --     telescope = true,
    --     diffview = false,
    -- },
})
vim.keymap.set("n", "<leader>gg", function()
    neogit.open({ kind = "replace" })
end)
