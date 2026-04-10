local function current_file_relpath()
    local path = vim.api.nvim_buf_get_name(0)
    if path == '' then
        return nil
    end

    return vim.fn.fnamemodify(path, ':.')
end

local function focus_codex_terminal()
    local state = require('codex.state')
    if not state.win or not vim.api.nvim_win_is_valid(state.win) then
        return
    end

    vim.api.nvim_set_current_win(state.win)
    vim.cmd('startinsert')
end

local function send_mention_to_codex(mention)
    require('codex').open()
    local state = require('codex.state')
    if not state.job then
        vim.notify('Codex job is not running', vim.log.levels.ERROR)
        return
    end

    vim.fn.chansend(state.job, mention .. '\n')
    focus_codex_terminal()
end

local function visual_line_range()
    local vpos = vim.fn.getpos('v')
    local cpos = vim.fn.getpos('.')
    local start_line = vpos[2]
    local end_line = cpos[2]

    if start_line == 0 or end_line == 0 then
        start_line = vim.fn.line("'<")
        end_line = vim.fn.line("'>")
    end

    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end

    return start_line, end_line
end

return {
    'kkrampis/codex.nvim',
    lazy = true,
    cmd = { 'Codex', 'CodexToggle' }, -- Optional: Load only on command execution
    keys = {
        {
            '<leader>cs',
            function()
                local rel = current_file_relpath()
                if not rel then
                    vim.notify('Current buffer has no file path', vim.log.levels.WARN)
                    return
                end

                send_mention_to_codex('@' .. rel)
            end,
            desc = 'Send current file mention to Codex',
            mode = { 'n' }
        },
        {
            '<leader>cs',
            function()
                local rel = current_file_relpath()
                if not rel then
                    vim.notify('Current buffer has no file path', vim.log.levels.WARN)
                    return
                end

                local start_line, end_line = visual_line_range()
                if start_line == 0 or end_line == 0 then
                    vim.notify('Could not detect visual selection range', vim.log.levels.WARN)
                    return
                end

                local mention = string.format('@%s:%d-%d', rel, start_line, end_line)
                send_mention_to_codex(mention)
            end,
            desc = 'Send selected line range mention to Codex',
            mode = { 'x' }
        },
        {
            '<leader>cc', -- Change this to your preferred keybinding
            function()
                require('codex').toggle()
                focus_codex_terminal()
            end,
            desc = 'Toggle Codex popup or side-panel',
            mode = { 'n' }
        },
    },
    opts = {
        keymaps     = {
            toggle = nil,    -- Keybind to toggle Codex window (Disabled by default, watch out for conflicts)
            quit = '<C-q>',  -- Keybind to close the Codex window (default: Ctrl + q)
        },                   -- Disable internal default keymap (<leader>cc -> :CodexToggle)
        border      = 'rounded', -- Options: 'single', 'double', or 'rounded'
        width       = 0.3,   -- Width of the floating window (0.0 to 1.0)
        height      = 0.8,   -- Height of the floating window (0.0 to 1.0)
        model       = nil,   -- Optional: pass a string to use a specific model (e.g., 'o3-mini')
        autoinstall = true,  -- Automatically install the Codex CLI if not found
        panel       = true, -- Open Codex in a side-panel (vertical split) instead of floating window
        use_buffer  = false, -- Capture Codex stdout into a normal buffer instead of a terminal buffer
    },
}
