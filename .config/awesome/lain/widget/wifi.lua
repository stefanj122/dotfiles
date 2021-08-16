--[[

     Licensed under GNU General Public License v2
      * (c) 2013, Luca CPZ
      * (c) 2010, Adrian C. <anrxc@sysphere.org>

--]]

local helpers = require("lain.helpers")
local awful = require("awful")
local shell   = require("awful.util").shell
local wibox   = require("wibox")
local string  = string


local function factory(args)
    local wifi     = { widget = wibox.widget.textbox() }
    local args     = args or {}
    local timeout  = args.timeout or 30
    local settings = args.settings or function() end

    function wifi.update()
    awful.spawn.easy_async_with_shell("iwgetid -r", function(wifi,out1)
        wifi_now = wifi
    end)
    
    wifi_now = wifi_now or "No connection"
    if wifi_now == "" then wifi_now = "No connection" end
    widget = wifi.widget
    settings()
    end

    helpers.newtimer("wifi_now", timeout, wifi.update)

    return wifi
end

return factory
