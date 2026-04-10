local can_toggle_diagnostics = vim.diagnostic and type(vim.diagnostic.disable) == "function"

require('git-conflict').setup({
    default_mappings = true,        -- disable buffer local mapping created by this plugin
    default_commands = true,        -- disable commands created by this plugin
    disable_diagnostics = can_toggle_diagnostics, -- fallback for older Neovim versions
    list_opener = 'copen',          -- command or function to open the conflicts list
    highlights = {                  -- They must have background color, otherwise the default color will be used
        incoming = 'DiffAdd',
        current = 'DiffText',
    }
})
