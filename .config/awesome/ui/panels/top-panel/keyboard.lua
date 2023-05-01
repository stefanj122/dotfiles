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
	local icon = wibox.widget({

		id = "icon",
		widget = wibox.widget.imagebox,
		image = gears.color.recolor_image(icons.keyboard, "#AAAAAA"),
		resize = true,
	})

	local keyboard = wibox.widget({
		id = "keybaord",
		text = "US",
		font = beautiful.font_name .. "Medium 12",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	local keyboard_widget = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
		icon,
		keyboard,
	})

	local popup = awful.popup({
		ontop = true,
		visible = false,
		shape = gears.shape.rounded_rect,
		border_width = 1,
		border_color = beautiful.bg_normal,
		maximum_width = 250,
		offset = { y = 5 },
		widget = {},
	})
	popup:connect_signal("widget::keyboard:show", function()
		if popup.visible then
			popup.visible = not popup.visible
		else
			popup:move_next_to(mouse.current_widget_geometry)
		end
	end)
	awesome.connect_signal("widget::keyboard:hide", function()
		popup.visible = false
	end)
	local rs = wbutton.text.state({
		text_normal_bg = beautiful.white,
		normal_bg = beautiful.accent,
		font = beautiful.font .. "Round ",
		size = 18,
		text = "(RS) SRB",
		on_release = function()
			awful.spawn("setxkbmap rs")
			popup:emit_signal("widget::keyboard:update")
			popup:emit_signal("widget::keyboard:show")
		end,
	})
	local us = wbutton.text.state({
		text_normal_bg = beautiful.white,
		normal_bg = beautiful.accent,
		font = beautiful.font .. "Round ",
		size = 18,
		text = "(US) ENG",
		on_release = function()
			awful.spawn("setxkbmap us")
			popup:emit_signal("widget::keyboard:update")
			popup:emit_signal("widget::keyboard:show")
		end,
	})

	local rs_latin = wbutton.text.state({
		text_normal_bg = beautiful.white,
		normal_bg = beautiful.accent,
		font = beautiful.font .. "Round ",
		size = 18,
		text = "(RS-Latin) SRB",
		on_release = function()
			awful.spawn("setxkbmap rs(latin)")
			popup:emit_signal("widget::keyboard:update")
			popup:emit_signal("widget::keyboard:show")
		end,
	})
	local hor_sep = wibox.widget({
		widget = wibox.widget.separator,
		orientation = "horizontal",
		forced_width = 22,
		forced_height = 2,
		color = "#353535",
	})
	popup:setup({
		{
			us,
			hor_sep,
			rs,
			hor_sep,
			rs_latin,
			layout = wibox.layout.fixed.vertical,
		},
		margins = 8,
		bg = beautiful.wibar_bg,
		widget = wibox.container.margin,
	})

	local widget = wbutton.elevated.state({
		child = keyboard_widget,
		normal_bg = beautiful.wibar_bg,
		on_release = function()
			popup:emit_signal("widget::keyboard:show")
		end,
	})

	local function update()
		awful.spawn.easy_async_with_shell([[ bash -c "xkb-switch" ]], function(stdout)
			keyboard:set_text(stdout)
		end)
	end
	update()

	popup:connect_signal("widget::keyboard:update", update)

	return widget
end
