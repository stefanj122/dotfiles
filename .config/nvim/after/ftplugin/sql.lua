local cmp = require("cmp")
cmp.setup.filetype({ "mysql", "sql" }, {
    sources = {
        { name = "vim-dadbod-completion" },
        { name = "buffer" },
    },
})
