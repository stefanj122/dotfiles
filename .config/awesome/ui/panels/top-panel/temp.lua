local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
local wbutton = require("ui.widgets.button")
local watch = awful.widget.watch
local gears = require("gears")
local icons = require("icons")

--- Battery Widget
--- ~~~~~~~~~~~~~~

return function()
	--	local icon = wibox.widget({
	--		markup = helpers.ui.colorize_text("", beautiful.white),
	--		font = beautiful.icon_font .. "Round 18",
	--		align = "center",
	--		valign = "center",
	--		widget = wibox.widget.textbox,
	--	})

	local icon = wibox.widget({

		id = "icon",
		widget = wibox.widget.imagebox,
		image = gears.color.recolor_image(icons.thermometer, "#AAAAAA"),
		resize = true,
	})

	local cpu_temp = wibox.widget({
		id = "cpu_temp",
		text = "0°C",
		font = beautiful.font_name .. "Medium 12",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local gpu_temp = wibox.widget({
		id = "gpu_temp",
		text = "0°C",
		font = beautiful.font_name .. "Medium 12",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local temp_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
		icon,
		cpu_temp,
		gpu_temp,
	})

	local widget = wbutton.elevated.state({
		child = temp_widget,
		normal_bg = beautiful.wibar_bg,
		on_release = function() end,
	})

	watch([[ bash -c "sensors | grep 'Package' | awk '{print $4}'" ]], 3, function(_, stdout)
		local temp_num = tonumber(stdout:match("%d+"))
		cpu_temp:set_text(temp_num  .. "°C")
	end)

	watch(
		[[ bash -c "nvidia-smi -q -d TEMPERATURE | grep 'GPU Current Temp' | awk '{print $5}'"]],
		3,
		function(_, stdout)
			local temp_num = tonumber(stdout)

			gpu_temp:set_text(tostring(temp_num) .. "°C")
		end
	)

	return widget
end
