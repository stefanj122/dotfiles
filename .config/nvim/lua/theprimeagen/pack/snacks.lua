local Snacks = require("snacks")

---@type snacks.Config
Snacks.setup({
    -- LunarVim/bigfile.nvim below handles large buffers.
    bigfile = { enabled = false },
    notifier = {},
    dashboard = { example = "pokemon" },
    picker = { enabled = true },
    quickfile = { enabled = true },
    input = { enabled = true },
    scope = { enabled = true },
    image = {
        formats = {
            "png",
            "jpg",
            "jpeg",
            "gif",
            "svg",
            "bmp",
            "webp",
            "tiff",
            "heic",
            "avif",
            "mp4",
            "mov",
            "avi",
            "mkv",
            "webm",
            "pdf",
            "icns",
        },
    },
})

_G.dd = function(...)
    Snacks.debug.inspect(...)
end

_G.bt = function()
    Snacks.debug.backtrace()
end

if vim.fn.has("nvim-0.11") == 1 then
    vim._print = function(_, ...)
        dd(...)
    end
else
    vim.print = _G.dd
end

local function map(lhs, rhs, opts)
    opts = opts or {}

    local mode = opts.mode or "n"
    opts.mode = nil

    vim.keymap.set(mode, lhs, rhs, opts)
end

-- Top Pickers & Explorer
map("<leader><space>", function()
    Snacks.picker.smart()
end, { desc = "Smart Find Files" })
map("<leader>,", function()
    Snacks.picker.buffers()
end, { desc = "Buffers" })
map("<leader>/", function()
    Snacks.picker.grep()
end, { desc = "Grep" })
map("<leader>:", function()
    Snacks.picker.command_history()
end, { desc = "Command History" })
map("<leader>n", function()
    Snacks.picker.notifications()
end, { desc = "Notification History" })
map("<leader>e", function()
    Snacks.explorer()
end, { desc = "File Explorer" })

-- find
map("<leader>fb", function()
    Snacks.picker.buffers()
end, { desc = "Buffers" })
-- map("<leader>fc", function()
--     Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
-- end, { desc = "Find Config File" })
map("<leader>ff", function()
    Snacks.picker.files()
end, { desc = "Find Files" })
map("<leader>fg", function()
    Snacks.picker.git_files()
end, { desc = "Find Git Files" })
-- map("<leader>fp", function()
--     Snacks.picker.projects()
-- end, { desc = "Projects" })
map("<leader>fr", function()
    Snacks.picker.recent()
end, { desc = "Recent" })

-- git
map("<leader>gb", function()
    Snacks.picker.git_branches()
end, { desc = "Git Branches" })
map("<leader>gl", function()
    Snacks.picker.git_log()
end, { desc = "Git Log" })
map("<leader>gL", function()
    Snacks.picker.git_log_line()
end, { desc = "Git Log Line" })
map("<leader>gs", function()
    Snacks.picker.git_status()
end, { desc = "Git Status" })
map("<leader>gS", function()
    Snacks.picker.git_stash()
end, { desc = "Git Stash" })
map("<leader>gd", function()
    Snacks.picker.git_diff()
end, { desc = "Git Diff (Hunks)" })
map("<leader>gf", function()
    Snacks.picker.git_log_file()
end, { desc = "Git Log File" })

-- Grep
map("<leader>sb", function()
    Snacks.picker.lines()
end, { desc = "Buffer Lines" })
map("<leader>sB", function()
    Snacks.picker.grep_buffers()
end, { desc = "Grep Open Buffers" })
-- map("<leader>sg", function()
--     Snacks.picker.grep()
-- end, { desc = "Grep" })
map("<leader>sw", function()
    Snacks.picker.grep_word()
end, { desc = "Visual selection or word", mode = { "n", "x" } })

-- search
map('<leader>s"', function()
    Snacks.picker.registers()
end, { desc = "Registers" })
map("<leader>s/", function()
    Snacks.picker.search_history()
end, { desc = "Search History" })
map("<leader>sa", function()
    Snacks.picker.autocmds()
end, { desc = "Autocmds" })
map("<leader>sc", function()
    Snacks.picker.command_history()
end, { desc = "Command History" })
map("<leader>sC", function()
    Snacks.picker.commands()
end, { desc = "Commands" })
map("<leader>sd", function()
    Snacks.picker.diagnostics()
end, { desc = "Diagnostics" })
map("<leader>sD", function()
    Snacks.picker.diagnostics_buffer()
end, { desc = "Buffer Diagnostics" })
map("<leader>sh", function()
    Snacks.picker.help()
end, { desc = "Help Pages" })
map("<leader>sH", function()
    Snacks.picker.highlights()
end, { desc = "Highlights" })
map("<leader>si", function()
    Snacks.picker.icons()
end, { desc = "Icons" })
map("<leader>sj", function()
    Snacks.picker.jumps()
end, { desc = "Jumps" })
map("<leader>sk", function()
    Snacks.picker.keymaps()
end, { desc = "Keymaps" })
-- map("<leader>sl", function()
--     Snacks.picker.loclist()
-- end, { desc = "Location List" })
map("<leader>sm", function()
    Snacks.picker.marks()
end, { desc = "Marks" })
-- map("<leader>sM", function()
--     Snacks.picker.man()
-- end, { desc = "Man Pages" })
-- map("<leader>sp", function()
--     Snacks.picker.files({ cwd = vim.fn.stdpath("config") .. "/lua/theprimeagen/pack" })
-- end, { desc = "Search Plugin Config" })
map("<leader>sq", function()
    Snacks.picker.qflist()
end, { desc = "Quickfix List" })
map("<leader>sR", function()
    Snacks.picker.resume()
end, { desc = "Resume" })
map("<leader>su", function()
    Snacks.picker.undo()
end, { desc = "Undo History" })
-- map("<leader>sA", function()
--     Snacks.picker.colorschemes()
-- end, { desc = "Colorschemes" })

-- LSP
-- map("gd", function()
--     Snacks.picker.lsp_definitions()
-- end, { desc = "Goto Definition" })
-- map("gD", function()
--     Snacks.picker.lsp_declarations()
-- end, { desc = "Goto Declaration" })
-- map("gr", function()
--     Snacks.picker.lsp_references()
-- end, { nowait = true, desc = "References" })
map("gI", function()
    Snacks.picker.lsp_implementations()
end, { desc = "Goto Implementation" })
map("gy", function()
    Snacks.picker.lsp_type_definitions()
end, { desc = "Goto T[y]pe Definition" })
map("gai", function()
    Snacks.picker.lsp_incoming_calls()
end, { desc = "C[a]lls Incoming" })
map("gao", function()
    Snacks.picker.lsp_outgoing_calls()
end, { desc = "C[a]lls Outgoing" })
map("<leader>ss", function()
    Snacks.picker.lsp_symbols()
end, { desc = "LSP Symbols" })
-- map("<leader>sS", function()
--     Snacks.picker.lsp_workspace_symbols()
-- end, { desc = "LSP Workspace Symbols" })

-- Other
-- map("<leader>n", function()
--     Snacks.notifier.show_history()
-- end, { desc = "Notification History" })
map("<leader>bd", function()
    Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("<leader>cR", function()
    Snacks.rename.rename_file()
end, { desc = "Rename File" })
map("<leader>gB", function()
    Snacks.gitbrowse()
end, { desc = "Git Browse", mode = { "n", "v" } })
map("<leader>gg", function()
    Snacks.lazygit()
end, { desc = "Lazygit" })
map("<leader>N", function()
    Snacks.win({
        file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
        width = 0.6,
        height = 0.6,
        wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
        },
    })
end, { desc = "Neovim News" })
