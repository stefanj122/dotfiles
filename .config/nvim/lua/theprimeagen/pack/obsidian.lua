vim.pack.add({ { src = "https://github.com/epwalsh/obsidian.nvim" } });
require("obsidian").setup({
    workspaces = {
        {
            name = "personal",
            path = "~/vaults/personal",
        },
        {
            name = "work",
            path = "~/vaults/work",
        },
    },

})

vim.keymap.set("n", "<leader>os", "<cmd>ObsidianSearch<CR>", { desc = "Obsidian search" })
vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianTags<CR>", { desc = "Obsidian tags" })
