return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy", -- Or `LspAttach`
	priority = 1000, -- needs to be loaded in first
	config = function()
		require("tiny-inline-diagnostic").setup({
			options = {
				multilines = {
					-- Enable multiline diagnostic messages
					enabled = true,

					-- Always show messages on all lines for multiline diagnostics
					always_show = true,
				},
			},
			preset = "amongus",
			transparent_bg = false,
		})
		vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
	end,
}
