local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = "theprimeagen.lazy",
	change_detection = { notify = false },
})
--[[ require("lazy").setup({
"theprimeagen/harpoon",
"theprimeagen/vim-be-good",
		"theprimeagen/refactoring.nvim",
"sbdchd/neoformat",
"lambdalisue/suda.vim",
{
		"nvim-lualine/lualine.nvim",
		event = "VimEnter",
		config = function()
			require("config.lualine").setup()
		end,
		requires = { "nvim-web-devicons" },
	},
{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	},
		(		--use("nvim-treesitter/nvim-treesitter-context");

{
			"VonHeikemen/lsp-zero.nvim",
			branch = "v1.x",
			requires = {
				-- LSP Support
				{ "neovim/nvim-lspconfig" },
				{ "williamboman/mason.nvim" },
				{ "williamboman/mason-lspconfig.nvim" },

				-- Autocompletion
				{ "hrsh7th/nvim-cmp" },
				{ "hrsh7th/cmp-buffer" },
				{ "hrsh7th/cmp-path" },
				{ "saadparwaiz1/cmp_luasnip" },
				{ "hrsh7th/cmp-nvim-lsp" },
				{ "hrsh7th/cmp-nvim-lua" },

				-- Snippets
				{ "L3MON4D3/LuaSnip" },
				{ "rafamadriz/friendly-snippets" },
			},
		}), 
}, 
{})
--]]
