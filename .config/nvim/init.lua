require("theprimeagen")
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
 vim.api.nvim_create_autocmd({"BufWritePre"}, {
          pattern = {"*"},
          command = "Neoformat",
        })
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true
