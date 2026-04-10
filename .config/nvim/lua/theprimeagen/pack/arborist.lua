vim.pack.add({
    "https://github.com/arborist-ts/arborist.nvim",
})

vim.g.arborist_loaded = true -- skip auto-setup, we're configuring manually
require("arborist").setup({
    update_cadence = "weekly",
    overrides = {
        php = {
            url = "https://github.com/tree-sitter/tree-sitter-php",
        },

    },
})
