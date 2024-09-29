local wezterm = require("wezterm")

local config = {}
local keys = require("keys")

config.color_scheme = "Dracula"
config.default_prog = { "/usr/bin/fish", "-l" }
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = "NeverPrompt"
config.window_background_gradient = {
	orientation = "Horizontal",
	colors = {
		"#0f0c29",
		"#24243e",
		"#302b63",
	},
	interpolation = "Linear",
	blend = "Rgb",
}
config.exit_behavior = 'Hold'
 config.window_background_image = "/home/stefanj/Pictures/bingwall.png"
config.keys = keys.keys
config.disable_default_key_bindings = true
return config
