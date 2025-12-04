return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local detail = false
        require("oil").setup({
            view_options = {
                show_hidden = true,
            },
            keymaps = {
                ["<C-h>"] = false,
                ["<C-t>"] = false,
                ["<C-n>"] = false,
                ["<C-s>"] = false,
                ["<C-p>"] = false,
                ["ff"] = {
                    function()
                        Snacks.picker.files({
                            cwd = require("oil").get_current_dir(),
                        })
                    end,
                    mode = "n",
                    nowait = true,
                    desc = "Find files in the current directory",
                },
                ["fl"] = {
                    function()
                        Snacks.picker.grep({
                            cwd = require("oil").get_current_dir(),
                        })
                    end,
                    mode = "n",
                    nowait = true,
                    desc = "Find files in the current directory",
                },
                ["gd"] = {
                    desc = "Toggle file detail view",
                    callback = function()
                        detail = not detail
                        if detail then
                            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                        else
                            require("oil").set_columns({ "icon" })
                        end
                    end,
                },
                ["yp"] = {
                    function()
                        local path = require("oil").get_current_dir()
                        local entry = require("oil").get_cursor_entry()
                        if not entry then
                            return
                        end
                        vim.fn.setreg("+", path .. entry.name) -- Yank to the default register
                    end,
                    mode = "n",
                    nowait = true,
                    desc = "Copy absolute file path",
                },
                ["<leader>yp"] = {
                    function()
                        local lsp_cwd = vim.uv.cwd()
                        local path = ""

                        if lsp_cwd then
                            local oil = require("oil")
                            local entry = oil.get_cursor_entry()
                            if not entry then
                                return
                            end

                            local cwd = oil.get_current_dir(0)
                            if not cwd then
                                return
                            end

                            local function get_relative_path(cwd, lsp_cwd, entry_name)
                                local i = 1
                                while i <= string.len(cwd) and i <= string.len(lsp_cwd) and string.sub(cwd, i, i) == string.sub(lsp_cwd, i, i) do
                                    i = i + 1
                                end
                                local relative_path = string.sub(cwd, i) .. entry_name
                                return relative_path
                            end

                            path = get_relative_path(cwd, lsp_cwd, entry.name)
                        end

                        vim.fn.setreg("+", string.gsub(path, "^/", "")) -- Yank to the default register
                    end,
                    mode = "n",
                    nowait = true,
                    desc = "Copy relative to cwd file path",
                },
            },
            buf_options = {
                bufhidden = "hide",
                buflisted = false,
            },
            delete_to_trash = true,
            skip_confirm_for_simple_edits = true,
            lsp_file_methods = {
                timeout_ms = 1000,
                show_line_diagnostics = true,
            },
            experimental_watch_for_changes = true,
        })

        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end,
}
