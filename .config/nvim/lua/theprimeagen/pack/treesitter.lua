-- pcall(vim.cmd, "packadd nvim-treesitter")

local ts_ok, ts_configs = pcall(require, "nvim-treesitter.configs")
if not ts_ok then
    return
end

ts_configs.setup({
    ensure_installed = {
        "vimdoc",
        "markdown",
        "markdown_inline",
        "javascript",
        "typescript",
        "tsx",
        "php",
        "sql",
        "c",
        "rust",
        "jsdoc",
        "bash",
        "html",
    },
    ignore_install = { "lua" },
    sync_install = false,
    auto_install = true,
    indent = {
        enable = true,
    },
    highlight = {
        enable = true,
        disable = function(lang, buf)
            local max_filesize = 1024 * 1024
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            return ok and stats and stats.size > max_filesize
        end,
        additional_vim_regex_highlighting = { "markdown" },
    },
})

local parsers = require("nvim-treesitter.parsers")
local parser_configs = parsers.get_parser_configs and parsers.get_parser_configs() or parsers

parser_configs.templ = {
    install_info = {
        url = "https://github.com/vrischmann/tree-sitter-templ.git",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "master",
    },
}

parser_configs.blade = {
    install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade.git",
        files = { "src/parser.c" },
        branch = "main",
    },
    filetype = "blade",
}

vim.treesitter.language.register("templ", "templ")
vim.treesitter.language.register("apex", "apexcode")
vim.treesitter.language.register("html", "visualforce")
vim.treesitter.language.register("php", "phtml")


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
