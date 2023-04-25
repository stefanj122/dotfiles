--------------------------------
-- This is the network widget --
--------------------------------

-- Awesome Libs
local awful = require("awful")
local color = require("src.theme.colors")
local dpi = require("beautiful").xresources.apply_dpi
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")
local helpers = require("lain.helpers")
require("src.core.signals")

-- Icon directory path
local icondir = awful.util.getdir("config") .. "src/assets/icons/network/"

-- Insert your interfaces here, get the from ip a
local interfaces = {
	wlan_interface = user_vars.network.wlan,
	lan_interface = user_vars.network.ethernet,
}

local network_mode = nil

local net = { widget = wibox.widget.textbox(), devices = {} }
local timeout = 2
local units = 1024 -- KB
local wifi_state = "off"
local eth_state = "off"

-- Compatibility with old API where iface was a string corresponding to 1 interface
net.iface = {}

function net.get_device()
	helpers.line_callback("ip link", function(line)
		net.iface[#net.iface + 1] = not string.match(line, "LOOPBACK") and string.match(line, "(%w+): <") or nil
	end)
end
if #net.iface == 0 then
	net.get_device()
end

-- Returns the network widget
return function()
	local startup = true
	local reconnect_startup = true
	local wifi_strength
	local network_widget = wibox.widget({
		{
			{
				{
					{
						{
							id = "icon",
							image = gears.color.recolor_image(icondir .. "no-internet" .. ".svg", color["Grey900"]),
							widget = wibox.widget.imagebox,
							resize = false,
						},
						id = "icon_layout",
						widget = wibox.container.place,
					},
					id = "icon_margin",
					top = dpi(2),
					widget = wibox.container.margin,
				},
				spacing = dpi(10),
				{
					id = "label",
					visible = false,
					valign = "center",
					align = "center",
					widget = wibox.widget.textbox,
				},
				id = "network_layout",
				layout = wibox.layout.fixed.horizontal,
			},
			id = "container",
			left = dpi(8),
			right = dpi(8),
			widget = wibox.container.margin,
		},
		bg = color["Red200"],
		fg = color["Grey900"],
		shape = function(cr, width, height)
			gears.shape.rounded_rect(cr, width, height, 5)
		end,
		widget = wibox.container.background,
	})

	local network_tooltip = awful.tooltip({
		text = "Loading",
		objects = { network_widget },
		mode = "inside",
		preferred_alignments = "middle",
		margins = dpi(10),
	})

	local check_for_internet = [=[
        status_ping=0
        packets="$(ping -q -w2 -c2 1.1.1.1 | grep -o "100% packet loss")"
        if [ ! -z "${packets}" ];
        then
            status_ping=0
        else
            status_ping=1
        fi
        if [ $status_ping -eq 0 ];
        then
            echo "Connected but no internet"
        fi
    ]=]

	local update_startup = function()
		if startup then
			startup = false
		end
	end

	local update_reconnect_startup = function(status)
		reconnect_startup = status
	end

	local update_tooltip = function(message)
		network_tooltip:set_markup(message)
	end

	local network_notify = function(message, title, app_name, icon)
		naughty.notification({
			text = message,
			title = title,
			app_name = app_name,
			icon = gears.color.recolor_image(icon, color["White"]),
			timeout = 3,
		})
	end

	local update_wireless = function()
		network_mode = "wireless"

		local notify_connected = function(essid)
			local message = "You are now connected to " .. essid
			local title = "Connection successfull"
			local app_name = "System Notification"
			local icon = icondir .. "wifi-strength-4.svg"
			network_notify(message, title, app_name, icon)
		end

		local update_wireless_data = function(healthy)
			awful.spawn.easy_async_with_shell([[ iw dev ]] .. interfaces.wlan_interface .. [[ link ]], function(stdout)
				local essid = stdout:match("SSID: (.-)\n") or "N/A"
				local bitrate = stdout:match("tx bitrate: (.+/s)") or "N/A"
				local message = "Connected to <b>"
					.. essid
					.. "</b>\nSignal strength <b>"
					.. tostring(wifi_strength)
					.. "%</b>\n"
					.. "Bit rate <b>"
					.. tostring(bitrate)
					.. "</b>"

				if healthy then
					update_tooltip(message)
				else
					update_tooltip("You are connected but have no internet" .. message)
				end

				if reconnect_startup or startup then
					notify_connected(essid)
					update_reconnect_startup(false)
				end
			end)
		end

		local update_wireless_icon = function(strength)
			awful.spawn.easy_async_with_shell(check_for_internet, function(stdout)
				local icon = "wifi-strength"
				if not stdout:match("Connected but no internet") then
					if startup or reconnect_startup then
						awesome.emit_signal("system::network_connected")
					end
					icon = icon .. "-" .. tostring(strength)
					update_wireless_data(true)
				else
					icon = icon .. "-" .. tostring(strength)
					update_wireless_data(false)
				end
				network_widget.container.network_layout.spacing = dpi(8)
				network_widget.container.network_layout.icon_margin.icon_layout.icon:set_image(
					gears.color.recolor_image(icondir .. icon .. ".svg", color["Grey900"])
				)
			end)
		end

		local update_wireless_strength = function()
			awful.spawn.easy_async_with_shell(
				[[ awk 'NR==3 {printf "%3.0f", ($3/70)*100}' /proc/net/wireless ]],
				function(stdout)
					net_now = {
						devices = {},
						-- Bytes since last iteration
						sent = 0,
						received = 0,
					}

					for _, dev in ipairs(net.iface) do
						local dev_now = {}
						local dev_before = net.devices[dev] or { last_t = 0, last_r = 0 }
						local now_t = tonumber(
							helpers.first_line(string.format("/sys/class/net/%s/statistics/tx_bytes", dev)) or 0
						)
						local now_r = tonumber(
							helpers.first_line(string.format("/sys/class/net/%s/statistics/rx_bytes", dev)) or 0
						)

						dev_now.carrier = helpers.first_line(string.format("/sys/class/net/%s/carrier", dev)) or "0"
						dev_now.state = helpers.first_line(string.format("/sys/class/net/%s/operstate", dev)) or "down"

						dev_now.sent = (now_t - dev_before.last_t) / timeout / units
						dev_now.received = (now_r - dev_before.last_r) / timeout / units

						net_now.sent = net_now.sent + dev_now.sent
						net_now.received = net_now.received + dev_now.received

						dev_now.sent = string.format("%.1f", dev_now.sent)
						dev_now.received = string.format("%.1f", dev_now.received)

						dev_now.last_t = now_t
						dev_now.last_r = now_r

						if
							wifi_state == "on"
							and helpers.first_line(string.format("/sys/class/net/%s/uevent", dev)) == "DEVTYPE=wlan"
							and string.match(dev_now.carrier, "1")
						then
							dev_now.wifi = true
							dev_now.signal = tonumber(
								string.match(helpers.lines_from("/proc/net/wireless")[3], "(%-%d+%.)")
							) or nil
						end

						if
							eth_state == "on"
							and helpers.first_line(string.format("/sys/class/net/%s/uevent", dev)) ~= "DEVTYPE=wlan"
							and string.match(dev_now.carrier, "1")
						then
							dev_now.ethernet = true
						end

						net.devices[dev] = dev_now

						net_now.carrier = dev_now.carrier
						net_now.state = dev_now.state
						net_now.devices[dev] = dev_now
						-- net_now.sent and net_now.received will be
						-- the totals across all specified devices
					end

					net_now.sent = string.format("%.1f", net_now.sent)
					net_now.received = string.format("%.1f", net_now.received)

					if not tonumber(stdout) then
						return
					end
					wifi_strength = tonumber(stdout)
					network_widget.container.network_layout.spacing = dpi(8)
					network_widget.container.network_layout.label.visible = true
					network_widget.container.network_layout.label:set_text(tostring(net_now.received .. "kb/s"))
					local wifi_strength_rounded = math.floor(wifi_strength / 25 + 0.5)
					update_wireless_icon(wifi_strength_rounded)
				end
			)
		end

		update_wireless_strength()
		update_startup()
	end

	local update_wired = function()
		network_mode = "wired"

		local notify_connected = function()
			local message = "You are now connected to " .. interfaces.lan_interface
			local title = "Connection successfull"
			local app_name = "System Notification"
			local icon = icondir .. "ethernet.svg"
			network_notify(message, title, app_name, icon)
		end

		awful.spawn.easy_async_with_shell(check_for_internet, function(stdout)
			local icon = "ethernet"

			if stdout:match("Connected but no internet") then
				icon = "no-internet"
				update_tooltip("No internet")
			else
				update_tooltip("You are connected to:\nEthernet Interface <b>" .. interfaces.lan_interface .. "</b>")
				if startup or reconnect_startup then
					awesome.emit_signal("system::network_connected")
					notify_connected()
					update_startup()
				end
				update_reconnect_startup(false)
			end
			network_widget.container.network_layout.label.visible = false
			network_widget.container.network_layout.spacing = dpi(0)
			network_widget.container.network_layout.icon_margin.icon_layout.icon:set_image(icondir .. icon .. ".svg")
		end)
	end

	local update_disconnected = function()
		local notify_wireless_disconnected = function(essid)
			local message = "WiFi has been disconnected"
			local title = "Connection lost"
			local app_name = "System Notification"
			local icon = icondir .. "wifi-strength-off-outline.svg"
			network_notify(message, title, app_name, icon)
		end
		local notify_wired_disconnected = function(essid)
			local message = "Ethernet has been unplugged"
			local title = "Connection lost"
			local app_name = "System Notification"
			local icon = icondir .. "no-internet.svg"
			network_notify(message, title, app_name, icon)
		end
		local icon = "wifi-strength-off-outline"
		if network_mode == "wireless" then
			icon = "wifi-strength-off-outline"
			if not reconnect_startup then
				update_reconnect_startup(true)
				notify_wireless_disconnected()
			end
		elseif network_mode == "wired" then
			icon = "no-internet"
			if not reconnect_startup then
				update_reconnect_startup(true)
				notify_wired_disconnected()
			end
		end
		network_widget.container.network_layout.label.visible = false
		update_tooltip("Network unreachable")
		network_widget.container.network_layout.spacing = dpi(0)
		network_widget.container.network_layout.icon_margin.icon_layout.icon:set_image(
			gears.color.recolor_image(icondir .. icon .. ".svg", color["Grey900"])
		)
	end

	local check_network_mode = function()
		awful.spawn.easy_async_with_shell([=[
                wireless="]=] .. tostring(interfaces.wlan_interface) .. [=["
                wired="]=] .. tostring(interfaces.lan_interface) .. [=["
                net="/sys/class/net/"
                wireless_state="down"
                wired_state="down"
                network_mode=""
                function check_network_state(){
                    if [[ "${wireless_state}" == "up" ]];
                    then
                        network_mode="wireless"
                    elif [[ "${wired_state}" == "up" ]];
                    then
                        network_mode="wired"
                    else
                        network_mode="No internet connected"
                    fi
                }
                function check_network_directory(){
                    if [[ -n "${wireless}" && -d "${net}${wireless}" ]];
                    then
                        wireless_state="$(cat "${net}${wireless}/operstate")"
                    fi
                    if [[ -n "${wired}" && -d "${net}${wired}" ]];
                    then
                        wired_state="$(cat "${net}${wired}/operstate")"
                    fi
                    check_network_state
                }
                function print_network_mode(){
                    check_network_directory
                    printf "${network_mode}"
                }
                print_network_mode
            ]=], function(stdout)
			local mode = stdout:gsub("%\n", "")
			if stdout:match("No internet connected") then
				update_disconnected()
			elseif stdout:match("wireless") then
				update_wireless()
			elseif stdout:match("wired") then
				update_wired()
			end
		end)
	end

	gears.timer({
		timeout = 2,
		autostart = true,
		call_now = true,
		callback = function()
			check_network_mode()
		end,
	})

	-- Signals
	Hover_signal(network_widget, color["Red200"], color["Grey900"])

	network_widget:connect_signal("button::press", function()
		awful.spawn("gnome-control-center wlan")
	end)

	return network_widget
end
