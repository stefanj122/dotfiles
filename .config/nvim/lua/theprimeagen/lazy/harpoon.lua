-- local harpoon = require("harpoon")
-- vim.keymap.set("n", "<C-h>", function()
-- 	harpoon:list():select(1)
-- end)
return {
	"theprimeagen/harpoon",
	branch = "harpoon2",
	config = function()
		local harpoon = require("harpoon")

		-- REQUIRED
		harpoon:setup({
			settings = {
				save_on_toggle = true,
				save_on_ui_close = true,
			},
		})
		-- REQUIRED

		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Add a file to the Harpoon list" })
		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end,{ desc = "Toggle harpoon list" } )

		vim.keymap.set("n", "<C-h>", function()
			harpoon:list():select(1)
		end, { desc = "Open first item in harpoon list" })
		vim.keymap.set("n", "<C-t>", function()
			harpoon:list():select(2)
		end, { desc = "Open second item in harpoon list" })
		vim.keymap.set("n", "<C-n>", function()
			harpoon:list():select(3)
		end, { desc = "Open third item in harpoon list" })
		vim.keymap.set("n", "<C-s>", function()
			harpoon:list():select(4)
		end, { desc = "Open fourth item in harpoon list" })

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<C-S-P>", function()
			harpoon:list():prev()
		end)
		vim.keymap.set("n", "<C-S-N>", function()
			harpoon:list():next()
		end)
	end,
}
