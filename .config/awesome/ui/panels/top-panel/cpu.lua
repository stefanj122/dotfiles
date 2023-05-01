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
	local cpu_icon = wibox.widget({
		markup = helpers.ui.colorize_text("", beautiful.white),
		font = beautiful.icon_font .. "Round 18",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local icon = wibox.widget({

		id = "icon",
		widget = wibox.widget.imagebox,
		image = gears.color.recolor_image(icons.cpu, "#AAAAAA"),
		resize = true,
	})

	local cpu = wibox.widget({
		icon,
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(1),
	})

	local cpu_usage = wibox.widget({
		id = "cpu_load",
		text = "0%",
		font = beautiful.font_name .. "Medium 12",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local cpu_mhz = wibox.widget({
		id = "cpu_mhz",
		text = "0Mhz",
		font = beautiful.font_name .. "Medium 12",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local cpu_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
		cpu,
		cpu_usage,
		cpu_mhz,
	})
	local popup = require("ui.panels.top-panel.cpu_popups")()

	local widget = wbutton.elevated.state({
		child = cpu_widget,
		normal_bg = beautiful.wibar_bg,
		on_release = function()
			popup:emit_signal("widget::cpu_popups:show")
		end,
	})
	local total_prev = 0
	local idle_prev = 0

	watch([[ cat "/proc/stat" | grep '^cpu ' ]], 3, function(_, stdout)
		local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
			stdout:match("(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s")

		local total = user + nice + system + idle + iowait + irq + softirq + steal

		local diff_idle = idle - idle_prev
		local diff_total = total - total_prev
		local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

		cpu_usage:set_text(tostring(math.floor(diff_usage)) .. "%")

		total_prev = total
		idle_prev = idle

		collectgarbage("collect")
	end)

	watch([[ bash -c "cat /proc/cpuinfo | grep "MHz" | awk '{print int($4)}'" ]], 3, function(_, stdout)
		local cpu_freq = {}

		for value in stdout:gmatch("%d+") do
			table.insert(cpu_freq, value)
		end

		local clock_mode = "average"
		local average = 0

		if clock_mode == "average" then
			for i = 1, #cpu_freq do
				average = average + cpu_freq[i]
			end
			average = math.floor(average / #cpu_freq)
			cpu_mhz:set_text(tonumber(average) .. "Mhz")
		elseif clock_mode then
			cpu_mhz:set_text(tonumber(cpu_freq[clock_mode]) .. "Mhz")
		end
	end)

	return widget
end
