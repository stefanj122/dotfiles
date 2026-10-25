require("telescope").setup({
    defaults = {
        file_ignore_patterns = { "node_modules", "^.git" },
        theme = "cursor",
        layout_strategy = "vertical",
        layout_config = { vertical = { width = 0.9, height = 0.95, preview_height = 0.5 } },
        treesitter = true,
        preview = {
            filesize_limit = 0.1,             -- MB
            treesitter = true,
        },
        -- vimgrep_arguments = {
        --     "grep",
        --     "--extended-regexp",
        --     "--color=never",
        --     "--with-filename",
        --     "--line-number",
        --     "-b", -- grep doesn't support a `--column` option :(
        --     "--ignore-case",
        --     "--recursive",
        --     "--no-messages",
        --     "--exclude-dir=*cache*",
        --     "--exclude-dir=*.git",
        --     "--exclude=.*",
        --     "--binary-files=without-match"
        -- }
        mappings = {
            n = {
                ['<c-f>'] = require('telescope.actions').delete_buffer
            },             -- n
            i = {
                ['<c-f>'] = require('telescope.actions').delete_buffer
            }             -- i
        }                 -- mappings
    },
    extensions = {
        media_files = {
            -- filetypes whitelist
            filetypes = { "png", "webp", "jpg", "jpeg", "svg", "mp4" },
            -- find command (defaults to `fd`)
            find_cmd = "fd"
        }
    },
})
require('telescope').load_extension('media_files')
local builtin = require("telescope.builtin")

-- vim.keymap.set("n", "gr", builtin.lsp_references, {})
vim.keymap.set("n", "<leader>fh", builtin.spell_suggest, {})
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>fa", builtin.loclist, {})
vim.keymap.set("n", "<leader>fc", builtin.git_bcommits, {})
vim.keymap.set("n", "<leader>ft", builtin.treesitter, {})
vim.keymap.set("n", "<leader>fk", builtin.keymaps, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>fw", function()
    local word = vim.fn.expand("<cword>")
    builtin.grep_string({ search = word })
end)
vim.keymap.set("n", "<leader>fW", function()
    local word = vim.fn.expand("<cWORD>")
    builtin.grep_string({ search = word })
end)
vim.keymap.set("n", "<leader>fs", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>fl", function()
    builtin.live_grep()
end)
vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fi", require('telescope').extensions.media_files.media_files, {})
