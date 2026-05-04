local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()
)

local make_root_dir = function(root_markers)
    local root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, root_markers)
        if root then
            on_dir(root)
        end
    end
    return root_dir
end

vim.lsp.config('apex_ls', vim.tbl_extend('force', vim.lsp.config.apex_ls, {
    capabilities = capabilities,
    apex_jar_path = vim.fn.stdpath("data") ..
        "/mason/packages/apex-language-server/extension/dist/apex-jorje-lsp.jar",
    apex_enable_semantic_errors = true,
    apex_enable_completion_statistics = true,
}))
vim.lsp.enable('apex_ls');

vim.lsp.config('laravel_ls', vim.tbl_extend('force', vim.lsp.config.laravel_ls, {
    capabilities = capabilities,
    root_dir = make_root_dir({ 'artisan' }),
}))

vim.lsp.config('lwc_ls',
    vim.tbl_extend('force', vim.lsp.config.lwc_ls, {
        capabilities = capabilities,
        root_dir = make_root_dir({ 'sfdx-project.json', 'force-app' }),
    })
)


require("fidget").setup({})
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "vtsls",
        "tailwindcss",
    },
    handlers = {
        function(server_name)         -- default handler (optional)
            require("lspconfig")[server_name].setup {
                capabilities = capabilities
            }
        end,

        zls = function()
            local lspconfig = require("lspconfig")
            lspconfig.zls.setup({
                root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                settings = {
                    zls = {
                        enable_inlay_hints = true,
                        enable_snippets = true,
                        warn_style = true,
                    },
                },
            })
            vim.g.zig_fmt_parse_errors = 0
            vim.g.zig_fmt_autosave = 0
        end,
        ["lua_ls"] = function()
            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            globals = { 'vim' },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                        format = {
                            enable = true,
                            -- Put format options here
                            -- NOTE: the value should be STRING!!
                            defaultConfig = {
                                indent_style = "space",
                                indent_size = "2",
                            }
                        },
                    }
                }
            }
        end,
        ["tailwindcss"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.tailwindcss.setup({
                capabilities = capabilities,
                filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "heex" },
            })
        end,
    }
})



local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)         -- For `luasnip` users.
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-f>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = "lazydev", group_index = 0 },
        { name = "nvim_lsp" },
        { name = "luasnip" },         -- For luasnip users.
        -- { name = "path" },
    }, {
        { name = "buffer" },
    }),
})

-- cmp.setup.cmdline({ "/", "?" }, {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = {
--         { name = "buffer" }
--     }
-- })
--
-- cmp.setup.cmdline(":", {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = cmp.config.sources({
--         { name = "path" }
--     }, {
--         { name = "cmdline" }
--     })
-- })

vim.diagnostic.config({
    -- update_in_insert = true,
    virtual_text = true,
    virtual_lines = false,
    signs = { priority = 9999 },
    underline = true,
    update_in_insert = false,         -- false so diags are updated on InsertLeave
    -- virtual_text = { current_line = true, severity = { min = "INFO", max = "WARN" } },
    -- virtual_lines = { current_line = true, severity = { min = "ERROR" } },
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
    },
})
