require("illuminate").configure({
    providers = {
        "lsp",
        "regex",
    },
    filetypes_denylist = { "dirbuf", "dirvish", "fugitive", "oil", "NeogitStatus" },
})
