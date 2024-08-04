local wezterm = require("wezterm")

local config = {}

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
return config
