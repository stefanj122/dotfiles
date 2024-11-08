local get_netrw_path = function()
    return vim.fn['netrw#Call']('NetrwFile', vim.fn['netrw#Call']('NetrwGetWord'))
end
vim.keymap.set('n', 'yp', function() vim.fn.setreg('+', get_netrw_path())  end, {buffer = true})
