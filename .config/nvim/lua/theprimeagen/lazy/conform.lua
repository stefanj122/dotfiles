return {
	"stevearc/conform.nvim",
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>bf",
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
				apex = { "prettierd" },
				php = function(bufnr)
					-- if require("conform").get_formatter_info("phpcsfixer", bufnr).available then
					-- -- else
					-- 	return { "phpcsfixer" }
					-- end
                    return { lsp_format = "fallback" }
				end,
				visualforce = { "prettierd" },
				blade = { "bladeFormatter" },
				sh = { "shfmt" },
				json = { "prettierd" },
				jsonc = { "prettierd" },
				html = { "prettierd" },
				css = { "prettierd" },
				handlebars = { "prettier" },
				xml = { "xmlformat" },
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
					command = "php-cs-fixer",
					args = { "fix", "$FILENAME", "--config=/home/stefanj/.php-cs-fixer.php" },
					stdin = false,
					tmpfile_format = ".conform.$RANDOM.$FILENAME",
					exit_codes = { 0, 1 },
				},
				prettier = {
					options = {
						-- Use a specific prettier parser for a filetype
						-- Otherwise, prettier will try to infer the parser from the file name
						ft_parsers = {
							--     javascript = "babel",
							--     javascriptreact = "babel",
							--     typescript = "typescript",
							--     typescriptreact = "typescript",
							--     vue = "vue",
							css = "css",
							--     scss = "scss",
							--     less = "less",
							--     json = "json",
							--     jsonc = "json",
							--     yaml = "yaml",
							--     markdown = "markdown",
							--     ["markdown.mdx"] = "mdx",
							--     graphql = "graphql",
							handlebars = "html",
						},
					},
				},
			},
		})
	end,
}
