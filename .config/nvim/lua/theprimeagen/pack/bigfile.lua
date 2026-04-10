require("bigfile").setup({
    filesize = 5,
    pattern = { "*" },
    features = {
        "indent_blankline",
        "illuminate",
        "lsp",
        "treesitter",
        "syntax",
        "matchparen",
        "vimopts",
        "filetype",
        {
            name = "gitsigns",
            disable = function(buf)
                pcall(function()
                    require("gitsigns").detach(buf)
                end)
            end,
        },
        {
            name = "treesitter_context",
            disable = function()
                pcall(function()
                    require("treesitter-context").disable()
                end)
            end,
        },
        {
            name = "cmp",
            disable = function()
                pcall(function()
                    require("cmp").setup.buffer({ enabled = false })
                end)
            end,
        },
        {
            name = "diagnostics",
            disable = function(buf)
                pcall(vim.diagnostic.disable, buf)
            end,
        },
    },
})
