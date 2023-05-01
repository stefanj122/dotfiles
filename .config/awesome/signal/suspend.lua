local lgi = require("lgi")
local Gio = lgi.require("Gio")
local awful = require("awful")

local function listen_to_signals()
	local bus = lgi.Gio.bus_get_sync(Gio.BusType.SYSTEM)
	local sender = "org.freedesktop.login1"
	local interface = "org.freedesktop.login1.Manager"
	local object = "/org/freedesktop/login1"
	local member = "PrepareForSleep"
	bus:signal_subscribe(
		sender,
		interface,
		member,
		object,
		nil,
		Gio.DBusSignalFlags.NONE,
		function(bus, sender, object, interface, signal, params)
			-- "signals are sent right before (with the argument True) and
			-- after (with the argument False) the system goes down for
			-- reboot/poweroff, resp. suspend/hibernate."
			if params[1] then
				-- This code is run before suspend. You can replace the following with something else.
				lock_screen_show()
			end
		end
	)
end

listen_to_signals()
