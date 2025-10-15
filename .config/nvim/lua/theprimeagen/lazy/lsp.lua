return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
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
        require("mason-lspconfig").setup({})


        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" }, -- For luasnip users.
                { name = "path" },
            }, {
                { name = "buffer" },
            }),
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            virtual_text = false,
            virtual_lines = false,
            signs = { priority = 9999 },
            underline = true,
            update_in_insert = false, -- false so diags are updated on InsertLeave
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
    end,
}
