require("tree-sitter-manager").setup({
    ensure_installed = {
        "vimdoc",
        "markdown",
        "markdown_inline",
        "javascript",
        "typescript",
        "tsx",
        "gitcommit",
        "sql",
        "c",
        "lua",
        "rust",
        "jsdoc",
        "bash",
        "php",
        "php_only",
    },
    languages = {
        php = {
            install_info = {
                url = "https://github.com/tree-sitter/tree-sitter-php",
                location = "php",
            },
            requires = {}, -- izbegni auto php_only dependency
            use_repo_queries = true,
        },
        php_only = {
            install_info = {
                url = "https://github.com/tree-sitter/tree-sitter-php",
                location = "php_only",
            },
            use_repo_queries = true,
        },
    },

    -- Optional: custom paths
    -- parser_dir = vim.fn.stdpath("data") .. "/site/parser",
    -- query_dir = vim.fn.stdpath("data") .. "/site/queries",
})

-- Map markdown parser to chat-like markdown filetypes.
vim.treesitter.language.register("markdown", "opencode_output")
vim.treesitter.language.register("php", "phtml")
vim.treesitter.language.register("tsx", "typescriptreact")

-- tree-sitter-manager highlights only language-matched filetypes by default.
-- These custom filetypes need an explicit start call.
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "opencode_output" },
    callback = function()
        pcall(vim.treesitter.start, 0, "markdown")
    end,
})

-- Ensure TSX parser is attached for .tsx buffers on first open.
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescriptreact" },
    callback = function()
        pcall(vim.treesitter.start, 0, "tsx")
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "gitcommit" },
    callback = function()
        pcall(vim.treesitter.start, 0, "gitcommit")
    end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "vue" },
    callback = function()
        pcall(vim.treesitter.start, 0, "vue")
    end,
})

local ok_ctx, ts_context = pcall(require, "treesitter-context")
if ok_ctx then
    ts_context.setup({
        enable = true,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = "outer",
        mode = "cursor",
        separator = nil,
        zindex = 20,
    })
end
