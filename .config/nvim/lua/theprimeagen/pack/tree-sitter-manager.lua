require("tree-sitter-manager").setup({
    ensure_installed = {
        "vimdoc",
        "markdown",
        "markdown_inline",
        "javascript",
        -- "typescript",
        -- "tsx",
        "sql",
        "c",
        "lua",
        "rust",
        "jsdoc",
        "bash",
        -- "php",
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
