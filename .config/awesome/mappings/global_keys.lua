-- Awesome Libs
local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local ruled = require("ruled")

local modkey = user_vars.modkey
local altkey = user_vars.altkey

return gears.table.join(
	awful.key({ modkey }, "s", hotkeys_popup.show_help, { description = "Cheat sheet", group = "Awesome" }),
	-- Tag browsing
	awful.key({ modkey }, "#113", awful.tag.viewprev, { description = "View previous tag", group = "Tag" }),
	awful.key({ modkey }, "#114", awful.tag.viewnext, { description = "View next tag", group = "Tag" }),
	awful.key({ modkey }, "#66", awful.tag.history.restore, { description = "Go back to last tag", group = "Tag" }),
	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "Focus next client by index", group = "Client" }),
	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "Focus previous client by index", group = "Client" }),
	awful.key({ modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "Swap with next client by index", group = "Client" }),
	awful.key({ modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "Swap with previous client by index", group = "Client" }),
	awful.key({ modkey, "Control" }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "Focus the next screen", group = "Screen" }),
	awful.key({ modkey, "Control" }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "Focus the previous screen", group = "Screen" }),
	awful.key(
		{ modkey },
		"#30",
		awful.client.urgent.jumpto,
		{ description = "Jump to urgent client", group = "Client" }
	),
	awful.key({ modkey }, "Return", function()
		awful.spawn(user_vars.terminal .. " -e fish")
	end, { description = "Open terminal", group = "Applications" }),
	awful.key({ modkey, "Shift" }, "Return", function()
		awful.spawn(user_vars.terminal .. " -e tmux a")
	end, { description = "Open terminal", group = "Applications" }),
	awful.key({ modkey, "Control" }, "r", awesome.restart, { description = "Reload awesome", group = "Awesome" }),
	awful.key({ modkey }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "Increase client width", group = "Layout" }),
	awful.key({ modkey }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "Decrease client width", group = "Layout" }),
	awful.key({ modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "Increase the number of columns", group = "Layout" }),
	awful.key({ modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "Decrease the number of columns", group = "Layout" }),
	awful.key({ modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "Select previous layout", group = "Layout" }),
	awful.key({ modkey }, "Tab", function()
		awful.layout.inc(1)
	end, { description = "Select next layout", group = "Layout" }),
	awful.key({ modkey }, "e", function()
		awful.spawn("rofi_launcher")
	end, { descripton = "Application launcher", group = "Application" }),
	awful.key({}, "#107", function()
		awful.spawn.easy_async_with_shell(
			user_vars.screenshot_program .. " /home/stefanj/Pictures/$(date +%m-%d-%y-%H-%M-%S-full-screenshot).png",
			function() end
		)
	end, { description = "Screenshot", group = "Applications" }),
	awful.key({ modkey }, "Print", function()
		awful.spawn.easy_async_with_shell(
			user_vars.screenshot_program
				.. " -s /home/stefanj/Pictures/$(date +%m-%d-%y-%H-%M-%S-partial-screenshot).png",
			function() end
		)
	end, { description = "Screenshot partial", group = "Applications" }),
	awful.key({}, "XF86AudioLowerVolume", function(c)
		awful.spawn.easy_async_with_shell("pamixer --allow-boost --set-limit 150 -d 3 ", function()
			awesome.emit_signal("module::volume_osd:show", true)
			awesome.emit_signal("module::slider:update")
			awesome.emit_signal("widget::volume_osd:rerun")
		end)
	end, { description = "Lower volume", group = "System" }),
	awful.key({}, "XF86AudioRaiseVolume", function(c)
		awful.spawn.easy_async_with_shell("pamixer --allow-boost --set-limit 150 -i 3", function()
			awesome.emit_signal("module::volume_osd:show", true)
			awesome.emit_signal("module::slider:update")
			awesome.emit_signal("widget::volume_osd:rerun")
		end)
	end, { description = "Increase volume", group = "System" }),
	awful.key({}, "XF86AudioMute", function(c)
		awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")
		awesome.emit_signal("module::volume_osd:show", true)
		awesome.emit_signal("module::slider:update")
		awesome.emit_signal("widget::volume_osd:rerun")
	end, { description = "Mute volume", group = "System" }),
	awful.key({}, "XF86MonBrightnessUp", function(c)
		awful.spawn.easy_async_with_shell("brightnessctl s 5%+", function(stdout)
			awesome.emit_signal("module::brightness_osd:show", true)
			awesome.emit_signal("module::brightness_slider:update")
			awesome.emit_signal("widget::brightness_osd:rerun")
		end)
	end, { description = "Raise backlight brightness", group = "System" }),
	awful.key({}, "XF86MonBrightnessDown", function(c)
		awful.spawn.easy_async_with_shell("brightnessctl s 5%-", function(stdout)
			awesome.emit_signal("module::brightness_osd:show", true)
			awesome.emit_signal("module::brightness_slider:update")
			awesome.emit_signal("widget::brightness_osd:rerun")
		end)
	end, { description = "Lower backlight brightness", group = "System" }),
	awful.key({}, "XF86AudioPlay", function(c)
		awful.spawn("playerctl play-pause")
	end, { description = "Play / Pause audio", group = "System" }),
	awful.key({}, "XF86AudioNext", function(c)
		awful.spawn("playerctl next")
	end, { description = "Play / Pause audio", group = "System" }),
	awful.key({}, "XF86AudioPrev", function(c)
		awful.spawn("playerctl previous")
	end, { description = "Play / Pause audio", group = "System" }),
	awful.key({ modkey }, "space", function()
		awesome.emit_signal("kblayout::toggle")
	end, { description = "Toggle keyboard layout", group = "System" }),
	awful.key({ modkey }, "#22", function()
		awful.spawn.easy_async_with_shell(
			[[xprop | grep WM_CLASS | awk '{gsub(/"/, "", $4); print $4}']],
			function(stdout)
				if stdout then
					ruled.client.append_rule({
						rule = { class = stdout:gsub("\n", "") },
						properties = {
							floating = true,
						},
					})
					awful.spawn.easy_async_with_shell("cat ~/.config/awesome/src/assets/rules.txt", function(stdout2)
						for class in stdout2:gmatch("%a+") do
							if class:match(stdout:gsub("\n", "")) then
								return
							end
						end
						awful.spawn.with_shell(
							"echo -n '" .. stdout:gsub("\n", "") .. ";' >> ~/.config/awesome/src/assets/rules.txt"
						)
						local c = mouse.screen.selected_tag:clients()
						for j, client in ipairs(c) do
							if client.class:match(stdout:gsub("\n", "")) then
								client.floating = true
							end
						end
					end)
				end
			end
		)
	end),
	awful.key({ modkey, "Shift" }, "#22", function()
		awful.spawn.easy_async_with_shell(
			[[xprop | grep WM_CLASS | awk '{gsub(/"/, "", $4); print $4}']],
			function(stdout)
				if stdout then
					ruled.client.append_rule({
						rule = { class = stdout:gsub("\n", "") },
						properties = {
							floating = false,
						},
					})
					awful.spawn.easy_async_with_shell([[
                                REMOVE="]] .. stdout:gsub("\n", "") .. [[;"
                                STR=$(cat ~/.config/awesome/src/assets/rules.txt)
                                echo -n ${STR//$REMOVE/} > ~/.config/awesome/src/assets/rules.txt
                            ]], function(stdout2)
						local c = mouse.screen.selected_tag:clients()
						for j, client in ipairs(c) do
							if client.class:match(stdout:gsub("\n", "")) then
								client.floating = false
							end
						end
					end)
				end
			end
		)
	end),
	awful.key({ modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			client.focus = c
			c:raise()
		end
	end, { description = "unhide", group = "Client" }),
	awful.key({ "Mod1" }, "b", function()
		awful.util.spawn("brave")
	end, { description = "brave", group = "gui apps" }),
	awful.key({ modkey }, "p", function()
		awful.spawn.with_shell("project.sh")
	end),
	awful.key({ modkey }, "F1", function()
		awful.spawn.with_shell("rofi_powermenu")
	end),
	awful.key({ altkey }, "q", function()
		awful.util.spawn("qutebrowser")
	end, { description = "Qutebrowser", group = "gui apps" }),
	awful.key({ altkey }, "e", function()
		awful.util.spawn("quicklinks")
	end, { description = "show dmenu", group = "hotkeys" }),
	awful.key({ altkey, "Shift" }, "k", function()
		awesome.emit_signal("widget::battery:update")
	end)
)
