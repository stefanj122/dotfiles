require("theprimeagen.set")
require("theprimeagen.remap")
require("theprimeagen.lazy_init")
require("theprimeagen.filetype")

local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup("ThePrimeagen", {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup("HighlightYank", {})

function R(name)
	require("plenary.reload").reload_module(name)
end

-- vim.filetype.add({
-- 	extension = {
-- 		templ = "templ",
-- 	},
-- })

autocmd({ "VimEnter" }, {
	group = ThePrimeagenGroup,
	pattern = { "*" },
	callback = function(_)
		vim.api.nvim_set_hl(0, "Visual", { bg = "#202020" })
		vim.api.nvim_set_hl(0, "diffRemoved", { fg = "red" })
		vim.api.nvim_set_hl(0, "diffAdded", { fg = "green" })
		vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#252321" })
	end,
})

autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

-- vim.api.nvim_create_autocmd("BufEnter", {
--     pattern = { "*" },
--     callback = function()
--         if vim.bo.filetype ~= "NeogitStatus" then
--             vim.opt.nu = true
--             vim.opt.relativenumber = true
--         else
--             vim.opt.nu = false
--             vim.opt.relativenumber = false
--         end
--     end,
-- })

-- autocmd({ "BufWritePre" }, {
-- 	group = ThePrimeagenGroup,
-- 	pattern = "*",
-- 	command = [[%s/\s\+$//e]],
-- })

autocmd("LspAttach", {
	group = ThePrimeagenGroup,
	callback = function(e)
		local opts = { buffer = e.buf }
		vim.keymap.set("n", "gd", function()
			vim.lsp.buf.definition()
		end, opts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)
		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)
		vim.keymap.set("n", "<leader>vd", function()
			vim.diagnostic.open_float()
		end, opts)
		vim.keymap.set("n", "<leader>vca", function()
			vim.lsp.buf.code_action()
		end, opts)
		vim.keymap.set("n", "gr", function()
			vim.lsp.buf.references()
		end, opts)
		vim.keymap.set("n", "<leader>vrn", function()
			vim.lsp.buf.rename()
		end, opts)
		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)
		vim.keymap.set("n", "[d", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, opts)
		vim.keymap.set("n", "]d", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, opts)
	end,
})

-- autocmd({ "BufWritePre" }, {
-- 	pattern = { "*" },
-- 	command = "silent Neoformat",
-- })
-- disable netrw at the very start of your init.lua (strongly advised)
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_list_hide = "^./$"
vim.g.clipboard = {
	name = "myClipboard",
	copy = {
		["+"] = { "wl-copy" },
	},
	paste = {
		["+"] = { "wl-paste" },
	},
	cache_enabled = 1,
}
