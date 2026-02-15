-- return {}
return {
    {
        "nvim-telescope/telescope.nvim",

        branch = "0.1.x",

        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-media-files.nvim",
        },

        config = function()
            local previewers = require("telescope.previewers")
            local image_cache = {}

            local function render_image(filepath, max_width, callback)
                local key = filepath .. "|w" .. max_width

                if image_cache[key] then
                    callback(image_cache[key])
                    return
                end

                vim.fn.jobstart({
                    "chafa",
                    "--animate=off",
                    "--center=on",
                    "--clear",
                    "--size", "x" .. tostring(max_width), -- x lets chafa pick height automatically
                    filepath
                }, {
                    stdout_buffered = true,
                    on_stdout = function(_, data, _)
                        if not data then return end
                        local output = table.concat(data, "\r\n")
                        image_cache[key] = output
                        callback(output)
                    end
                })
            end

            local function image_preview(filepath, bufnr, opts)
                local ext = vim.fn.fnamemodify(filepath, ":e"):lower()
                local is_image = vim.tbl_contains({ "png", "jpg", "jpeg", "webp", "svg" }, ext)
                local exisitngTerms = {}

                if is_image then
                    local term = vim.api.nvim_open_term(bufnr, {})

                    -- Schedule to wait until buffer is displayed
                    vim.schedule(function()
                        local winid = vim.fn.bufwinid(bufnr)
                        if winid == -1 then
                            -- fallback to default width if window not ready yet
                            winid = 0
                        end

                        local width = vim.api.nvim_win_get_height(winid) - 2
                        if width < 10 then width = 40 end -- sanity min width

                        render_image(filepath, width, function(output)
                            vim.api.nvim_chan_send(term, output)
                        end)
                    end)
                else
                    previewers.buffer_previewer_maker(filepath, bufnr, opts)
                end
            end
            require("telescope").setup({
                defaults = {
                    file_ignore_patterns = { "node_modules", "^.git" },
                    theme = "cursor",
                    layout_strategy = "vertical",
                    layout_config = { vertical = { width = 0.9, height = 0.95, preview_height = 0.5 } },
                    -- buffer_previewer_maker = image_preview,
                    preview = {
                        filesize_limit = 0.1, -- MB
                    },
                    -- vimgrep_arguments = {
                    --     "grep",
                    --     "--extended-regexp",
                    --     "--color=never",
                    --     "--with-filename",
                    --     "--line-number",
                    --     "-b", -- grep doesn't support a `--column` option :(
                    --     "--ignore-case",
                    --     "--recursive",
                    --     "--no-messages",
                    --     "--exclude-dir=*cache*",
                    --     "--exclude-dir=*.git",
                    --     "--exclude=.*",
                    --     "--binary-files=without-match"
                    -- }
                    mappings = {
                        n = {
                            ['<c-f>'] = require('telescope.actions').delete_buffer
                        }, -- n
                        i = {
                            ['<c-f>'] = require('telescope.actions').delete_buffer
                        } -- i
                    } -- mappings
                },
                extensions = {
                    media_files = {
                        -- filetypes whitelist
                        filetypes = { "png", "webp", "jpg", "jpeg", "svg", "mp4" },
                        -- find command (defaults to `fd`)
                        find_cmd = "fd"
                    }
                },
            })
            require('telescope').load_extension('media_files')
            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
            -- vim.keymap.set("n", "gr", builtin.lsp_references, {})
            vim.keymap.set("n", "<leader>fh", builtin.spell_suggest, {})
            vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
            vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
            vim.keymap.set("n", "<leader>fa", builtin.loclist, {})
            vim.keymap.set("n", "<leader>fr", builtin.resume, {})
            vim.keymap.set("n", "<leader>fc", builtin.git_bcommits, {})
            vim.keymap.set("n", "<leader>ft", builtin.treesitter, {})
            vim.keymap.set("n", "<leader>fk", builtin.keymaps, {})
            vim.keymap.set("n", "<C-p>", builtin.git_files, {})
            vim.keymap.set("n", "<leader>fw", function()
                local word = vim.fn.expand("<cword>")
                builtin.grep_string({ search = word })
            end)
            vim.keymap.set("n", "<leader>fW", function()
                local word = vim.fn.expand("<cWORD>")
                builtin.grep_string({ search = word })
            end)
            vim.keymap.set("n", "<leader>fs", function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end)
            vim.keymap.set("n", "<leader>fl", function()
                builtin.live_grep()
            end)
            vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})
            vim.keymap.set("n", "<leader>fi", require('telescope').extensions.media_files.media_files, {})
        end,

    },
    {
        -- "nvim-telescope/telescope-file-browser.nvim",
        -- dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        -- config = function()
        -- 	vim.keymap.set("n", "<leader>pv", function()
        -- 		require("telescope").extensions.file_browser.file_browser({
        -- 			path = "%:p:h",
        -- 			select_buffer = true,
        -- 			hidden = true,
        -- 		})
        -- 	end)
        -- end,
    },
    {
        "benfowler/telescope-luasnip.nvim",
        config = function()
            local lst = require("telescope").extensions.luasnip
            local luasnip = require("luasnip")

            require("telescope").setup({
                extensions = {
                    -- ...
                    luasnip = {
                        search = function(entry)
                            return lst.filter_null(entry.context.trigger)
                                .. " "
                                .. lst.filter_null(entry.context.name)
                                .. " "
                                .. entry.ft
                                .. " "
                                .. lst.filter_description(entry.context.name, entry.context.description)
                                .. lst.get_docstring(luasnip, entry.ft, entry.context)[1]
                        end,
                    },
                    -- ...
                },
            })
        end,
    },
}
