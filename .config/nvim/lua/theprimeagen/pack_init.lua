local repos = {
    -- "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-context",
    "romus204/tree-sitter-manager.nvim",
    "theprimeagen/harpoon",
    "neovim/nvim-lspconfig",
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
    "j-hui/fidget.nvim",
    "stevearc/oil.nvim",
    "nvim-tree/nvim-web-devicons",
    "folke/tokyonight.nvim",
    "folke/snacks.nvim",
    "coder/claudecode.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-media-files.nvim",
    "nvim-lua/plenary.nvim",
    -- "sudo-tee/opencode.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
    "numToStr/Comment.nvim",
    "stevearc/conform.nvim",
    "tpope/vim-dadbod",
    "kristijanhusak/vim-dadbod-ui",
    "kristijanhusak/vim-dadbod-completion",
    "akinsho/git-conflict.nvim",
    "lewis6991/gitsigns.nvim",
    "nvim-lualine/lualine.nvim",
    "SmiteshP/nvim-navic",
    "lambdalisue/suda.vim",
    "folke/trouble.nvim",
    "folke/lazydev.nvim",
    "Bilal2453/luvit-meta",
    "LunarVim/bigfile.nvim",
    "RRethy/vim-illuminate",
}

local plugins = {}
for _, repo in ipairs(repos) do
    if repo == "nvim-treesitter/nvim-treesitter" then
        plugins[#plugins + 1] = { src = "https://github.com/" .. repo, version = "master" }
    elseif repo == "theprimeagen/harpoon" then
        plugins[#plugins + 1] = { src = "https://github.com/" .. repo, version = "harpoon2" }
    else
        plugins[#plugins + 1] = { src = "https://github.com/" .. repo }
    end
end

vim.pack.add(plugins)

local modules = {
    -- "treesitter",
    "tree-sitter-manager",
    "harpoon",
    "lsp",
    "oil",
    "colors",
    "snacks",
    "telescope",
    -- "opencode",
    "claude",
    "render-markdown",
    "comment",
    "conform",
    "dadbod",
    "git-conflict",
    "gitsigns",
    "lualine",
    -- "nvim-notify",
    "snippets",
    "trouble",
    "lazydev",
    "bigfile",
    "vim-illuminate",
    -- "obsidian",
}

for _, module in ipairs(modules) do
    require("theprimeagen.pack." .. module)
end
