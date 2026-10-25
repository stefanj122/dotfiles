vim.keymap.set("n", "<leader>gg", vim.cmd.Git)

local fugitive_group = vim.api.nvim_create_augroup("ThePrimeagenFugitive", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
    group = fugitive_group,
    pattern = "fugitive://*",
    callback = function(args)
        local name = vim.api.nvim_buf_get_name(args.buf)
        if not name:match("//0/") then
            return
        end

        local real = vim.fn.FugitiveReal(name)
        if type(real) ~= "string" or real == "" then
            return
        end

        if vim.fn.filereadable(real) == 0 then
            return
        end

        vim.cmd.edit(vim.fn.fnameescape(real))
    end,
})
