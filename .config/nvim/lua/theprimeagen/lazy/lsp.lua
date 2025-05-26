return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")
		local capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			cmp_lsp.default_capabilities()
		)

		local lspconfig = require("lspconfig")
		local lsp_servers = {
			"clangd",
			"cssls",
			"docker_compose_language_service",
			"dockerls",
			"eslint",
			"golangci_lint_ls",
			"gopls",
			"html",
			"intelephense",
			"lwc_ls",
			"prismals",
			"pyright",
			"rust_analyzer",
			"terraformls",
			"tflint",
			"ts_ls",
			"visualforce_ls",
			"zls",
		}
		for _, lspserver in pairs(lsp_servers) do
			lspconfig[lspserver].setup({
				capabilities = capabilities,
			})
		end
		lspconfig.tailwindcss.setup({
			capabilities = capabilities,
			filetypes = { "php", "typescriptreact" },
			-- root_markers = { "n98-magerun", "tailwind.config.js", "tailwind.config.ts", "package.json" },
			--          root_dir = nil,
			root_dir = function(fname)
				local temp =
					require("lspconfig.util").root_pattern("n98-magerun", "tailwind.config.js", "tailwind.config.ts")(
						fname
					)
				if temp ~= nil then
					return temp
				end
				if fname:match("%.html$") then
					return vim.fn.getcwd()
				end
				return temp
			end,
		})

		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					workspace = {
						checkThirdParty = false,
						library = {
							"${3rd}/luv/library",
							unpack(vim.api.nvim_get_runtime_file("", true)),
						},
					},
					diagnostics = {
						globals = { "vim", "it", "describe", "before_each", "after_each" },
					},
				},
			},
		})
		lspconfig.apex_ls.setup({
			apex_jar_path = vim.fn.stdpath("data")
				.. "/mason/packages/apex-language-server/extension/dist/apex-jorje-lsp.jar",
			apex_enable_semantic_errors = true, -- Whether to allow Apex Language Server to su rface semantic errors
			apex_enable_completion_statistics = true, -- Whether to allow Apex Language Server to collect telemetry on code completion usage
			filetypes = { "apex" },
			root_dir = require("lspconfig.util").root_pattern("sfdx-project.json", ".git"),
		})
		require("fidget").setup({})
		require("mason").setup()
		-- require("mason-lspconfig").setup({
		-- 	ensure_installed = {
		-- 		"lua_ls",
		-- 		"rust_analyzer",
		-- 		"gopls",
		-- 	},
		-- 	handlers = {
		-- 		function(server_name) -- default handler (optional)
		-- 			capabilities.documentFormattingProvider = true
		-- 			require("lspconfig")[server_name].setup({
		-- 				capabilities = capabilities,
		-- 			})
		-- 		end,
		-- 		["lua_ls"] = function()
		-- 			lspconfig.lua_ls.setup({
		-- 				capabilities = capabilities,
		-- 				settings = {
		-- 					Lua = {
		-- 						runtime = { version = "LuaJIT" },
		-- 						workspace = {
		-- 							checkThirdParty = false,
		-- 							library = {
		-- 								"${3rd}/luv/library",
		-- 								unpack(vim.api.nvim_get_runtime_file("", true)),
		-- 							},
		-- 						},
		-- 						diagnostics = {
		-- 							globals = { "vim", "it", "describe", "before_each", "after_each" },
		-- 						},
		-- 					},
		-- 				},
		-- 			})
		-- 		end,
		-- 	},
		-- })

		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- For luasnip users.
				{ name = "path" },
			}, {
				{ name = "buffer" },
			}),
		})

		vim.diagnostic.config({
			-- update_in_insert = true,
			virtual_text = false,
			virtual_lines = false,
			signs = { priority = 9999 },
			underline = true,
			update_in_insert = false, -- false so diags are updated on InsertLeave
			-- virtual_text = { current_line = true, severity = { min = "INFO", max = "WARN" } },
			-- virtual_lines = { current_line = true, severity = { min = "ERROR" } },
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "if_many",
				header = "",
				prefix = "",
			},
		})
	end,
}
