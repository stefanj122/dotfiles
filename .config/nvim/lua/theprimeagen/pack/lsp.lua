local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")
local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    cmp_lsp.default_capabilities()
)

local function make_root_dir(root_markers, opts)
    opts = opts or {}

    return function(bufnr, on_dir)
        if opts.exclude_filetypes and vim.tbl_contains(opts.exclude_filetypes, vim.bo[bufnr].filetype) then
            return
        end

        local root = vim.fs.root(bufnr, root_markers)
        if root then
            on_dir(root)
        end
    end
end

-- Apply completion capabilities to every server configured through vim.lsp.
vim.lsp.config("*", {
    capabilities = capabilities,
})

vim.lsp.config("apex_ls", {
    apex_jar_path = vim.fn.stdpath("data") ..
        "/mason/packages/apex-language-server/extension/dist/apex-jorje-lsp.jar",
    apex_enable_semantic_errors = true,
    apex_enable_completion_statistics = true,
    filetypes = { "apex" },
})
vim.lsp.enable("apex_ls")

vim.lsp.config("laravel_ls", {
    root_dir = make_root_dir({ "artisan" }),
})

vim.lsp.config("lwc_ls", {
    root_dir = make_root_dir({ "sfdx-project.json", "force-app" }),
})

vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = "space",
                    indent_size = "2",
                },
            },
        },
    },
})

vim.lsp.config("tailwindcss", {
    root_dir = make_root_dir({
        "tailwind.config.js",
        "tailwind.config.cjs",
        "tailwind.config.mjs",
        "tailwind.config.ts",
        "postcss.config.js",
        "postcss.config.cjs",
        "package.json",
        ".git",
    }, { exclude_filetypes = { "markdown" } }),
    filetypes = {
        "html",
        "css",
        "scss",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
        "heex",
    },
})

require("fidget").setup({})
require("mason").setup()
require("mason-lspconfig").setup({
    automatic_enable = {
        -- stylua exposes an LSP mode, but Conform already owns Lua formatting.
        exclude = { "stylua" },
    },
    ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "vtsls",
        "tailwindcss",
    },
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
