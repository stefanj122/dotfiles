return {
	"stevearc/conform.nvim",
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				apexcode = { "prettierd" },
				php = { "phpcsfixer" },
				visualforce = { "prettierd" },
				blade = { "bladeFormatter" },
                json = { "prettierd" },
                jsonc = { "prettierd" },
			},
			formatters = {
				bladeFormatter = {
					command = "/home/stefanj/.local/share/nvim/mason/packages/blade-formatter/node_modules/blade-formatter/bin/blade-formatter.js",
					args = { "$FILENAME" },
					stdin = true,
					tmpfile_format = ".conform.$RANDOM.$FILENAME",
					exit_codes = { 0, 1 },
				},
				phpcsfixer = {
					command = "/home/stefanj/.local/share/nvim/mason/packages/php-cs-fixer/php-cs-fixer",
					args = { "fix", "$FILENAME" },
					stdin = false,
					tmpfile_format = ".conform.$RANDOM.$FILENAME",
					exit_codes = { 0, 1 },
				},
			},
		})
	end,
}