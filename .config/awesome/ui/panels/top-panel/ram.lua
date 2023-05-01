local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi
local helpers = require("helpers")
local wbutton = require("ui.widgets.button")
local watch = awful.widget.watch
local gears = require("gears")
local icons = require("icons")
--- Battery Widget
--- ~~~~~~~~~~~~~~

return function()
	--	local icon = wibox.widget({
	--		markup = helpers.ui.colorize_text("", beautiful.white),
	--		font = beautiful.icon_font .. "Round 18",
	--		align = "center",
	--		valign = "center",
	--		widget = wibox.widget.textbox,
	--	})
	local icon = wibox.widget({

		id = "icon",
		widget = wibox.widget.imagebox,
		image = gears.color.recolor_image(icons.ram, "#AAAAAA"),
		resize = true,
	})

	local ram = wibox.widget({
		id = "ram",
		text = "0Mhz",
		font = beautiful.font_name .. "Medium 12",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local cpu_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
		icon,
		ram,
	})

	local widget = wbutton.elevated.state({
		child = cpu_widget,
		normal_bg = beautiful.wibar_bg,
		on_release = function() end,
	})

	watch([[ bash -c "cat /proc/meminfo| grep Mem | awk '{print $2}'" ]], 3, function(_, stdout)
		local MemTotal, MemFree, MemAvailable = stdout:match("(%d+)\n(%d+)\n(%d+)\n")
		local MemInfo = tostring(
			string.format("%.1f", ((MemTotal - MemAvailable) / 1024 / 1024))
				.. "/"
				.. string.format("%.1f", (MemTotal / 1024 / 1024))
				.. "GB"
		):gsub(",", ".")
		local MemProc =
			tostring(string.format("%.1f", (((MemTotal - MemAvailable) / MemTotal) * 100)) .. "%"):gsub(",", ".")
		ram:set_text(MemProc)
	end)

	return widget
end
