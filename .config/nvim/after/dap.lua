local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

-- setup adapters
require("dap-vscode-js").setup({
	debugger_path = "/home/stefanj/.local/share/nvim/site/pack/packer/opt/vscode-js-debug/",
	-- debugger_cmd = { "js-debug-adapter" },
	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
})

-- custom adapter for running tasks before starting debug
local custom_adapter = "pwa-node-custom"
dap.adapters[custom_adapter] = function(cb, config)
	if config.preLaunchTask then
		local async = require("plenary.async")
		local notify = require("notify").async

		async.run(function()
			---@diagnostic disable-next-line: missing-parameter
			notify("Running [" .. config.preLaunchTask .. "]").events.close()
		end, function()
			vim.fn.system(config.preLaunchTask)
			config.type = "pwa-node"
			dap.run(config)
		end)
	end
end

-- language config
for _, language in ipairs({ "typescript", "javascript" }) do
	dap.configurations[language] = {
		{
			name = "Launch",
			type = "pwa-node",
			request = "launch",
			program = "${file}",
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			sourceMaps = true,
			skipFiles = { "<node_internals>/**" },
			protocol = "inspector",
			console = "integratedTerminal",
		},
		{
			name = "Attach to node process",
			type = "pwa-node",
			request = "attach",
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			processId = require("dap.utils").pick_process,
		},
		{
			name = "Debug Main Process (Electron)",
			type = "pwa-node",
			request = "launch",
			program = "${workspaceFolder}/node_modules/.bin/electron",
			args = {
				"${workspaceFolder}/dist/index.js",
			},
			outFiles = {
				"${workspaceFolder}/dist/*.js",
			},
			resolveSourceMapLocations = {
				"${workspaceFolder}/dist/**/*.js",
				"${workspaceFolder}/dist/*.js",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			sourceMaps = true,
			skipFiles = { "<node_internals>/**" },
			protocol = "inspector",
			console = "integratedTerminal",
		},
		{
			name = "Compile & Debug Main Process (Electron)",
			type = custom_adapter,
			request = "launch",
			preLaunchTask = "npm run build-ts",
			program = "${workspaceFolder}/node_modules/.bin/electron",
			args = {
				"${workspaceFolder}/dist/index.js",
			},
			outFiles = {
				"${workspaceFolder}/dist/*.js",
			},
			resolveSourceMapLocations = {
				"${workspaceFolder}/dist/**/*.js",
				"${workspaceFolder}/dist/*.js",
			},
			rootPath = "${workspaceFolder}",
			cwd = "${workspaceFolder}",
			sourceMaps = true,
			skipFiles = { "<node_internals>/**" },
			protocol = "inspector",
			console = "integratedTerminal",
		},
	}
end

--- ketbindings

vim.keymap.set("n", "<leader>dt", dapui.toggle, {})
vim.keymap.set("n", "<leader>dc", dap.continue, {})
vim.keymap.set("n", "<leader>dl", dap.step_over, {})
vim.keymap.set("n", "<leader>dk", dap.step_into, {})
vim.keymap.set("n", "<leader>dx", dap.step_out, {})
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, {})
vim.keymap.set({ "n", "v" }, "<Leader>dh", function()
	require("dap.ui.widgets").hover()
end)
vim.keymap.set("n", "<Leader>ds", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end)
